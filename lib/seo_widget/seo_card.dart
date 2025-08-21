import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A card widget that not only displays content in Flutter,
/// but also injects an equivalent HTML `<div>` structure for SEO purposes
/// when running on web.
///
/// This helps improve accessibility and SEO indexing by exposing
/// semantic HTML to search engines.
///
/// Implements [SeoInjectableLayout] so it can be part of an SEO DOM hierarchy.
class SeoCard extends StatelessWidget implements SeoInjectableLayout {
  /// The child widget to display inside the card.
  final Widget? child;

  /// The background color of the card.
  final Color? color;

  /// The shadow [color] of the card.
  final Color? shadowColor;

  /// The color used as an overlay on [color] to indicate elevation.
  final Color? surfaceTintColor;

  /// The z-coordinate at which to place this card. This controls the size of the shadow below the card.
  final double? elevation;

  /// The shape of the card's [Material].
  final ShapeBorder? shape;

  ///Whether to paint the [shape] border in front of the [child].
  final bool borderOnForeground;

  /// Outer margin around the card.
  final EdgeInsetsGeometry? margin;

  ///The content will be clipped (or not) according to this option.
  final Clip? clipBehavior;

  ///Whether this widget represents a single semantic container, or if false a collection of individual semantic nodes.
  final bool semanticContainer;

  /// Optional callback triggered when the link is tapped in Flutter.
  final void Function()? onTap;

  const SeoCard({
    super.key,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.semanticContainer = true,
    this.onTap,
    this.child,
  });

  /// Creates a [SeoCard] that works like a normal [Card]
  /// but also outputs an HTML `<div>` for SEO.

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          key: key,
          color: color,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          elevation: elevation,
          shape: shape,
          borderOnForeground: borderOnForeground,
          margin: margin,
          clipBehavior: clipBehavior,
          semanticContainer: semanticContainer,
          child: child,
        ),
      ),
    );
  }

  /// Injects the HTML representation of this card into the [parent] element.
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
  void _appendWidgetToContainer(Widget widget, WebHTMLElement card) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) card.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(card);
    }
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'card_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
