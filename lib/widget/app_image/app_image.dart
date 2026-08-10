import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loyalty_customer/const/app_api_end_point.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.color,
    this.fit = BoxFit.cover,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.iconColor,
    this.isZomBle = false,
    this.defaultAssetImage, // ✅ NEW PARAM
  });

  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Color? color;
  final Color? iconColor;
  final bool isZomBle;

  /// ✅ Optional custom default image (asset path)
  final String? defaultAssetImage;

  @override
  Widget build(BuildContext context) {
    /// ---------------- FILE IMAGE ----------------
    if (filePath != null && filePath!.isNotEmpty) {
      return _wrapZoom(
        context,
        Image.file(
          File(filePath!),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _defaultPlaceholder(),
        ),
      );
    }

    /// ---------------- NETWORK IMAGE ----------------
    if (url != null && url!.isNotEmpty) {
      return _wrapZoom(
        context,
        NetworkImageWithRetry(
          imageUrl: url!,
          width: width,
          height: height,
          fit: fit,
          defaultAssetImage: defaultAssetImage,
        ),
      );
    }

    /// ---------------- ASSET IMAGE ----------------
    if (path != null && path!.isNotEmpty) {
      return _wrapZoom(
        context,
        Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          color: iconColor,
          errorBuilder: (_, __, ___) => _defaultPlaceholder(),
        ),
      );
    }

    /// ---------------- DEFAULT ----------------
    return _defaultPlaceholder();
  }

  /// Zoom Wrapper
  Widget _wrapZoom(BuildContext context, Widget child) {
    if (!isZomBle) return child;

    return GestureDetector(
      onTap: () {
        _showFullScreenImage(context, child);
      },
      child: child,
    );
  }

  /// ✅ Default Light Grey Placeholder With Icon
  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200, // Light grey background
      child: Center(
        child: defaultAssetImage != null
            ? Image.asset(
          defaultAssetImage!,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        )
            : Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, Widget imageWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageViewer(image: imageWidget),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// FULL SCREEN VIEWER (unchanged)
////////////////////////////////////////////////////////////

class FullScreenImageViewer extends StatelessWidget {
  final Widget image;

  const FullScreenImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(child: image),
    );
  }
}

////////////////////////////////////////////////////////////
/// NETWORK IMAGE WITH RETRY (Modified)
////////////////////////////////////////////////////////////

class NetworkImageWithRetry extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? defaultAssetImage;

  const NetworkImageWithRetry({
    super.key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.defaultAssetImage,
  });

  @override
  State<NetworkImageWithRetry> createState() => _NetworkImageWithRetryState();
}

class _NetworkImageWithRetryState extends State<NetworkImageWithRetry>
    with AutomaticKeepAliveClientMixin {
  int retryCount = 0;
  final int maxRetries = 3;
  late String _image;

  @override
  void initState() {
    super.initState();
    _setImage();
  }

  void _setImage() {
    try {
      // mediaUrl() khud hi check kar leta hai ke path pehle se absolute URL
      // hai ya relative. Is liye yahan alag se Uri parse karne ki zaroorat
      // nahi rahi.
      _image = AppApiEndPoint.mediaUrl(widget.imageUrl);
    } catch (e) {
      log("Error setting image URL: $e");
      _image = widget.imageUrl;
    }
  }

  void _retry() {
    if (retryCount < maxRetries) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            retryCount++;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: optimizedImageUrl(_image),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      placeholder: (_, __) => _loadingPlaceholder(),
      errorWidget: (_, __, ___) {
        _retry();
        return _defaultPlaceholder();
      },
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade200,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey.shade200,
      child: Center(
        child: widget.defaultAssetImage != null
            ? Image.asset(widget.defaultAssetImage!, width: 40, height: 40)
            : Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

////////////////////////////////////////////////////////////
/// CACHE MANAGER
////////////////////////////////////////////////////////////

class CustomCacheManager extends CacheManager {
  static const key = "optimizedCache";

  static final CustomCacheManager instance = CustomCacheManager._();

  CustomCacheManager._()
      : super(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 300,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

String optimizedImageUrl(String url, {int width = 600, int height = 600}) {
  return "$url?width=$width&height=$height";
}