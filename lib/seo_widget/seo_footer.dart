import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A semantic `<footer>` container for Flutter web apps with SEO-friendly HTML injection.
///
/// `SeoFooter` behaves like a regular Flutter `Container`
/// but when running on the web (`kIsWeb == true`),
/// it injects an actual `<footer>` HTML element into the DOM.
///
/// This is useful for:
/// - Adding semantic HTML for better SEO.
/// - Structuring your web layout to be accessible and crawler-friendly.
///
/// ### Example:
/// ```dart
/// SeoFooter(
///   padding: EdgeInsets.all(16),
///   color: Colors.grey[200],
///   child: SeoText('© 2025 My Company'),
/// )
/// ```
///
/// When rendered in Flutter Web, this generates:
/// ```html
/// <footer id="footer_ab12">
///   <p>© 2025 My Company</p>
/// </footer>
/// ```
class SeoFooter extends StatelessWidget implements SeoInjectableLayout {
  /// The widget to place inside the footer.
  final Widget? child;

  /// Aligns the child within the container.
  final AlignmentGeometry? alignment;

  /// Inner spacing inside the footer.
  final EdgeInsetsGeometry? padding;

  /// Background color of the footer.
  final Color? color;

  /// Decoration for the background.
  final Decoration? decoration;

  /// Decoration for the foreground overlay.
  final Decoration? foregroundDecoration;

  /// Fixed width of the footer.
  final double? width;

  /// Fixed height of the footer.
  final double? height;

  /// Additional layout constraints.
  final BoxConstraints? constraints;

  /// Outer spacing around the footer.
  final EdgeInsetsGeometry? margin;

  /// create SeoFooter
  const SeoFooter({
    super.key,
    this.child,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      child: child,
    );
  }

  /// Injects a semantic `<footer>` element into the DOM
  /// and recursively injects SEO-enabled child widgets.
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;
    final divContainer = document.createElement('footer') as WebHTMLDivElement;
    divContainer.id = _generateRandomId();

    // Inject the child widget's HTML (if it's SEO-enabled).
    if (child != null) {
      _appendWidgetToContainer(child!, divContainer);
    }

    parent.appendChild(divContainer);
  }

  /// Adds a child widget's HTML representation to the container.
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  /// Generates a random HTML element ID for the footer.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'footer_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
