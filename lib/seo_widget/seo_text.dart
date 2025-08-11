import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

enum TextTag { h1, h2, h3, h4, h5, h6, p, span }

extension TextTagExtension on TextTag {
  String get name => toString().split('.').last;
}

class SeoText extends StatelessWidget implements SeoInjectable {
  final String text;
  final TextTag tag;
  final String? id;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

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
  });

  @override
  Widget build(BuildContext context) {
    return Text(
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
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    if (!kIsWeb) return null;
    final element =
        webWindow.document.createElement(tag.name) as WebHTMLElement;
    element.textContent = text;
    element.id = id ?? _generateRandomId();
    return element;
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'text_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
