import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoInitializer extends StatelessWidget {
  final Widget child;
  const SeoInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      _ensureSeoContainerExists();
    }
    return child;
  }

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
