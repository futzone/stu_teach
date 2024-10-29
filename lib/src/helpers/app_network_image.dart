import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final double radius;
  final bool byAPI;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.byAPI = true,
    this.radius = 0.0,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final url = this.url ?? "";
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        cacheKey: url,
        height: height,
        width: width,
        fit: fit,
        imageUrl: url.contains("http") ? url : "https://onapi.uz/api/v1/file/$url",
        errorWidget: (context, error, obj) {
          return const Icon(Icons.image);
        },
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: AppTheme.colors.baseColor,
            highlightColor: AppTheme.colors.highlightColor,
            child: Container(color: Colors.white),
          );
        },
      ),
    );
  }
}
