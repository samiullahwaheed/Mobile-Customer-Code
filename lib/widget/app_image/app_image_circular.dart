import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppImageCircular extends StatelessWidget {
  const AppImageCircular({
    super.key,
    this.color = Colors.pinkAccent,
    this.fit = BoxFit.cover,
    this.height,
    this.path,
    this.url,
    this.width,
    this.filePath,
    this.borderRadius = 100,
    this.borderColor = Colors.transparent,
  });

  final String? path;
  final String? filePath;
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    // >>>>>>>>>>>>>>>>>>>>>> File image <<<<<<<<<<<<<<<<<<<<<<
    if (filePath != null) {
      return _wrapper(
        Image.file(
          File(filePath!),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, error, __) {
            log("Error loading file image: $error");
            return _buildDefaultImage();
          },
        ),
      );
    }

    // >>>>>>>>>>>>>>>>>>>>>> Network image (CACHED) <<<<<<<<<<<<<<<<<<<<<<
    if (url != null && url!.isNotEmpty) {
      String imageUrl = url!;
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'https://$imageUrl';
      }

      return _wrapper(
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, _) => _buildShimmer(),
          errorWidget: (context, _, error) {
            log("Error loading cached network image: $error");
            return _buildDefaultImage();
          },
        ),
      );
    }

    // >>>>>>>>>>>>>>>>>>>>>> Asset image <<<<<<<<<<<<<<<<<<<<<<
    if (path != null) {
      return _wrapper(
        Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, error, __) {
            log("Error loading asset image: $error");
            return _buildDefaultImage();
          },
        ),
      );
    }

    // >>>>>>>>>>>>>>>>>>>>>> No image source <<<<<<<<<<<<<<<<<<<<<<
    return _buildDefaultImage();
  }

  // ================= Wrapper =================
  Widget _wrapper(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }

  // ================= Shimmer Widget =================
  Widget _buildShimmer() {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(milliseconds: 300),
      color: Colors.white,
      colorOpacity: 0.3,
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // ================= Default / Error Widget =================
  Widget _buildDefaultImage() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Icon(
          Icons.account_circle,
          size: width != null ? width! * 0.7 : 50,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
