import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders SVG or raster images from a URL automatically.
/// Falls back to [placeholder] on error or null URL.
class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.borderRadius,
  });

  bool get _isSvg => url != null && url!.toLowerCase().endsWith('.svg');

  Widget _fallback() =>
      placeholder ??
      Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_outlined, color: Colors.grey),
      );

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _fallback();

    final child = _isSvg
        ? SvgPicture.network(
            url!,
            width: width,
            height: height,
            fit: fit,
            placeholderBuilder: (_) => _fallback(),
          )
        : Image.network(
            url!,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _fallback(),
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}
