class KuickpayCheckoutModel {
  bool? success;
  String? message;
  KuickpayCheckoutData? data;

  KuickpayCheckoutModel({this.success, this.message, this.data});

  KuickpayCheckoutModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? KuickpayCheckoutData.fromJson(json['data'])
        : null;
  }
}

class KuickpayCheckoutData {
  String? redirectionUrl;
  String? orderId;
  KuickpayFormData? formData;

  KuickpayCheckoutData({this.redirectionUrl, this.orderId, this.formData});

  KuickpayCheckoutData.fromJson(Map<String, dynamic> json) {
    redirectionUrl = json['redirectionUrl'];
    orderId = json['orderId'];
    formData = json['formData'] != null
        ? KuickpayFormData.fromJson(json['formData'])
        : null;
  }
}

/// Mirrors Table 1.1 form parameters from the Kuickpay Hosted Checkout guide.
/// Every value here is already prepared/signed by OUR backend — the app never
/// sees or handles the InstitutionID's secured key.
class KuickpayFormData {
  String? institutionID;
  String? orderID;
  String? merchantName;
  String? amount;
  String? transactionDescription;
  String? customerMobileNumber;
  String? customerEmail;
  String? successUrl;
  String? failureUrl;
  String? orderDate;
  String? checkoutUrl;
  String? token;
  String? grossAmount;
  String? taxAmount;
  String? discount;
  String? signature;

  KuickpayFormData({
    this.institutionID,
    this.orderID,
    this.merchantName,
    this.amount,
    this.transactionDescription,
    this.customerMobileNumber,
    this.customerEmail,
    this.successUrl,
    this.failureUrl,
    this.orderDate,
    this.checkoutUrl,
    this.token,
    this.grossAmount,
    this.taxAmount,
    this.discount,
    this.signature,
  });

  KuickpayFormData.fromJson(Map<String, dynamic> json) {
    institutionID = json['InstitutionID'];
    orderID = json['OrderID'];
    merchantName = json['MerchantName'];
    amount = json['Amount'];
    transactionDescription = json['TransactionDescription'];
    customerMobileNumber = json['CustomerMobileNumber'];
    customerEmail = json['CustomerEmail'];
    successUrl = json['SuccessUrl'];
    failureUrl = json['FailureUrl'];
    orderDate = json['OrderDate'];
    checkoutUrl = json['CheckoutUrl'];
    token = json['Token'];
    grossAmount = json['GrossAmount'];
    taxAmount = json['TaxAmount'];
    discount = json['Discount'];
    signature = json['Signature'];
  }

  /// Converts to the exact field-name map Kuickpay expects in the POST body.
  Map<String, String> toFormMap() {
    return {
      'InstitutionID': institutionID ?? '',
      'OrderID': orderID ?? '',
      'MerchantName': merchantName ?? '',
      'Amount': amount ?? '',
      'TransactionDescription': transactionDescription ?? '',
      'CustomerMobileNumber': customerMobileNumber ?? '',
      'CustomerEmail': customerEmail ?? '',
      'SuccessUrl': successUrl ?? '',
      'FailureUrl': failureUrl ?? '',
      'OrderDate': orderDate ?? '',
      'CheckoutUrl': checkoutUrl ?? '',
      'Token': token ?? '',
      'GrossAmount': grossAmount ?? '',
      'TaxAmount': taxAmount ?? '',
      'Discount': discount ?? '',
      'Signature': signature ?? '',
    };
  }
}
