import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoRow extends StatelessWidget implements SeoInjectableLayout {
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  final List<Widget> children;
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

    final rowContainer = document.createElement('div') as WebHTMLDivElement;
    rowContainer.style.display = 'flex';
    rowContainer.style.flexDirection = 'row';

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
    parent.appendChild(rowContainer);
  }
}
