import 'package:get/get.dart';
import 'package:loyalty_customer/const/privacy_policy_content.dart';
import 'package:loyalty_customer/const/terms_and_conditions_content.dart';
import 'package:loyalty_customer/const/user_manual_content.dart';
import 'package:loyalty_customer/service/repository/get_repository.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class PrivicyPolicyController extends GetxController {
  GetRepository getRepository = GetRepository.instance;

  static const String _privacyPolicyEndpoint = "customer-privacy-policy";
  static const String _termsAndConditionsEndpoint =
      "customer-terms-and-conditions";
  static const String _userManualEndpoint = "customer-user-manual";

  String? privacy;
  String? content;

  RxBool isLoading = false.obs;

  Future<void> getRules() async {
    // The Privacy Policy is a legal document, so it is always served from
    // the bundled static content rather than the CMS-driven endpoint used
    // for other rules (e.g. Terms & Conditions).
    if (privacy == _privacyPolicyEndpoint) {
      content = kPrivacyPolicyHtml;
      return;
    }

    // The Terms & Conditions are a legal document, so they are always
    // served from the bundled static content, matching how the Privacy
    // Policy is handled above.
    if (privacy == _termsAndConditionsEndpoint) {
      content = kTermsAndConditionsHtml;
      return;
    }

    // The User Manual is a bundled reference document, so it is served
    // from static content rather than the CMS-driven endpoint, matching
    // how the Privacy Policy is handled above.
    if (privacy == _userManualEndpoint) {
      content = kUserManualHtml;
      return;
    }

    try {
      isLoading.value = true;
      final response = await getRepository.getRules(privacy ?? "");
      if (response != null) {
        content = response;
        AppPrint.apiResponse(content, title: "Rules content");
      }
    } catch (e) {
      AppPrint.appError(e, title: "Rules Error");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    privacy = _augumentRecived();
    getRules();
    super.onInit();
  }

  _augumentRecived() => Get.arguments['endpoint'];
}
