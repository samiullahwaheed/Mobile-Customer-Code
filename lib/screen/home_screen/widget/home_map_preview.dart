import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapPreview extends StatefulWidget {
  final List<List<double>> merchantList; // [lat, long]

  const HomeMapPreview({super.key, required this.merchantList});

  @override
  State<HomeMapPreview> createState() => _HomeMapPreviewState();
}

class _HomeMapPreviewState extends State<HomeMapPreview> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  CameraPosition? _initialPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }
  

  @override
  void didUpdateWidget(covariant HomeMapPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.merchantList != oldWidget.merchantList) {
      _initializeMap();
    }
  }

  Future<void> _initializeMap() async {
    try {
      _markers = _buildMarkers(widget.merchantList);

      final LatLng? userLocation = await _getUserLocation();

      if (userLocation != null) {
        _initialPosition = CameraPosition(target: userLocation, zoom: 13);
      } else if (_markers.isNotEmpty) {
        final first = _markers.first.position;
        _initialPosition = CameraPosition(target: first, zoom: 12);
      } else {
        // No user location, no markers — show a neutral world view
        // instead of biasing to any specific country.
        _initialPosition = const CameraPosition(
          target: LatLng(0, 0),
          zoom: 1,
        );
      }
    } catch (_) {
      _initialPosition = const CameraPosition(
        target: LatLng(0, 0),
        zoom: 1,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Set<Marker> _buildMarkers(List<List<double>> data) {
    if (data.isEmpty) return {};

    final Set<Marker> markers = {};
    for (int i = 0; i < data.length; i++) {
      final loc = data[i];
      if (loc.length < 2) continue;
      final lat = loc[0];
      final lng = loc[1];
      if (lat == 0.0 && lng == 0.0) continue;

      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }
    return markers;
  }

  Future<LatLng?> _getUserLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _initialPosition == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return AbsorbPointer(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition!,
        markers: _markers,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        compassEnabled: false,
        liteModeEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.future.then((controller) => controller.dispose());
    super.dispose();
  }
}
