import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/service/api_service/api_services.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

/// Logged-in account calls: Google sign-up steps (referral, phone) and the
/// delete-account code for accounts without a password.
/// Backend error messages are shown by [ApiServices].
class AccountRepository {
  AccountRepository._();
  static final AccountRepository _instance = AccountRepository._();
  static AccountRepository get instance => _instance;

  final ApiServices apiServices = ApiServices.instance;

  Future<bool> _post(String url, [Map<String, dynamic>? body]) async {
    try {
      final response = await apiServices.apiPostServices(url: url, body: body);
      return response != null;
    } catch (e) {
      AppPrint.appError(e, title: "AccountRepository $url");
      return false;
    }
  }

  /// Links a referral to the logged-in user (Google sign-up).
  Future<bool> applyReferral({required String referralId}) =>
      _post(AppApiEndPoint.instance.referralApply, {"referralId": referralId});

  /// Sends an SMS code to confirm [phone] (Google sign-up).
  Future<bool> sendPhoneOtp({required String phone}) =>
      _post(AppApiEndPoint.instance.phoneSendOtp, {"phone": phone});

  /// Confirms the code and saves the phone on the account.
  Future<bool> verifyPhoneOtp({required String otp}) =>
      _post(AppApiEndPoint.instance.phoneVerifyOtp, {"oneTimeCode": otp});

  /// Sends an SMS code for deleting an account that has no password.
  Future<bool> sendDeleteAccountOtp() =>
      _post(AppApiEndPoint.instance.deleteAccountSendOtp);
}
