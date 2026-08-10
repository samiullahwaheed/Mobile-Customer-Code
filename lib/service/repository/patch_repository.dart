import 'package:loyalty_customer/const/app_api_end_point.dart';
import 'package:loyalty_customer/service/api_service/api_services.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class PatchRepository {
  PatchRepository._();
  static final PatchRepository _instance = PatchRepository._();
  static PatchRepository get instance => _instance;

  final ApiServices apiServices = ApiServices.instance;

  Future<bool> readNotification() async {
    try {
      final response = await apiServices.apiPatchServices(
        url: AppApiEndPoint.instance.notificationRead,
      );
      if (response != null && response["data"] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      AppPrint.appError(e, title: "readNotification");
    }
    return false;
  }
}
