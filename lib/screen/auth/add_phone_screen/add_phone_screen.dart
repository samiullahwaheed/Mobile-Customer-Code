import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/routes/app_routes.dart';
import 'package:loyalty_customer/service/api_service/get_storage_services.dart';
import 'package:loyalty_customer/service/repository/account_repository.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_button/app_button.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/widget/app_input/email_and_phone_field.dart';
import 'package:loyalty_customer/widget/app_text/app_text.dart';

/// Google sign-up step: add a phone number, confirmed on the OTP screen.
class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({super.key});

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Same rule as the email sign-up phone field
  String? _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Please enter phone number';
    if (phone.startsWith('+') && phone.length <= 4) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  Future<void> _sendCode() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    setState(() => _isLoading = true);
    final sent = await AccountRepository.instance.sendPhoneOtp(phone: phone);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (sent) {
      Get.toNamed(
        AppRoutes.instance.verifyOtpScreen,
        arguments: {"phone": phone, "linkPhone": true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfacePrimaryLight,
      body: SingleChildScrollView(
        child: Column(
          spacing: AppSize.size.height * 0.02,
          children: [
            Stack(
              children: [
                AppImage(path: AssetsPath.backgroundImage),
                Positioned(
                  top: AppSize.size.height * 0.07,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AppImage(
                      width: AppSize.width(value: 230),
                      height: AppSize.width(value: 230),
                      path: AssetsPath.authImg2,
                    ),
                  ),
                ),
              ],
            ),
            AppText(
              data: "Add Your Phone Number",
              fontSize: AppSize.width(value: 28),
              fontWeight: FontWeight.w700,
              color: AppColor.button4Dark,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 30)),
              child: AppText(
                data:
                    "We'll send you a code to verify it. You can also use this number to reset your password.",
                maxLines: 3,
                textAlign: TextAlign.center,
                fontSize: AppSize.width(value: 16),
                fontWeight: FontWeight.w400,
                color: AppColor.button4Dark,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSize.width(value: 16)),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: AppSize.size.height * 0.02,
                  children: [
                    EmailAndPhoneField(
                      controller: _phoneController,
                      alwaysPhone: true,
                      allowedCountryCodes: const ["PK"],
                      defaultCountryCode: 'PK',
                      fillColor: Colors.grey[100],
                      borderRadius: 24,
                      isOptional: false,
                      validator: _validatePhone,
                    ),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton(
                            onTap: _sendCode,
                            height: 56,
                            title: "Send Code",
                            titleSize: 20,
                            borderRadius: BorderRadius.circular(30),
                          ),
                    // Way out if the wrong Google account was picked
                    TextButton(
                      onPressed: () =>
                          GetStorageServices.instance.completeLogout(),
                      child: AppText(
                        data: "Use a different account",
                        fontSize: AppSize.width(value: 16),
                        fontWeight: FontWeight.w600,
                        color: AppColor.button5Dark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
