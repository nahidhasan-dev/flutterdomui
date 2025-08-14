import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A scrollable grid widget that renders a Flutter [GridView] and
/// injects a corresponding HTML structure for SEO purposes on the web.
///
/// This ensures that the child elements are indexable by search engines
/// when running in Flutter Web, where the UI is usually rendered in a `<canvas>`.
///
/// The injected HTML structure uses CSS Grid layout to visually
/// represent the grid in a semantic way.
class SeoGridView extends StatelessWidget implements SeoInjectableLayout {
  /// The number of columns in the grid.
  final SliverGridDelegate gridDelegate;

  /// The scroll direction of the grid.
  final Axis scrollDirection;

  /// Whether the grid scrolls in the reverse direction.
  final bool reverse;

  /// Optional controller for scroll position.
  final ScrollController? controller;

  /// Whether this grid is the primary scroll view associated with the parent.
  final bool? primary;

  /// The physics of the scroll view.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view should be determined by the contents.
  final bool shrinkWrap;

  /// The list of child widgets to display.
  final List<Widget> children;

  /// Optional padding for the grid.
  final EdgeInsetsGeometry? padding;

  /// Creates a [SeoGridView].
  const SeoGridView({
    super.key,
    required this.gridDelegate,
    required this.children,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: gridDelegate,
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;

    // Create a container for the grid
    final gridContainer =
        webWindow.document.createElement('div') as WebHTMLElement;
    gridContainer.style.display = 'grid';
    gridContainer.style.overflow = 'auto';

    // Try to infer column count if it's a SliverGridDelegateWithFixedCrossAxisCount
    if (gridDelegate is SliverGridDelegateWithFixedCrossAxisCount) {
      final count =
          (gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
              .crossAxisCount;
      gridContainer.style.gridTemplateColumns =
          'repeat($count, minmax(0, 1fr))';
    } else {
      // Fallback: auto-fill with min column width
      gridContainer.style.gridTemplateColumns =
          'repeat(auto-fill, minmax(100px, 1fr))';
    }

    // Inject each child widget
    for (final child in children) {
      if (child is SeoInjectable) {
        final element = (child as SeoInjectable).createHtmlElement();
        if (element != null) {
          gridContainer.appendChild(element);
        }
      } else if (child is SeoInjectableLayout) {
        (child as SeoInjectableLayout).injectHtmlTo(gridContainer);
      }
    }

    // Append the container to the parent
    parent.appendChild(gridContainer);
  }
}
