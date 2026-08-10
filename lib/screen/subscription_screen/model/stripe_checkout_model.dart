class StripeCheckoutModel {
  bool? success;
  String? message;
  StripeData? data;

  StripeCheckoutModel({this.success, this.message, this.data});

  StripeCheckoutModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? StripeData.fromJson(json['data']) : null;
  }
}

class StripeData {
  String? sessionId;
  String? url;

  StripeData({this.sessionId, this.url});

  StripeData.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    url = json['url'];
  }
}
