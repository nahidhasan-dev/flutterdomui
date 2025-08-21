import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A [Padding]-like widget that also injects a semantic HTML `<div>`
/// with corresponding CSS padding when running on Web.
///
/// Implements [SeoInjectableLayout] for DOM tree compatibility.
class SeoPadding extends StatelessWidget implements SeoInjectableLayout {
  /// The amount of space to inset the child.
  final EdgeInsetsGeometry padding;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates a [SeoPadding] widget.
  const SeoPadding({super.key, required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(key: key, padding: padding, child: child);
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;

    final document = webWindow.document;

    // Create a <div> with padding
    final div = document.createElement('div') as WebHTMLDivElement;
    div.id = _generateRandomId();

    // Apply padding via inline CSS
    final resolvedPadding = padding.resolve(TextDirection.ltr);
    div.style.paddingTop = '${resolvedPadding.top}px';
    div.style.paddingRight = '${resolvedPadding.right}px';
    div.style.paddingBottom = '${resolvedPadding.bottom}px';
    div.style.paddingLeft = '${resolvedPadding.left}px';

    // Inject child into padded div
    _appendWidgetToContainer(child, div);

    // Add to parent
    parent.appendChild(div);
  }

  /// Appends the HTML version of a [Widget] into the given HTML [container],
  /// if the widget implements [SeoInjectable] or [SeoInjectableLayout].
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  /// Generates a unique random HTML element ID.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'padding_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
