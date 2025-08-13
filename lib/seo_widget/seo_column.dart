import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A SEO-friendly equivalent of Flutter's [Column] widget.
///
/// This widget behaves like Flutter's `Column` in the Flutter UI,
/// but when running on the web, it also injects a `<div>` container
/// with `display: flex` and `flex-direction: column` into the HTML DOM.
///
/// ### Features:
/// - Supports all basic [Column] alignment parameters.
/// - Injects semantic HTML for better SEO and accessibility.
/// - Works with children that implement either [SeoInjectable]
///   or [SeoInjectableLayout].
///
/// ### Example:
/// ```dart
/// SeoColumn(
///   mainAxisAlignment: MainAxisAlignment.center,
///   crossAxisAlignment: CrossAxisAlignment.start,
///   children: [
///     SeoText('Title'),
///     SeoButton(text: 'Click Me', onPressed: () {}),
///   ],
/// )
/// ```
class SeoColumn extends StatelessWidget implements SeoInjectableLayout {
  /// How the children should be placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How much space should be occupied in the main axis.
  final MainAxisSize mainAxisSize;

  /// How the children should be placed along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// The list of widgets to arrange vertically.
  final List<Widget> children;

  /// Creates a [SeoColumn] widget.
  const SeoColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    // Builds the Flutter UI version of Column
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    // Only inject HTML if running on the web
    if (!kIsWeb) return;

    // Create a <div> container with column flex layout
    final colContainer =
        webWindow.document.createElement('div') as WebHTMLElement;
    colContainer.style.display = 'flex';
    colContainer.style.flexDirection = 'column';

    // Append each child's HTML representation
    for (final child in children) {
      if (child is SeoInjectable) {
        final element = (child as SeoInjectable).createHtmlElement();
        if (element != null) {
          colContainer.appendChild(element);
        }
      } else if (child is SeoInjectableLayout) {
        (child as SeoInjectableLayout).injectHtmlTo(colContainer);
      }
    }

    // Attach the column container to the parent element
    parent.appendChild(colContainer);
  }
}
