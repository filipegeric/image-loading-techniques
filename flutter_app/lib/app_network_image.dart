import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

enum PlaceholderType {
  nothing,
  assetPlaceholder,
  solidColor,
  blurhash,
  blurredThumbnail,
}

class AppNetworkImage extends StatefulWidget {
  final String url;
  final PlaceholderType placeholderType;
  final String hexColor;
  final String blurhash;
  final String thumbnailData;

  AppNetworkImage({
    Key key,
    @required this.url,
    this.placeholderType = PlaceholderType.nothing,
    this.hexColor,
    this.blurhash,
    this.thumbnailData,
  }) : super(key: key);

  // TODO: add asserts

  @override
  _AppNetworkImageState createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  final _duration = const Duration(milliseconds: 300);
  Widget _placeholder;

  Widget get placeholder {
    if (_placeholder == null) {
      _placeholder = _buildPlaceholder();
    }
    return _placeholder;
  }

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget _buildPlaceholder() {
    switch (widget.placeholderType) {
      case PlaceholderType.solidColor:
        return Container(
          color: _colorFromHex(widget.hexColor),
        );
      case PlaceholderType.assetPlaceholder:
        return Image.asset(
          'assets/placeholder.png',
          fit: BoxFit.cover,
        );
      case PlaceholderType.blurhash:
        return Image(
          image: BlurHashImage(widget.blurhash),
          fit: BoxFit.cover,
        );
      case PlaceholderType.blurredThumbnail:
        return ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Image.memory(
              base64Decode(widget.thumbnailData),
              fit: BoxFit.cover,
            ),
          ),
        );
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      child: OctoImage(
        image: NetworkImage(widget.url),
        fit: BoxFit.cover,
        fadeInDuration: _duration,
        fadeOutDuration: _duration,
        progressIndicatorBuilder: (context, image) => Stack(
          children: [
            Positioned.fill(
              child: placeholder,
            ),
            if (image != null)
              Center(
                child: CircularProgressIndicator(
                  value: image.cumulativeBytesLoaded / image.expectedTotalBytes,
                  strokeWidth: 1,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              ),
          ],
        ),
        errorBuilder: OctoError.placeholderWithErrorIcon((context) => placeholder),
      ),
    );
  }
}
