import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// Enum representing common HTML text tags for SEO purposes.
enum TextTag { h1, h2, h3, h4, h5, h6, p, span }

/// Extension to get the string name of the [TextTag] enum.
extension TextTagExtension on TextTag {
  /// Returns the string representation of the tag (e.g., "h1", "p").
  String get name => toString().split('.').last;
}

/// A Flutter [Text] widget that can inject a corresponding HTML element
/// for SEO when running on the web.
///
/// The HTML element is created according to the [TextTag] provided
/// (e.g., `<h1>`, `<p>`, `<span>`). This allows text content to
/// be discoverable and indexable by search engines.
class SeoText extends StatelessWidget implements SeoInjectable {
  /// The text content to display.
  final String text;

  /// The HTML tag to use when injecting the text into the DOM.
  final TextTag tag;

  /// Optional HTML id for the element.
  final String? id;

  /// Flutter text styling.
  final TextStyle? style;

  /// Strut style for consistent line height.
  final StrutStyle? strutStyle;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Text direction.
  final TextDirection? textDirection;

  /// Locale for the text.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// Overflow behavior for the text.
  final TextOverflow? overflow;

  /// Text scaler for accessibility.
  final TextScaler? textScaler;

  /// Maximum number of lines for the text.
  final int? maxLines;

  /// Semantics label for accessibility.
  final String? semanticsLabel;

  /// Basis for computing the width of the text.
  final TextWidthBasis? textWidthBasis;

  /// Height behavior for the text.
  final TextHeightBehavior? textHeightBehavior;

  /// Color used when selecting text.
  final Color? selectionColor;

  /// Optional callback triggered when the link is tapped in Flutter.
  final void Function()? onTap;

  /// Creates a [SeoText] widget.
  const SeoText(
    this.text, {
    this.tag = TextTag.p,
    this.id,
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor,
        ),
      ),
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    if (!kIsWeb) return null;

    // Create the corresponding HTML element for SEO.
    final element =
        webWindow.document.createElement(tag.name) as WebHTMLElement;
    element.textContent = text;
    element.id = id ?? _generateRandomId();
    return element;
  }

  /// Generates a random HTML id for the element.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'text_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
