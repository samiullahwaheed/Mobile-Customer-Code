import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:loyalty_customer/widget/app_image/app_image.dart';
import 'package:loyalty_customer/utils/app_size.dart';

void showPopUpImage(BuildContext context, dynamic imageSource) {
  showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppSize.width(value: 16),
          vertical: AppSize.width(value: 40),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(AppSize.width(value: 8)),
              child: _buildImageWidget(imageSource),
            ),
            Positioned(
              top: AppSize.width(value: 8),
              right: AppSize.width(value: 8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(AppSize.width(value: 4)),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: AppSize.width(value: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildImageWidget(dynamic img) {
  if (img is String && img.isNotEmpty) {
    if (img.startsWith('http') || img.startsWith('https')) {
      // Network image - use AppImage for better handling
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AppImage(
          url: img,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      );
    } else {
      // Asset image
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AppImage(
          path: img,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      );
    }
  }

  if (img is File) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AppImage(
        filePath: img.path,
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }

  if (img is Uint8List) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        img,
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }

  return Container(
    padding: EdgeInsets.all(AppSize.width(value: 20)),
    child: Center(
      child: Text(
        "Invalid Image Source",
        style: TextStyle(
          color: Colors.grey,
          fontSize: AppSize.width(value: 14),
        ),
      ),
    ),
  );
}
