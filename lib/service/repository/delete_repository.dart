import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/service/api_service/api_services.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class DeleteRepository {
  DeleteRepository._();
  static final DeleteRepository _instance = DeleteRepository._();
  static DeleteRepository get instance => _instance;

  final ApiServices apiServices = ApiServices.instance;

  Future<bool> deleteAccount({required String password}) async {
    try {
      final response = await apiServices.apiDeleteServices(
        url: AppApiEndPoint.instance.deleteAccount,
        body: {"password": password},
      );
      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e.toString(), title: "deleteAccount");
    }
    return false;
  }
}
