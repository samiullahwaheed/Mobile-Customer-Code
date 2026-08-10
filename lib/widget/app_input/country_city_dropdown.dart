import 'package:flutter/material.dart';

class CountryCityDropdown extends StatefulWidget {
  final Function(String?)? onCountryChanged;
  final Function(String?)? onCityChanged;

  final Color fillColor;
  final Color textColor;
  final Color borderColor;

  final double height;
  final double width;
  final double borderRadius;

  /// 👇 pre-selected values
  final String? initialCountry;
  final String? initialCity;
  final bool isTitleShow;

  const CountryCityDropdown({
    super.key,
    this.onCountryChanged,
    this.onCityChanged,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    this.height = 34,
    this.width = double.infinity,
    this.borderRadius = 6,
    this.initialCountry,
    this.initialCity,
    this.isTitleShow = true,
  });

  @override
  State<CountryCityDropdown> createState() => _CountryCityDropdownState();
}

class _CountryCityDropdownState extends State<CountryCityDropdown> {
  String? selectedCountry;
  String? selectedCity;

  List<String> cities = [];

  final Map<String, List<String>> countryCityData = const {
    "Pakistan": [
      "Islamabad",
      "Karachi",
      "Lahore",
      "Peshawar",
      "Quetta",
      "Rawalpindi",
    ],
  };

  @override
  void initState() {
    super.initState();

    /// 👇 set initial country
    selectedCountry = widget.initialCountry;

    if (selectedCountry != null &&
        countryCityData.containsKey(selectedCountry)) {
      cities = countryCityData[selectedCountry]!;

      /// 👇 set initial city if valid
      if (widget.initialCity != null && cities.contains(widget.initialCity)) {
        selectedCity = widget.initialCity;
      }
    }
  }

  Widget buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: widget.fillColor,
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: widget.textColor)),
          isExpanded: true,
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(color: widget.textColor)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isTitleShow)
          const Text(
            "Country",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
        const SizedBox(height: 4),

        buildDropdown(
          hint: "Select Country",
          value: selectedCountry,
          items: countryCityData.keys.toList(),
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
              cities = countryCityData[value] ?? [];
              selectedCity = null;
            });

            widget.onCountryChanged?.call(value);
          },
        ),

        const SizedBox(height: 12),

        if (widget.isTitleShow)
          const Text(
            "City",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
        const SizedBox(height: 4),

        buildDropdown(
          hint: "Select City",
          value: selectedCity,
          items: cities,
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });

            widget.onCityChanged?.call(value);
          },
        ),
      ],
    );
  }
}
