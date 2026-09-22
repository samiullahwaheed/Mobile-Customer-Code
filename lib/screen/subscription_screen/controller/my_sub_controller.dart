import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/home_screen/controller/home_controller.dart';
import 'package:loyalty_customer/screen/home_screen/model/subscription_summery_model.dart';
import 'package:loyalty_customer/screen/profile_section/profile_screen/model/profile_model.dart';
import 'package:loyalty_customer/screen/subscription_screen/model/package_list_model.dart';
import 'package:loyalty_customer/screen/subscription_screen/model/stripe_checkout_model.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/service/repository/post_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:loyalty_customer/widget/app_snackbar/app_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MySubController extends GetxController {
  final GetRepository _getRepository = GetRepository.instance;
  final PostRepository _postRepository = PostRepository.instance;

  TextEditingController tokenController = TextEditingController();
  GetStorageServices storageServices = GetStorageServices.instance;

  // Error code constants for iOS/Android network errors
  static const int _kNetworkNotAvailable = -1009; // iOS
  static const int _kCannotFindHost = -1003; // iOS

  // Observable lists and states
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  Rxn<ProfileModelData> profileValue = Rxn<ProfileModelData>();
  RxBool isLoading = false.obs;
  RxBool isPaymentLoading = false.obs;

  // WebView related observables
  RxString stripeUrl = ''.obs;
  WebViewController? webViewController;

  // Flag to prevent multiple dialogs
  final RxBool _dialogShown = false.obs;

  /// Order id of the Kuickpay checkout currently open in the WebView. We need it
  /// to confirm the payment with our own backend once the WebView comes back.
  String? _currentKuickpayOrderId;
  final int value1 = Get.arguments['value'];

  @override
  void onInit() {
    tokenController = TextEditingController();
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;

    await Future.wait([
      getPackageList(showLoading: false),
      _refreshUserProfile(showLoading: false),
    ]);
    // Always load the summary: the "Claimed" state on the package cards depends
    // on it, so loading it only for value1 == 1 left the screen showing an
    // already-purchased plan as still buyable.
    await getSubSummary();

    isLoading.value = false;
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  // -------------- Subscription get package list --------------
  Future<void> getPackageList({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final packageList = await _getRepository.getPackageList();
    if (packageList.isNotEmpty) {
      this.packageList.value = packageList;
    }
    if (showLoading) isLoading.value = false;
  }

  void salesRep({required String packageId}) async {
    final customerId = profileValue.value?.id;

    if (customerId != null && customerId.isNotEmpty) {
      final latestRequest = await _getRepository.getLatestSalesRepRequest(
        customerId: customerId,
      );

      if (latestRequest != null && _wasCreatedToday(latestRequest['createdAt'])) {
        final subscriptionStatus = latestRequest['subscriptionStatus']?.toString();

        if (subscriptionStatus == 'active') {
          // Already upgraded once today — backend silently ignores a second
          // request on the same day, so block it here with a clear message.
          AppSnackBar.error("You cannot upgrade your plan through the sales representative twice in a day.");
        } else {
          // Previous request today is still awaiting sales-rep approval.
          AppSnackBar.message(
            "You already have a pending upgrade request awaiting approval.",
          );
          Get.toNamed(AppRoutes.instance.waitingScreen);
        }
        return;
      }
    }

    final response = await _postRepository.salesRep(packageId: packageId);
    if (response) {
      Get.toNamed(AppRoutes.instance.waitingScreen);

      AppSnackBar.success("Sales Rep added successfully");
    } else {
      AppSnackBar.error("Failed to add Sales Rep");
    }
  }

  bool _wasCreatedToday(dynamic createdAt) {
    final date = DateTime.tryParse(createdAt?.toString() ?? '')?.toLocal();
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // -------------- Subscription payment with WebView --------------
  Future<void> paymentPackage({required String packageId}) async {
    try {
      isPaymentLoading.value = true;
      _dialogShown.value = false; // Reset dialog flag

      StripeCheckoutModel? response = await _postRepository.paymentPackage(
        packageId: packageId,
      );

      if (response != null &&
          response.success == true &&
          response.data?.url != null) {
        // Paid plan — Stripe checkout
        final url = response.data!.url!;
        stripeUrl.value = url;
        _initializeWebView(url);
        AppPrint.appLog("✅ Payment package URL received: $url");
      } else if (response != null && response.success == true) {
        // Free plan — activated directly, no checkout redirect involved
        await _refreshAfterPayment();
        AppSnackBar.success(
          response.message ?? "Your free plan has been activated!",
        );
        Get.offAllNamed(AppRoutes.instance.navigationScreen);
      }
      // response == null means the request failed (e.g. free plan already
      // used, or a network error) — apiPostServices already surfaces that
      // message itself, so there's nothing further to show here.
    } catch (e) {
      _showErrorSnackbar('An error occurred: $e');
      AppPrint.appError(e, title: "Payment Package Error");
    } finally {
      isPaymentLoading.value = false;
    }
  }

  /// Initialize WebView with Stripe URL
  void _initializeWebView(String url) {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            AppPrint.appLog('📄 Stripe page started loading: $url');
          },
          onPageFinished: (String url) {
            AppPrint.appLog('✅ Stripe page finished loading: $url');
            _checkConnectionSuccess(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            AppPrint.appLog('🔗 Navigation to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            AppPrint.appError('❌ WebView error: ${error.description}');
            // Platform-specific error handling for iOS and Android
            if (error.errorCode == _kNetworkNotAvailable ||
                error.errorCode == _kCannotFindHost) {
              Get.snackbar(
                'Connection Error',
                'Please check your internet connection',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade100,
                colorText: Colors.red.shade900,
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  // -------------- Subscription payment with Kuickpay (local payment method) --------------
  Future<void> paymentPackageKuickpay({required String packageId}) async {
    try {
      isPaymentLoading.value = true;
      _dialogShown.value = false;

      final response = await _postRepository.kuickpayPaymentPackage(
        packageId: packageId,
      );

      final formData = response?.data?.formData;
      final redirectionUrl = response?.data?.redirectionUrl;

      if (response != null &&
          response.success == true &&
          formData != null &&
          redirectionUrl != null) {
        _currentKuickpayOrderId = response.data?.orderId;
        _initializeKuickpayWebView(redirectionUrl, formData.toFormMap());
        AppPrint.appLog(
          '✅ Kuickpay checkout initiated for order: ${response.data?.orderId}',
        );
      } else {
        _showErrorSnackbar(response?.message ?? 'Failed to start Kuickpay checkout');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred: $e');
      AppPrint.appError(e, title: "Kuickpay Payment Package Error");
    } finally {
      isPaymentLoading.value = false;
    }
  }

  /// Initialize WebView with a POST request carrying the Kuickpay form fields.
  /// Kuickpay's Hosted Checkout is a form-POST flow, not a plain GET redirect
  /// like Stripe, so we build and submit the body ourselves via webview_flutter's
  /// LoadRequestMethod.post support (webview_flutter >= 4.x).
  void _initializeKuickpayWebView(String url, Map<String, String> formFields) {
    final body = formFields.entries
        .map(
          (e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
    )
        .join('&');
    final bodyBytes = Uint8List.fromList(utf8.encode(body));

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            AppPrint.appLog('📄 Kuickpay page started loading: $url');
          },
          onPageFinished: (String url) {
            AppPrint.appLog('✅ Kuickpay page finished loading: $url');
            _checkKuickpayReturn(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            AppPrint.appLog('🔗 Kuickpay navigation to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            AppPrint.appError('❌ Kuickpay WebView error: ${error.description}');
            if (error.errorCode == _kNetworkNotAvailable ||
                error.errorCode == _kCannotFindHost) {
              Get.snackbar(
                'Connection Error',
                'Please check your internet connection',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade100,
                colorText: Colors.red.shade900,
              );
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(url),
        method: LoadRequestMethod.post,
        headers: const {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: bodyBytes,
      );
  }

  /// Detect our own backend's "/kuickpay/return" bridge page (hit by Kuickpay's
  /// SuccessUrl/FailureUrl redirect).
  ///
  /// IMPORTANT: we do NOT assume that page actually reached our server. The
  /// WebView can land on a tunnel/interstitial page instead, in which case the
  /// backend never activates anything and the user ends up paid-but-unsubscribed.
  /// So on success we explicitly confirm the order with our own authenticated
  /// API, and only then show the success screen.
  Future<void> _checkKuickpayReturn(String url) async {
    if (_dialogShown.value) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (!uri.path.toLowerCase().contains('kuickpay/return')) return;

    final responseCode = uri.queryParameters['ResponseCode'];
    _dialogShown.value = true;

    if (responseCode != '00') {
      AppPrint.appLog('⚠️ Kuickpay Payment Failed/Cancelled: $url');
      Get.snackbar(
        'Payment Failed',
        'Your Kuickpay payment could not be completed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      Get.back();
      return;
    }

    AppPrint.appLog('🎉 Kuickpay Payment Success Detected: $url');

    isPaymentLoading.value = true;
    bool activated = false;
    try {
      activated = await _confirmKuickpayPayment(uri.queryParameters);

      // Whether or not the confirm call succeeded, pull fresh data so the
      // membership + home screens never show stale "No Subscription".
      await _refreshAfterPayment();

      if (!activated) {
        AppSnackBar.error(
          'Payment received, but your membership is still being activated. '
              'Please pull to refresh in a moment.',
        );
      }
    } finally {
      isPaymentLoading.value = false;
    }

    if (activated) {
      _showSuccessDialog();
    } else {
      Get.back();
    }
  }

  /// Confirm with our backend, then poll briefly in case activation is coming
  /// from Kuickpay's server-to-server IPN instead.
  Future<bool> _confirmKuickpayPayment(Map<String, String> returnParams) async {
    final params = Map<String, String>.from(returnParams);

    // Kuickpay does echo the OrderId back, but keep our own copy as a fallback.
    if ((params['OrderId'] ?? '').isEmpty && _currentKuickpayOrderId != null) {
      params['OrderId'] = _currentKuickpayOrderId!;
    }

    final orderId = params['OrderId'];
    if (orderId == null || orderId.isEmpty) {
      AppPrint.appError('Kuickpay confirm skipped: no orderId available');
      return false;
    }

    final response = await _postRepository.kuickpayConfirmPayment(
      returnParams: params,
    );

    final data = response?['data'];
    final status = data is Map ? data['status']?.toString() : null;
    if (status == 'completed') {
      AppPrint.appLog('✅ Kuickpay order $orderId confirmed by backend');
      return true;
    }

    // Fallback: give the IPN a few seconds to land.
    for (var attempt = 0; attempt < 8; attempt++) {
      await Future.delayed(const Duration(seconds: 2));
      final polled = await _getRepository.getKuickpayOrderStatus(
        orderId: orderId,
      );
      AppPrint.appLog('⏳ Kuickpay order $orderId status: $polled');
      if (polled == 'completed') return true;
      if (polled == 'failed') return false;
    }

    return false;
  }

  /// Public entry point so flows outside this controller (e.g. the sales-rep
  /// waiting screen, once an admin approves the request and the plan
  /// activates) can trigger the same refresh a payment here would — without
  /// this, an already-open "My Membership" screen keeps showing stale data
  /// ("Choose Plan" on a package the user just got approved for) until the
  /// screen is fully torn down and rebuilt.
  Future<void> refreshAfterExternalActivation() => _refreshAfterPayment();

  /// Re-fetch everything the subscription state is rendered from.
  Future<void> _refreshAfterPayment() async {
    await Future.wait([
      _refreshUserProfile(showLoading: false),
      getSubSummary(),
      getPackageList(showLoading: false),
    ]);

    // HomeController is a long-lived singleton that only fetches its own
    // subscription summary once (onInit). Without this, the Home screen's
    // header badge keeps showing stale data (or nothing, for a first-time
    // buyer) after a purchase here until the app restarts or the user
    // manually pulls to refresh Home.
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().getSubSummary();
    }
  }

  /// Check if Stripe checkout was successful
  void _checkConnectionSuccess(String url) {
    // Prevent multiple dialogs
    if (_dialogShown.value) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final path = uri.path.toLowerCase();

    // Success URL patterns
    final isSuccess =
        path.contains("success") ||
            path.contains("payment-success") ||
            path.contains("payment_success") ||
            uri.queryParameters["success"] == "true";

    // Return URL patterns
    final isReturn =
        path.contains("return") || uri.queryParameters.containsKey("return");

    if (isSuccess || isReturn) {
      _dialogShown.value = true;

      debugPrint("🎉 Payment Success Detected: $url");

      _showSuccessDialog();
    }
  }
  
  /// Show success dialog
  void _showSuccessDialog() {
    Get.offAllNamed(AppRoutes.instance.confirmScreen);
  }

  //----------Get sub summary----------
  Rxn<UserSummaryData> subSummaryList = Rxn<UserSummaryData>();
  Future<void> getSubSummary() async {
    final response = await _getRepository.getSubscriptionSummary();
    if (response != null) {
      subSummaryList.value = response;
    } else {
      AppPrint.appError("No Sub Summary Found");
    }
  }

  /// Active (not-yet-expired) subscriptions, keyed by package id.
  Map<String, Subscription> get _activeSubscriptionsByPackageId {
    final subs = profileValue.value?.subscriptions ?? [];
    final result = <String, Subscription>{};
    for (final sub in subs) {
      if ((sub.status ?? '').toLowerCase() != 'active') continue;
      final end = DateTime.tryParse(sub.endDate ?? '');
      if (end != null && end.isBefore(DateTime.now())) continue;
      final packageId = sub.packageId;
      if (packageId == null || packageId.isEmpty) continue;
      result[packageId] = sub;
    }
    return result;
  }

  /// Days left on the current plan above which activating ANY other plan is
  /// blocked outright (see [blockNewActivation]). Tier no longer matters —
  /// once the current plan drops to this many days or fewer, switching to
  /// any plan is allowed.
  static const int _renewalWindowDays = 15;

  /// The user's highest-value currently-active subscription, looked up
  /// against packageList since Subscription itself only carries a
  /// packageId, not a price. Null when the user has no active plan.
  Subscription? get _primaryActiveSubscription {
    Subscription? primary;
    double? maxPrice;
    for (final sub in _activeSubscriptionsByPackageId.values) {
      PackageModel? pkg;
      for (final p in packageList) {
        if (p.id == sub.packageId) {
          pkg = p;
          break;
        }
      }
      if (pkg == null) continue;
      if (maxPrice == null || pkg.price > maxPrice) {
        maxPrice = pkg.price;
        primary = sub;
      }
    }
    return primary;
  }

  /// Days left on [_primaryActiveSubscription], or null if the user has no
  /// active plan.
  int? get currentPlanRemainingDays {
    final end = DateTime.tryParse(_primaryActiveSubscription?.endDate ?? '');
    return end?.difference(DateTime.now()).inDays;
  }

  /// true -> activating any other plan should be blocked with the "you
  /// already have an active membership" popup instead of opening the
  /// payment sheet. Higher/lower tier no longer matters — only how much
  /// time is left on the current plan does.
  bool get blockNewActivation {
    final days = currentPlanRemainingDays;
    if (days == null) return false;
    return days > _renewalWindowDays;
  }

  /// true  -> show "Choose Plan" (user can activate this package)
  /// false -> show "Claimed"    (this is the package the user currently holds)
  bool isPlanClaimed(num? price, String? value, int index, {String? packageId}) {
    // 👉 This exact package is the one currently active — lock its own card.
    if (packageId != null && _activeSubscriptionsByPackageId.containsKey(packageId)) {
      return false;
    }

    // 👉 Free plan is only for users who've never had ANY subscription before
    // (paid or free) — not just users who've already used a free plan.
    if (price == 0 && (profileValue.value?.totalSubscriptions ?? 0) > 0) {
      return false;
    }

    // 👉 Fallback for older data where packageId is missing: match by title
    if (packageId == null || packageId.isEmpty) {
      final titles = subSummaryList.value?.subscriptionTitles;
      if (titles != null && titles.isNotEmpty && value != null) {
        if (titles.contains(value)) return false;
      }
    }

    return true;
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      duration: const Duration(seconds: 3),
    );
  }

  /// Refresh user profile data after successful payment
  Future<void> _refreshUserProfile({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;
      final profileData = await _getRepository.getProfile();
      if (profileData != null) {
        profileValue.value = profileData;
        AppPrint.appLog('✅ Profile refreshed successfully');
        // The profile data is already handled by the repository
        // You may want to update local storage or notify other controllers here
      }
    } catch (e) {
      AppPrint.appError(e, title: 'Error refreshing profile');
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    webViewController = null;
    super.onClose();
  }
}