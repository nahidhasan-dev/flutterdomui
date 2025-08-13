import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A widget that ensures a hidden SEO-friendly HTML container exists in the DOM.
///
/// This container is used to store HTML elements injected by other
/// [SeoInjectable] widgets (e.g., [SeoImage]) so that search engines can
/// read and index them when running on the web.
///
/// Flutter web apps render primarily in a `<canvas>` element, which is not
/// readable by search engine crawlers.
/// By creating a `<div id="seo-content" style="display:none">`, this widget
/// provides a place where real HTML can be appended for SEO purposes.
///
/// ### Example usage:
/// ```dart
/// void main() {
///   runApp(
///     SeoInitializer(
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// In this example, the hidden `#seo-content` container will be created
/// automatically when running on the web.
class SeoInitializer extends StatelessWidget {
  /// The widget below this widget in the tree.
  ///
  /// This will usually be your entire application.
  final Widget child;

  /// Creates a [SeoInitializer] widget.
  ///
  /// The [child] parameter is required and represents the main content
  /// of your app.
  const SeoInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      _ensureSeoContainerExists();
    }
    return child;
  }

  /// Ensures that the hidden `#seo-content` container exists in the DOM.
  ///
  /// If the container is not present, it will be created and appended
  /// to the `<body>` element with `display: none` styling so it is
  /// invisible to users but still readable by crawlers.
  void _ensureSeoContainerExists() {
    try {
      final document = webWindow.document;
      final existing = document.getElementById('seo-content');
      if (existing == null) {
        final container = document.createElement('div') as WebHTMLDivElement;
        container.id = 'seo-content';
        container.style.display = 'none';
        document.body?.appendChild(container);
      }
    } catch (e) {
      print('SEO Container Init Error: $e');
    }
  }
}
