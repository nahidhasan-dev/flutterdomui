import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A SizedBox widget that not only displays content in Flutter,
/// but also injects an equivalent HTML `<div>` structure for SEO purposes
/// when running on web.
///
/// This helps improve accessibility and SEO indexing by exposing
/// semantic HTML to search engines.
///
/// Implements [SeoInjectableLayout] so it can be part of an SEO DOM hierarchy.
class SeoSizedBox extends StatelessWidget implements SeoInjectableLayout {
  /// The child widget to display inside the SizedBox.
  final Widget? child;

  /// The width of the SizedBox.
  final double? width;

  /// The height of the SizedBox.
  final double? height;

  /// Optional callback triggered when the link is tapped in Flutter.
  final void Function()? onTap;

  /// Creates a [SeoSizedBox] that works like a normal [SizedBox]
  /// but also outputs an HTML `<div>` for SEO.
  const SeoSizedBox({
    super.key,
    this.child,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }

  /// Injects the HTML representation of this SizedBox into the [parent] element.
  ///
  /// Only executes if running on Web (`kIsWeb == true`).
  /// Creates a `<div>` element, assigns it a unique ID, and
  /// recursively injects its child (if it implements [SeoInjectable] or [SeoInjectableLayout]).
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;

    // Create a div element for HTML structure
    final divSizedbox = document.createElement('div') as WebHTMLDivElement;
    divSizedbox.id = _generateRandomId();
    divSizedbox.style.width = width.toString();
    divSizedbox.style.height = height.toString();

    // Recursively inject child if present
    if (child != null) {
      _appendWidgetToContainer(child!, divSizedbox);
    }

    // Append this container to the parent HTML element
    parent.appendChild(divSizedbox);
  }

  /// Recursively appends a widget’s HTML equivalent to the SizedBox.
  ///
  /// - If the widget implements [SeoInjectable], calls `createHtmlElement()`.
  /// - If it implements [SeoInjectableLayout], calls `injectHtmlTo()`.
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'sizedbox${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
