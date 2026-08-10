import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/const/assets_icons_path.dart';
import 'package:loyalty_customer/utils/app_size.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;
  final String hint;
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    this.selectedValue,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      padding: EdgeInsets.symmetric(vertical: AppSize.width(value: 4)),
      initialValue: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        // Default border (when not focused or enabled)
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.button1Dark),
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
        ),
        // Border when enabled but not focused
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.button1Dark),
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
        ),
        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.button1Dark),
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
        ),
        // Border when there's an error
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.button5Dark),
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
        ),
        // Border when focused and there's an error
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.button5Dark),
          borderRadius: BorderRadius.circular(AppSize.width(value: 12)),
        ),
      ),
      style: TextStyle(color: AppColor.button1Dark),
      hint: Text(
        hint,
        style: TextStyle(color: AppColor.button1Dark.withValues(alpha: 0.5)),
      ),
      items: items.map((T value) {
        return DropdownMenuItem<T>(value: value, child: Text(value.toString()));
      }).toList(),
      onChanged: onChanged,
      dropdownColor: AppColor.button1Light,

      icon: AppImage(
        path: AssetsPath.arrowDown,
        color: AppColor.button1Dark.withValues(alpha: 0.5),
        width: AppSize.width(value: 18),
        height: AppSize.width(value: 18),
      ),
    );
  }
}
