import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoCenter extends StatelessWidget implements SeoInjectableLayout {
  final Widget? child;
  final double? widthFactor;
  final double? heightFactor;

  const SeoCenter({super.key, this.child, this.widthFactor, this.heightFactor});

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;
    final divContainer = document.createElement('div') as WebHTMLDivElement;
    divContainer.id = _generateRandomId();

    // Leading
    if (child != null) {
      _appendWidgetToContainer(child!, divContainer);
    }

    parent.appendChild(divContainer);
  }

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
    return 'center_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
