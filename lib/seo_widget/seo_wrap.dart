import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A [Wrap]-like widget that arranges its children in a flow layout,
/// and injects an equivalent semantic HTML `<div>` using CSS flex-wrap
/// for SEO and accessibility purposes when running on Web.
///
/// This allows search engines to semantically understand the layout
/// and relationships between elements.
///
/// Implements [SeoInjectableLayout] so it can participate in the SEO DOM hierarchy.
class SeoWrap extends StatelessWidget implements SeoInjectableLayout {
  /// The direction to use as the main axis (horizontal or vertical).
  final Axis direction;

  /// How the children should be placed along the main axis.
  final WrapAlignment alignment;

  /// How the lines of children should be placed along the cross axis.
  final WrapAlignment runAlignment;

  /// How much space should be between children in the main axis.
  final double spacing;

  /// How much space should be between lines in the cross axis.
  final double runSpacing;

  /// The vertical direction of the layout.
  final VerticalDirection verticalDirection;

  /// Determines the order in which children are painted.
  final TextDirection? textDirection;

  /// Determines how children within a run are aligned relative to each other.
  final WrapCrossAlignment crossAxisAlignment;

  /// Clip behavior for this widget.
  final Clip clipBehavior;

  /// The children to arrange inside the wrap layout.
  final List<Widget> children;

  /// Creates a [SeoWrap] widget that mirrors the functionality of [Wrap],
  /// and also injects an HTML layout for SEO on Web.
  const SeoWrap({
    super.key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.clipBehavior = Clip.none,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      alignment: alignment,
      runAlignment: runAlignment,
      spacing: spacing,
      runSpacing: runSpacing,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      crossAxisAlignment: crossAxisAlignment,
      clipBehavior: clipBehavior,
      children: children,
    );
  }

  /// Injects a `<div>` with CSS flex-wrap styling into the parent [WebHTMLElement].
  ///
  /// Each child widget is recursively injected if it implements [SeoInjectable]
  /// or [SeoInjectableLayout].
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;

    final div = document.createElement('div') as WebHTMLDivElement;
    div.id = _generateRandomId();

    // Use flex and wrap layout styles
    div.style.display = 'flex';
    div.style.flexWrap = 'wrap';
    div.style.gap = '${runSpacing}px ${spacing}px';

    // Direction
    if (direction == Axis.horizontal) {
      div.style.flexDirection = 'row';
    } else {
      div.style.flexDirection = 'column';
    }

    // Alignment mapping
    div.style.justifyContent = _mapWrapAlignment(alignment);
    div.style.alignContent = _mapWrapAlignment(runAlignment);
    div.style.alignItems = _mapCrossAxisAlignment(crossAxisAlignment);

    // Inject all children
    for (final child in children) {
      _appendWidgetToContainer(child, div);
    }

    // Add to the parent
    parent.appendChild(div);
  }

  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  String _mapWrapAlignment(WrapAlignment alignment) {
    switch (alignment) {
      case WrapAlignment.start:
        return 'flex-start';
      case WrapAlignment.end:
        return 'flex-end';
      case WrapAlignment.center:
        return 'center';
      case WrapAlignment.spaceBetween:
        return 'space-between';
      case WrapAlignment.spaceAround:
        return 'space-around';
      case WrapAlignment.spaceEvenly:
        return 'space-evenly';
    }
  }

  String _mapCrossAxisAlignment(WrapCrossAlignment alignment) {
    switch (alignment) {
      case WrapCrossAlignment.start:
        return 'flex-start';
      case WrapCrossAlignment.end:
        return 'flex-end';
      case WrapCrossAlignment.center:
        return 'center';
    }
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'wrap_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
