import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoImage extends StatelessWidget implements SeoInjectable {
  final String src;
  final String? alt;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final String? id;

  const SeoImage({
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    if (!kIsWeb) return null;
    final element =
        WebHTMLImageElement()
          ..src = src
          ..alt = alt ?? semanticLabel ?? ''
          ..id = id ?? _generateRandomId();

    if (width != null) element.width = width!.toInt();
    if (height != null) element.height = height!.toInt();
    return element;
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'img_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
