import 'package:flutter/material.dart';
import 'package:loyalty_customer/const/app_color.dart';
import 'package:loyalty_customer/widget/app_location_field/location_repository.dart';

class PlaceAutocompleteWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(
    String placeId,
    String description, {
    bool isCurrentLocation,
    double? lat,
    double? lng,
  })
  onPlaceSelected;
  final bool showCurrentLocation;
  final String? currentLocationAddress;
  final double? currentLocationLat;
  final double? currentLocationLng;
  final Widget? prefixIcon;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final double? maxSuggestionsHeight;
  final int? maxSuggestions;
  final bool enabled;
  final FocusNode? focusNode;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? fieldColor;
  final double? borderWidth;
  final double? borderRadius;

  const PlaceAutocompleteWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onPlaceSelected,
    this.showCurrentLocation = false,
    this.currentLocationAddress,
    this.currentLocationLat,
    this.currentLocationLng,
    this.prefixIcon,
    this.decoration,
    this.textStyle,
    this.hintStyle,
    this.contentPadding,
    this.maxSuggestionsHeight = 200,
    this.maxSuggestions,
    this.enabled = true,
    this.focusNode,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.fieldColor,
    this.borderWidth,
    this.borderRadius,
  });

  @override
  State<PlaceAutocompleteWidget> createState() =>
      _PlaceAutocompleteWidgetState();
}

class _PlaceAutocompleteWidgetState extends State<PlaceAutocompleteWidget> {
  final LocationRepository _locationRepository = LocationRepository();
  late FocusNode _focusNode;

  List<dynamic> _predictions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && mounted && !_isDisposed) {
        _handleFocus();
      } else if (!_focusNode.hasFocus && mounted && !_isDisposed) {
        _handleUnfocus();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocus() {
    if (widget.showCurrentLocation && widget.currentLocationAddress != null) {
      setState(() {
        _showSuggestions = true;
        _predictions = [
          {
            'place_id': 'current_location',
            'description': widget.currentLocationAddress!,
            'is_current_location': true,
          },
        ];
      });
    }
  }

  void _handleUnfocus() {
    // Delay hiding suggestions to allow for tap events
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted && !_isDisposed) {
        setState(() {
          _showSuggestions = false;
          _predictions = [];
        });
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (_isDisposed || !mounted) return;

    if (query.isEmpty) {
      setState(() {
        _predictions =
            widget.showCurrentLocation && widget.currentLocationAddress != null
            ? [
                {
                  'place_id': 'current_location',
                  'description': widget.currentLocationAddress!,
                  'is_current_location': true,
                },
              ]
            : [];
        _isLoading = false;
        _showSuggestions = _predictions.isNotEmpty;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    try {
      final predictions = await _locationRepository.placeAutoComplete(query);

      if (_isDisposed || !mounted) return;

      setState(() {
        List<dynamic> finalPredictions = [];

        // Add current location option if enabled
        if (widget.showCurrentLocation &&
            widget.currentLocationAddress != null) {
          finalPredictions.add({
            'place_id': 'current_location',
            'description': widget.currentLocationAddress!,
            'is_current_location': true,
          });
        }

        // Add search predictions
        finalPredictions.addAll(predictions);

        // Limit suggestions if specified
        if (widget.maxSuggestions != null &&
            finalPredictions.length > widget.maxSuggestions!) {
          finalPredictions = finalPredictions
              .take(widget.maxSuggestions!)
              .toList();
        }

        _predictions = finalPredictions;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _predictions =
              widget.showCurrentLocation &&
                  widget.currentLocationAddress != null
              ? [
                  {
                    'place_id': 'current_location',
                    'description': widget.currentLocationAddress!,
                    'is_current_location': true,
                  },
                ]
              : [];
          _isLoading = false;
        });
      }
      debugPrint('Place search error: $e');
    }
  }

  Future<void> _selectPlace(
    String placeId,
    String description,
    bool isCurrentLocation,
  ) async {
    if (_isDisposed) return;

    setState(() {
      _showSuggestions = false;
      _predictions = [];
    });

    widget.controller.text = description;

    // If current location, use the provided lat/lng
    if (isCurrentLocation) {
      widget.onPlaceSelected(
        placeId,
        description,
        isCurrentLocation: true,
        lat: widget.currentLocationLat,
        lng: widget.currentLocationLng,
      );
      _focusNode.unfocus();
      return;
    }

    // Otherwise, fetch lat/lng from Place Details API
    try {
      final placeDetails = await _locationRepository.getPlaceDetails(placeId);

      if (placeDetails != null) {
        widget.onPlaceSelected(
          placeId,
          description,
          isCurrentLocation: false,
          lat: placeDetails['lat'],
          lng: placeDetails['lng'],
        );
      } else {
        // If failed to get details, still call callback without lat/lng
        widget.onPlaceSelected(placeId, description, isCurrentLocation: false);
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
      widget.onPlaceSelected(placeId, description, isCurrentLocation: false);
    }

    _focusNode.unfocus();
  }

  Widget _buildSuggestionsList() {
    if (!_showSuggestions || _predictions.isEmpty || _isDisposed) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxSuggestionsHeight!),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.button1Dark),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _predictions.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, thickness: 1, color: AppColor.button1Light),
        itemBuilder: (context, index) {
          final prediction = _predictions[index];
          final bool isCurrentLocation =
              prediction['is_current_location'] == true;

          return InkWell(
            onTap: () => _selectPlace(
              prediction['place_id'],
              prediction['description'],
              isCurrentLocation,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    isCurrentLocation ? Icons.my_location : Icons.location_on,
                    color: isCurrentLocation
                        ? AppColor.button1Dark
                        : AppColor.button1Light,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prediction['description'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrentLocation
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: AppColor.button1Dark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isCurrentLocation)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.button1Dark.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Current',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColor.button1Dark,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!_isLoading || _isDisposed) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.button1Light),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColor.button1Light,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Searching...',
              style: TextStyle(fontSize: 14, color: AppColor.button1Light),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          cursorColor: widget.textColor ?? AppColor.button1Light,
          style:
              widget.textStyle ??
              TextStyle(
                color: widget.textColor ?? AppColor.button1Light,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          onChanged: _searchPlaces,
          onTap: _handleFocus,
          decoration:
              widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                    widget.hintStyle ??
                    TextStyle(
                      color: widget.hintColor ?? AppColor.button1Light,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                prefixIcon: widget.prefixIcon,
                contentPadding:
                    widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColor.button1Light,
                    width: widget.borderWidth ?? 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColor.button1Light,
                    width: widget.borderWidth ?? 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColor.button1Light,
                    width: widget.borderWidth ?? 1.0,
                  ),
                ),
                filled: widget.fieldColor != null,
                fillColor: widget.fieldColor,
              ),
        ),
        if (_isLoading || _showSuggestions) ...[
          const SizedBox(height: 8),
          if (_isLoading) _buildLoadingIndicator() else _buildSuggestionsList(),
        ],
      ],
    );
  }
}
