import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/screen/auth/sign_up_screen/model/country_model.dart';
import 'package:loyalty_customer/widget/app_log/app_print.dart';

class SignUpController extends GetxController {
  // Observable variable for checkbox state
  var isChecked = false.obs;

  // Function to toggle the checkbox value
  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  final _signUpKey = GlobalKey<FormState>();
  GlobalKey<FormState> get signUpKey => _signUpKey;

  Rx<CountryModelData?> selectedCountryCategory = Rx<CountryModelData?>(null);

  List<CountryModelData> countryData = countries; // আপনার লিস্ট

  //TextEditingController
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String? reffarelId;

  @override
  void onInit() {
    super.onInit();
    _controllerInisilized();
    _reffarelId();
  }

  //Functions
  Future<void> signUp() async {
    if (!signUpKey.currentState!.validate()) {
      return; // ❌ Form invalid — stop here
    }

    if (emailController.text.isNotEmpty ||
        phoneController.text.isNotEmpty ||
        countryController.text.isNotEmpty ||
        nameController.text.isNotEmpty) {
      Get.toNamed(
        AppRoutes.instance.cteatePasswordScreen,
        arguments: {
          'email': emailController.text,
          'phone': phoneController.text,
          'country': countryController.text,
          'city': cityController.text,
          'name': nameController.text,
          'reffarelId': reffarelId,
        },
      );
    }
  }

  @override
  void onClose() {
    _controllerDispose();
    super.onClose();
  }

  void _controllerDispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
  }

  void _controllerInisilized() {
    emailController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    countryController = TextEditingController();
    cityController = TextEditingController();
  }

  // ------------------- Text Field Validation Functions -------------------

  // Email Validation
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Phone Validation
  String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Please enter phone number';
    }

    if (phone.startsWith('+')) {
      // Phone validation: check if there's anything after the country code
      // User requested: if total length <= 4, show error
      if (phone.length <= 4) {
        return 'please enter valid phone number';
      }
      return null;
    }
    return null;
  }

  // Name Validation (Only letters, space allowed)
  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }

    final nameRegex = RegExp(r'^[a-zA-Z ]+$');

    if (!nameRegex.hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  // Country Name Validation (Only letters & spaces, min 2 letters)
  String? validateCountry(String? country) {
    if (country == null || country.isEmpty) {
      return 'Please enter country name';
    }

    final countryRegex = RegExp(r'^[a-zA-Z ]+$');

    if (!countryRegex.hasMatch(country)) {
      return 'Country name can only contain letters and spaces';
    }

    if (country.length < 2) {
      return 'Country name must be at least 2 characters';
    }

    return null;
  }

  /////////////------------------------------///////////////////////
  void _reffarelId() {
    reffarelId = Get.arguments;
    if (reffarelId != null && reffarelId is String) {
      AppPrint.apiResponse(reffarelId, title: "refferIdGet");
    }
  }
}
