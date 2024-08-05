import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GlobalImage extends StatelessWidget {

  const GlobalImage(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
    this.isFileImage = false,
  });
  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final bool isFileImage;

  @override
  Widget build(BuildContext context) {
    if (isFileImage) {
      return Image.file(File(path), fit: fit, height: height, width: width);
    }

    final isLocalImage =
        (!path.contains('http')) && (!path.contains('.svg'));

    if (isLocalImage) {
      return Image.asset(
        path,
        fit: fit,
        height: height,
        width: width,
      );
    } else {
      return CachedNetworkImage(
          imageUrl: buildCloudinaryUrl(path),
          fit: fit,
          height: height,
          width: width,
          fadeInDuration: Duration.zero,
          placeholder: (context, url) => const SizedBox(),
          errorWidget: (context, url, error) {
            try {
              return Image.network(
                path,
                fit: fit,
                height: height,
                width: width,
              );
            } catch (e) {
              return const SizedBox.shrink();
            }
          },);
    }
  }
}

String buildCloudinaryUrl(String originalImageUrl) {
  return originalImageUrl;
  // try {
  //   var urlSegment = originalImageUrl.split('dev-spilll-storage-bucket/')[1];
  //   const String cloudName = 'dtfv78t5v';
  //   var cloudinaryUrl =
  //       'https://res.cloudinary.com/$cloudName/image/upload/q_auto,f_auto/remote_media/dev-spilll-storage-bucket/$urlSegment';

  //   return cloudinaryUrl;
  // } catch (e) {
  //   return originalImageUrl;
  // }
}
