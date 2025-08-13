import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A scrollable list widget that renders a Flutter [ListView] and
/// injects a corresponding HTML structure for SEO purposes on the web.
///
/// This ensures that the child elements are indexable by search engines
/// when running in Flutter Web, where the UI is usually rendered in a `<canvas>`.
///
/// The injected HTML structure uses a flex container, which is
/// column-oriented for vertical scrolling or row-oriented for horizontal scrolling.
class SeoListView extends StatelessWidget implements SeoInjectableLayout {
  /// The axis along which the list scrolls.
  final Axis scrollDirection;

  /// Whether the list scrolls in the reverse direction.
  final bool reverse;

  /// Optional controller for the list scroll position.
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the parent.
  final bool? primary;

  /// The physics of the scroll view.
  final ScrollPhysics? physics;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// Whether the extent of the scroll view should be determined by the contents.
  final bool shrinkWrap;

  /// The list of child widgets to display.
  final List<Widget> children;

  /// Creates a [SeoListView].
  const SeoListView({
    super.key,
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
    return ListView(
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

    // Create a flex container for the list
    final listContainer =
        webWindow.document.createElement('div') as WebHTMLElement;
    listContainer.style.display = 'flex';
    listContainer.style.flexDirection =
        scrollDirection == Axis.vertical ? 'column' : 'row';
    listContainer.style.overflow = 'auto';

    // Inject each child widget as HTML
    for (final child in children) {
      if (child is SeoInjectable) {
        final element = (child as SeoInjectable).createHtmlElement();
        if (element != null) {
          listContainer.appendChild(element);
        }
      } else if (child is SeoInjectableLayout) {
        (child as SeoInjectableLayout).injectHtmlTo(listContainer);
      }
    }

    // Append the container to the parent element
    parent.appendChild(listContainer);
  }
}
