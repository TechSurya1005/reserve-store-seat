import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final Widget? errorWidget;
  final Widget? placeholder;
  final int? cacheWidth;
  final int? cacheHeight;
  final Color? placeholderColor;
  final Color? errorColor;

  const CacheImageNetwork({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircle = false,
    this.errorWidget,
    this.placeholder,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholderColor,
    this.errorColor,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ SAFE CALCULATION WITH NULL CHECKS
    final optimalCacheWidth =
        cacheWidth ?? _calculateOptimalCacheWidth(context);
    final optimalCacheHeight =
        cacheHeight ?? _calculateOptimalCacheHeight(context);

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      memCacheWidth: optimalCacheWidth,
      memCacheHeight: optimalCacheHeight,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
    );

    return isCircle
        ? ClipOval(child: image)
        : (borderRadius != null
              ? ClipRRect(borderRadius: borderRadius!, child: image)
              : image);
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: placeholderColor ?? Colors.grey.shade900,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      color: errorColor ?? Colors.grey.shade500,
      child: Icon(
        Icons.broken_image,
        color: Colors.grey.shade300,
        size: _calculateIconSize(),
      ),
    );
  }

  // ✅ FIXED: SAFE CALCULATION WITH INFINITY/NAN CHECKS
  int _calculateOptimalCacheWidth(BuildContext context) {
    final displayWidth = width ?? MediaQuery.of(context).size.width;

    // ✅ CHECK FOR INFINITY AND NAN
    if (displayWidth.isInfinite || displayWidth.isNaN) {
      return 300; // ✅ DEFAULT SAFE VALUE
    }

    // ✅ ENSURE POSITIVE VALUE AND REASONABLE LIMITS
    final calculatedWidth = (displayWidth * 2).ceil();
    return calculatedWidth.clamp(100, 800);
  }

  int _calculateOptimalCacheHeight(BuildContext context) {
    final displayHeight = height ?? MediaQuery.of(context).size.height;

    // ✅ CHECK FOR INFINITY AND NAN
    if (displayHeight.isInfinite || displayHeight.isNaN) {
      return 300; // ✅ DEFAULT SAFE VALUE
    }

    // ✅ ENSURE POSITIVE VALUE AND REASONABLE LIMITS
    final calculatedHeight = (displayHeight * 2).ceil();
    return calculatedHeight.clamp(100, 800);
  }

  // ✅ FIXED: SAFE ICON SIZE CALCULATION
  double _calculateIconSize() {
    final containerSize = height ?? width ?? 50;

    // ✅ CHECK FOR VALID SIZE
    if (containerSize.isInfinite || containerSize.isNaN || containerSize <= 0) {
      return 24; // ✅ DEFAULT ICON SIZE
    }

    return containerSize * 0.3; // 30% of container size
  }
}
