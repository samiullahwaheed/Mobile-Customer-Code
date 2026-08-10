import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_const.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:phone_form_field/phone_form_field.dart';

enum InputFieldType { email, phone }

class EmailAndPhoneField extends StatefulWidget {
  const EmailAndPhoneField({
    super.key,
    this.hintText,
    this.prefix,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.controller,
    this.fillColor,
    this.elevation = 0.0,
    this.elevationColor,
    this.minLines = 1,
    this.readOnly = false,
    this.border,
    this.errBorder,
    this.borderRadius,
    this.contentPadding,
    this.style,
    this.maxLines,
    this.onFieldSubmitted,
    this.onTap,
    this.onChanged,
    this.isOptional = false,
    this.title,
    this.validator,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.textAlignVertical,
    this.filled = true,
    this.defaultType = InputFieldType.email,
    this.showTypeSelector = true,
    this.allowedCountryCodes = const ['PK'],
    this.defaultCountryCode = 'PK',
    this.alwaysPhone = false,
  });

  final String? hintText;
  final Widget? prefix;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final Color? fillColor;
  final bool filled;
  final double elevation;
  final Color? elevationColor;
  final int minLines;
  final int? maxLines;
  final InputBorder? border;
  final InputBorder? errBorder;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextAlignVertical? textAlignVertical;
  final bool isOptional;
  final String? title;
  final FormFieldValidator<String>? validator;
  final InputFieldType defaultType;
  final bool showTypeSelector;
  final List<String> allowedCountryCodes;
  final String defaultCountryCode;
  final bool alwaysPhone;

  @override
  State<EmailAndPhoneField> createState() => _EmailAndPhoneFieldState();
}

class _EmailAndPhoneFieldState extends State<EmailAndPhoneField>
    with SingleTickerProviderStateMixin {
  late InputFieldType _selectedType;
  late PhoneController _phoneController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // alwaysPhone true hole phone set kora, nahole defaultType use kora
    _selectedType = widget.alwaysPhone
        ? InputFieldType.phone
        : widget.defaultType;

    // Animation controller setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _phoneController = PhoneController(
      initialValue: PhoneNumber(
        isoCode: IsoCode.fromJson(widget.defaultCountryCode),
        nsn: '',
      ),
    );

    _phoneController.addListener(_syncPhoneToText);

    // Initial animation
    _animationController.forward();
  }

  void _syncPhoneToText() {
    if (_selectedType == InputFieldType.phone && widget.controller != null) {
      final phoneNumber = _phoneController.value;
      widget.controller!.text = phoneNumber.international;
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_syncPhoneToText);
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _changeInputType(InputFieldType newType) {
    if (_selectedType != newType) {
      setState(() {
        _animationController.reset();
        _selectedType = newType;
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen width থেকে dynamic max width calculate করা
    final screenWidth = MediaQuery.of(context).size.width;
    final dynamicMaxWidth = screenWidth * 0.25; // Screen width এর 25%

    return Material(
      elevation: widget.elevation,
      shadowColor: widget.elevationColor,
      borderOnForeground: false,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(
        AppSize.width(value: widget.borderRadius ?? 8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Row(
              children: [
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: AppSize.width(value: 14),
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppConst.fontFamily1,
                  ),
                ),
                if (!widget.isOptional)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: AppSize.width(value: 14),
                      fontFamily: AppConst.fontFamily1,
                    ),
                  ),
              ],
            ),
          if (widget.title != null) const SizedBox(height: 8),

          // Animated field switcher
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: widget.alwaysPhone
                    ? _buildPhoneField(dynamicMaxWidth)
                    : (_selectedType == InputFieldType.email
                          ? _buildEmailField(dynamicMaxWidth)
                          : _buildPhoneField(dynamicMaxWidth)),
              ),
            ),
          ),

          // alwaysPhone true na hole radio button show hobe
          if (widget.showTypeSelector && !widget.alwaysPhone)
            const SizedBox(height: 12),
          if (widget.showTypeSelector && !widget.alwaysPhone)
            Row(
              children: [
                _buildRadioButton(InputFieldType.email, 'Email'),
                const SizedBox(width: 20),
                _buildRadioButton(InputFieldType.phone, 'Phone'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(InputFieldType type, String label) {
    final bool isSelected = _selectedType == type;

    return InkWell(
      onTap: () => _changeInputType(type),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey,
                width: 2,
              ),
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: AppSize.width(value: 14),
              fontFamily: AppConst.fontFamily1,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(double dynamicMaxWidth) {
    return TextFormField(
      cursorColor: Colors.black,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      readOnly: widget.readOnly,
      controller: widget.controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
      validator: widget.validator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: widget.textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
      style:
          widget.style ??
          TextStyle(
            height: 2,
            fontFamily: AppConst.fontFamily1,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
      decoration: _buildInputDecoration(
        'Enter email',
        isPhone: false,
        dynamicMaxWidth: dynamicMaxWidth,
      ),
    );
  }

  Widget _buildPhoneField(double dynamicMaxWidth) {
    return PhoneFormField(
      controller: _phoneController,
      enabled: !widget.readOnly,
      // Phone number validation - country specific length check
      validator: (phoneNumber) {
        // প্রথমে custom validator check করা
        if (widget.validator != null && widget.controller != null) {
          final customError = widget.validator!(widget.controller!.text);
          if (customError != null) return customError;
        }

        // Phone number validation
        if (phoneNumber == null) {
          return widget.isOptional ? null : 'Phone number is required';
        }

        // Check if phone number is valid for the selected country
        if (!phoneNumber.isValid()) {
          return 'Invalid phone number for ${phoneNumber.isoCode.name}';
        }

        return null;
      },
      onChanged: (phoneNumber) {
        if (widget.controller != null) {
          widget.controller!.text = phoneNumber.international;
          if (widget.onChanged != null) {
            widget.onChanged!(phoneNumber.international);
          }
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      countrySelectorNavigator: CountrySelectorNavigator.dialog(
        height: 300,
        backgroundColor: Colors.white,
        countries: widget.allowedCountryCodes
            .map((code) => IsoCode.fromJson(code))
            .toList(),
      ),
      decoration: _buildInputDecoration(
        'Enter phone number',
        isPhone: true,
        // dynamicMaxWidth: dynamicMaxWidth,
        dynamicMaxWidth: AppSize.width(value: 140),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String defaultHint, {
    required bool isPhone,
    double? dynamicMaxWidth,
  }) {
    return InputDecoration(
      hintText: widget.hintText ?? defaultHint,
      hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Colors.black.withValues(alpha: .5),
      ),
      filled: widget.filled,
      fillColor: widget.fillColor ?? Colors.white,
      contentPadding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      prefixIcon: widget.prefix != null
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: widget.prefix,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      // Phone field এর জন্য dynamic max width
      prefixIconConstraints: isPhone
          ? BoxConstraints(minWidth: 0, maxWidth: dynamicMaxWidth ?? 100)
          : (widget.prefixIconConstraints ??
                const BoxConstraints(maxWidth: 40, maxHeight: 40)),
      suffixIconConstraints:
          widget.suffixIconConstraints ??
          const BoxConstraints(maxWidth: 40, maxHeight: 40),
      border:
          widget.border ??
          OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
          ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
      ),
      errorBorder:
          widget.errBorder ??
          OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
          ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
      ),
    );
  }
}

// Usage Example:
/*
final _contactController = TextEditingController();

// Example 1: Normal use with email/phone toggle
EmailAndPhoneField(
  title: 'Contact Information',
  controller: _contactController,
  defaultType: InputFieldType.phone,
  showTypeSelector: true,
  allowedCountryCodes: ['PK', 'BD', 'IN', 'US'],
  defaultCountryCode: 'BD',
  fillColor: Colors.grey[100],
  borderRadius: 10,
  isOptional: false,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  },
  onChanged: (value) {
    print('Contact changed: $value');
  },
)

// Example 2: Always phone only (no radio button, no email option)
EmailAndPhoneField(
  title: 'Phone Number',
  controller: _contactController,
  alwaysPhone: true, // শুধু phone field দেখাবে
  allowedCountryCodes: ['PK', 'BD', 'IN', 'US'],
  defaultCountryCode: 'BD',
  fillColor: Colors.grey[100],
  borderRadius: 10,
  isOptional: false,
  onChanged: (value) {
    print('Phone: $value');
  },
)
*/
