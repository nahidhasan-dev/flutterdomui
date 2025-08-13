import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A horizontal layout widget that behaves like a Flutter [Row] but
/// can inject a corresponding HTML `<div>` structure for SEO purposes
/// when running on the web.
///
/// The HTML container uses `display: flex` with `flex-direction: row`
/// and appends the child elements, allowing search engines to index content.
class SeoRow extends StatelessWidget implements SeoInjectableLayout {
  /// How the children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space the row should occupy along its main axis.
  final MainAxisSize mainAxisSize;

  /// How the children should be aligned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// The list of child widgets to display inside the row.
  final List<Widget> children;

  /// Creates a [SeoRow].
  const SeoRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,

      children: children,
    );
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;

    // Create a flex container for the row
    final rowContainer = document.createElement('div') as WebHTMLDivElement;
    rowContainer.style.display = 'flex';
    rowContainer.style.flexDirection = 'row';

    // Inject each child widget as HTML
    for (final child in children) {
      if (child is SeoInjectable) {
        final element = (child as SeoInjectable).createHtmlElement();
        if (element != null) {
          rowContainer.appendChild(element);
        }
      } else if (child is SeoInjectableLayout) {
        (child as SeoInjectableLayout).injectHtmlTo(rowContainer);
      }
    }

    // Append the row container to the parent
    parent.appendChild(rowContainer);
  }
}
