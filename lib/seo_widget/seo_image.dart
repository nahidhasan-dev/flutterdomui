import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A widget that displays an image and injects a corresponding HTML `<img>`
/// element into the DOM for SEO purposes when running on the web.
///
/// This is useful because Flutter's default rendering on web uses a canvas,
/// which is not SEO-friendly for search engines.
/// By implementing [SeoInjectable], this widget ensures that search engine
/// crawlers can read and index the image's HTML representation.
///
/// ### Example usage:
/// ```dart
/// SeoImage(
///   src: 'https://example.com/image.jpg',
///   alt: 'Example image',
///   width: 200,
///   height: 150,
/// )
/// ```
///
/// When running on the web, this will also create an HTML `<img>` element
/// with the specified attributes and inject it into the DOM.
class SeoImage extends StatelessWidget implements SeoInjectable {
  /// The URL of the image to display.
  final String src;

  /// The alternative text for the image, used by screen readers and SEO.
  /// If not provided, [semanticLabel] is used instead.
  final String? alt;

  /// The width of the image (both in Flutter and in the HTML element).
  final double? width;

  /// The height of the image (both in Flutter and in the HTML element).
  final double? height;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds.
  final AlignmentGeometry alignment;

  /// How to paint any portions of the image that do not fit inside the box.
  final ImageRepeat repeat;

  /// A label for the image used by screen readers.
  final String? semanticLabel;

  /// Whether to exclude the image from semantics.
  final bool excludeFromSemantics;

  /// The `id` attribute of the HTML `<img>` element.
  /// If not provided, a random ID will be generated.
  final String? id;

  /// Optional callback triggered when the link is tapped in Flutter.
  final void Function()? onTap;

  /// Creates a [SeoImage] widget.
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
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Image.network(
          src,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
        ),
      ),
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

  /// Generates a random HTML element ID for the image if none is provided.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'img_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
