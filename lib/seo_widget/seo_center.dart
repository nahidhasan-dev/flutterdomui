import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A SEO-friendly equivalent of Flutter's [Center] widget.
///
/// This widget behaves like Flutter's `Center` in UI,
/// but when running on the web, it can inject a `<div>`
/// container into the HTML DOM for better SEO and accessibility.
///
/// ### Features:
/// - Centers a child widget in both Flutter UI and HTML DOM.
/// - Supports [widthFactor] and [heightFactor] like the standard `Center`.
/// - Automatically generates a unique HTML element ID if none is provided.
/// - Works with both [SeoInjectable] and [SeoInjectableLayout] children.
class SeoCenter extends StatelessWidget implements SeoInjectableLayout {
  /// The widget to display inside the center.
  final Widget? child;

  /// If non-null, the width of this widget will be
  /// the child's width multiplied by this factor.
  final double? widthFactor;

  /// If non-null, the height of this widget will be
  /// the child's height multiplied by this factor.
  final double? heightFactor;

  /// Creates a [SeoCenter] widget.
  const SeoCenter({super.key, this.child, this.widthFactor, this.heightFactor});

  @override
  Widget build(BuildContext context) {
    // Builds the Flutter UI version of Center
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    // Only inject HTML if running on the web
    if (!kIsWeb) return;
    final document = webWindow.document;

    // Create a <div> container
    final divContainer = document.createElement('div') as WebHTMLDivElement;

    // Assign a unique id for SEO and DOM reference
    divContainer.id = _generateRandomId();

    // Append the child widget's HTML representation, if available
    if (child != null) {
      _appendWidgetToContainer(child!, divContainer);
    }

    // Append this container to the parent HTML element
    parent.appendChild(divContainer);
  }

  /// Recursively appends the HTML representation of [widget] into [container].
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  /// Generates a short random ID for the HTML container.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'center_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
