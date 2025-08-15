import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A container widget that not only displays content in Flutter,
/// but also injects an equivalent HTML `<div>` structure for SEO purposes
/// when running on web.
///
/// This helps improve accessibility and SEO indexing by exposing
/// semantic HTML to search engines.
///
/// Implements [SeoInjectableLayout] so it can be part of an SEO DOM hierarchy.
class SeoContainer extends StatelessWidget implements SeoInjectableLayout {
  /// The child widget to display inside the container.
  final Widget? child;

  /// How to align the child within the container.
  final AlignmentGeometry? alignment;

  /// Inner padding between the container’s edge and its child.
  final EdgeInsetsGeometry? padding;

  /// The background color of the container.
  final Color? color;

  /// A decoration to paint behind the child.
  final Decoration? decoration;

  /// A decoration to paint in front of the child.
  final Decoration? foregroundDecoration;

  /// The width of the container.
  final double? width;

  /// The height of the container.
  final double? height;

  /// Additional constraints to apply to the container.
  final BoxConstraints? constraints;

  /// Outer margin around the container.
  final EdgeInsetsGeometry? margin;

  /// Optional callback triggered when the link is tapped in Flutter.
  final void Function()? onTap;

  /// Creates a [SeoContainer] that works like a normal [Container]
  /// but also outputs an HTML `<div>` for SEO.
  const SeoContainer({
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
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }

  /// Injects the HTML representation of this container into the [parent] element.
  ///
  /// Only executes if running on Web (`kIsWeb == true`).
  /// Creates a `<div>` element, assigns it a unique ID, and
  /// recursively injects its child (if it implements [SeoInjectable] or [SeoInjectableLayout]).
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;

    // Create a div element for HTML structure
    final divContainer = document.createElement('div') as WebHTMLDivElement;
    divContainer.id = _generateRandomId();
    divContainer.style.width = width.toString();
    divContainer.style.height = height.toString();

    // Recursively inject child if present
    if (child != null) {
      _appendWidgetToContainer(child!, divContainer);
    }

    // Append this container to the parent HTML element
    parent.appendChild(divContainer);
  }

  /// Recursively appends a widget’s HTML equivalent to the container.
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
    return 'container_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
