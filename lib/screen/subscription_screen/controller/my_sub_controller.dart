import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
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
    final response = await _postRepository.salesRep(packageId: packageId);
    if (response) {
      Get.toNamed(AppRoutes.instance.waitingScreen);

      AppSnackBar.success("Sales Rep added successfully");
    } else {
      AppSnackBar.error("Failed to add Sales Rep");
    }
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
        final url = response.data!.url!;
        stripeUrl.value = url;
        _initializeWebView(url);
        AppPrint.appLog("✅ Payment package URL received: $url");
      } else {
        AppSnackBar.success("You are already subscribed");

        Get.offAllNamed(
          AppRoutes.instance.navigationScreen,
        ); // this logic implementing by mahabub

        // _showErrorSnackbar('Failed to get checkout URL');
      }
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
    try {
      final activated = await _confirmKuickpayPayment(uri.queryParameters);

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

    _showSuccessDialog();
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
    for (var attempt = 0; attempt < 4; attempt++) {
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

  /// Re-fetch everything the subscription state is rendered from.
  Future<void> _refreshAfterPayment() async {
    await Future.wait([
      _refreshUserProfile(showLoading: false),
      getSubSummary(),
      getPackageList(showLoading: false),
    ]);
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
  // void _checkConnectionSuccess(String url) {
  //   // Prevent multiple dialogs
  //   if (_dialogShown.value) return;

  //   // Check for success patterns in URL
  //   // Stripe typically redirects back after successful payment
  //   final uri = Uri.tryParse(url);
  //   if (uri != null) {
  //     // Check if URL contains success or return parameters from Stripe
  //     final hasSuccess =
  //         uri.path.contains('/success') ||
  //         uri.queryParameters.containsKey('success');
  //     final hasReturn =
  //         uri.path.contains('/return') ||
  //         uri.queryParameters.containsKey('return');

  //     if (hasSuccess || hasReturn) {
  //       _dialogShown.value = true;

  //       _showSuccessDialog();
  //     }
  //   }
  // }

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

  /// Package ids the user currently holds an ACTIVE subscription for.
  Set<String> get _activePackageIds {
    final subs = profileValue.value?.subscriptions ?? [];
    return subs
        .where((sub) {
      if ((sub.status ?? '').toLowerCase() != 'active') return false;
      final end = DateTime.tryParse(sub.endDate ?? '');
      if (end != null && end.isBefore(DateTime.now())) return false;
      return (sub.packageId ?? '').isNotEmpty;
    })
        .map((sub) => sub.packageId!)
        .toSet();
  }

  /// true  -> show "Choose Plan" (user can buy this package)
  /// false -> show "Claimed"    (already subscribed / not available)
  ///
  /// Previously this was driven by the card's list index and by matching plan
  /// TITLES, which meant a freshly bought package still rendered as buyable.
  /// It is now driven by the actual active subscription package ids that come
  /// back from /user/profile.
  bool isPlanClaimed(num? price, String? value, int index, {String? packageId}) {
    // 👉 Already subscribed to this exact package
    if (packageId != null && _activePackageIds.contains(packageId)) {
      return false;
    }

    // 👉 Free plan can only ever be used once
    if (profileValue.value?.hasUsedFreePlan == true && price == 0) {
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