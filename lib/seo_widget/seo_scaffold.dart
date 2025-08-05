import 'dart:math';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/dom_injector.dart';
import 'package:flutter_dom_ui/seo_tag/seo_head_tag.dart';

class SeoScaffold extends StatelessWidget {
  final String metaTitle;
  final SeoInjectableLayout? appBar;
  final Widget body;
  final Color? backgroundColor;
  final String? canonicalUrl;
  final String? metaDescription;
  final String? metaKeywords;
  final String? ogTitle;
  final String? ogImageLink;
  final String? ogDescription;

  const SeoScaffold({
    super.key,
    required this.metaTitle,
    this.appBar,
    this.backgroundColor,
    required this.body,
    this.metaDescription,
    this.metaKeywords,
    this.canonicalUrl,
    this.ogTitle,
    this.ogImageLink,
    this.ogDescription,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      _injectHtml();
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          appBar is PreferredSizeWidget ? appBar as PreferredSizeWidget : null,
      body: body,
    );
  }

  void _injectHtml() {
    if (!kIsWeb) return;
    try {
      final document = webWindow.document;

      final String elementId = _generateRandomId();
      final old = document.getElementById(elementId);
      old?.remove();

      final container =
          document.getElementById('seo-content') ??
          _createSeoContainer(document);

      clearElementChildren(container as WebHTMLElement);

      // Inject <title>
      SeoHeadTag.inject(tag: HeadTag.title, innerText: metaTitle);

      // Inject <meta description>
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {'name': 'description', 'content': metaDescription ?? ''},
      );
      // Inject <meta keywords>
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {'name': 'keywords', 'content': metaKeywords ?? ''},
      );

      // Inject canonical url example
      SeoHeadTag.inject(
        tag: HeadTag.link,
        attributes: {
          'rel': 'canonical',
          'href': canonicalUrl ?? 'https://yourdomain.com/current-page',
        },
      );

      // Inject Open Graph tags example
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {'property': 'og:title', 'content': ogTitle ?? metaTitle},
      );
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {
          'property': 'og:description',
          'content': ogDescription ?? metaDescription ?? '',
        },
      );
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {
          'property': 'og:image',
          'content': ogImageLink ?? 'https://yourdomain.com/og-image.jpg',
        },
      );

      // Inject <header>
      if (appBar != null) {
        appBar!.injectHtmlTo(container);
      }

      // Inject <main>
      final mainElement = document.createElement('main') as WebHTMLElement;
      mainElement.id = elementId;

      if (body is SeoInjectable) {
        final element = (body as SeoInjectable).createHtmlElement();
        if (element != null) {
          mainElement.appendChild(element);
        }
      } else if (body is SeoInjectableLayout) {
        (body as SeoInjectableLayout).injectHtmlTo(mainElement);
      }

      container.appendChild(mainElement);
    } catch (e) {
      print('SEO Inject error: $e');
    }
  }

  WebHTMLDivElement _createSeoContainer(WebDocument document) {
    final container = document.createElement('div') as WebHTMLDivElement;
    container.id = 'seo-content';
    container.style.display = 'none';
    document.body?.appendChild(container);
    return container;
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'seo_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
