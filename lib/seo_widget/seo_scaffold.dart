import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/dom_injector.dart';
import 'package:flutter_dom_ui/seo_tag/seo_head_tag.dart';

/// A `Scaffold`-like widget designed for Flutter Web that automatically
/// injects SEO-friendly HTML meta tags and semantic HTML structure into the DOM.
///
/// `SeoScaffold` behaves like Flutter's standard `Scaffold`
/// but adds the ability to:
/// - Inject `<title>` and `<meta>` tags into the document's `<head>`
/// - Add Open Graph meta tags for social sharing
/// - Include canonical URLs for SEO optimization
/// - Render semantic HTML tags (`<header>`, `<main>`, `<footer>`) alongside Flutter widgets
///
/// This widget should be used **only** for web builds (`kIsWeb == true`).
///
/// Example usage:
/// ```dart
/// SeoScaffold(
///   metaTitle: 'My Page Title',
///   metaDescription: 'A description for SEO purposes',
///   metaKeywords: 'kyewords for SEO purpose',
///   canonicalUrl: 'https://example.com/my-page',
///   ogTitle: 'Open Graph Title',
///   ogDescription: 'Open Graph Description',
///   ogImageLink: 'https://example.com/image.jpg',
///   appBar: SeoAppBar(),
///   body: SeoText('Hello World'),
///   footer: SeoFooter(),
/// )
/// ```
class SeoScaffold extends StatelessWidget {
  /// The `<title>` tag content for the page.
  final String metaTitle;

  /// Optional AppBar widget that also supports HTML injection.
  final SeoInjectableLayout? appBar;

  /// Main content of the page.
  final Widget body;

  /// Optional bottom navigation bar that supports HTML injection.
  final SeoInjectableLayout? bottomNavigationBar;

  /// Scaffold background color.
  final Color? backgroundColor;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Position for the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Animation behavior for the floating action button.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Optional navigation drawer.
  final Widget? drawer;

  /// Callback when the drawer state changes.
  final void Function(bool)? onDrawerChanged;

  /// Optional end drawer (right side).
  final Widget? endDrawer;

  /// Callback when the end drawer state changes.
  final void Function(bool)? onEndDrawerChanged;

  /// Canonical URL for SEO (`<link rel="canonical">`).
  final String? canonicalUrl;

  /// `<meta name="description">` content.
  final String? metaDescription;

  /// `<meta name="keywords">` content.
  final String? metaKeywords;

  /// `<meta property="og:title">` Open Graph tag content.
  final String? ogTitle;

  /// `<meta property="og:image">` Open Graph tag content.
  final String? ogImageLink;

  /// `<meta property="og:description">` Open Graph tag content.
  final String? ogDescription;

  /// Creates a [SeoScaffold] with optional parameters.
  const SeoScaffold({
    super.key,
    required this.metaTitle,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
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
      bottomNavigationBar:
          bottomNavigationBar is Widget ? bottomNavigationBar as Widget : null,

      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
    );
  }

  /// Injects SEO-related HTML tags and semantic structure into the DOM.
  ///
  /// This method is only called in web builds (`kIsWeb == true`).
  void _injectHtml() {
    if (!kIsWeb) return;
    try {
      final document = webWindow.document;

      final String elementId = 'seo-main';
      final old = document.getElementById(elementId);
      old?.remove();

      // Get or create the hidden SEO container in the DOM.
      final container =
          document.getElementById('seo-content') ??
          _createSeoContainer(document);

      clearElementChildren(container as WebHTMLElement);

      // Inject <title> tag on <head>
      SeoHeadTag.inject(tag: HeadTag.title, innerText: metaTitle);

      // Inject <meta description> on <head>
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {'name': 'description', 'content': metaDescription ?? ''},
      );
      // Inject <meta keywords> on <head>
      SeoHeadTag.inject(
        tag: HeadTag.meta,
        attributes: {'name': 'keywords', 'content': metaKeywords ?? ''},
      );

      // Inject canonical url example on <head>
      SeoHeadTag.inject(
        tag: HeadTag.link,
        attributes: {
          'rel': 'canonical',
          'href': canonicalUrl ?? 'https://yourdomain.com/current-page',
        },
      );

      // Inject Open Graph tags example on <head>
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

  /// Creates a hidden container in the DOM for storing SEO HTML elements.
  WebHTMLDivElement _createSeoContainer(WebDocument document) {
    final container = document.createElement('div') as WebHTMLDivElement;
    container.id = 'seo-content';
    container.style.display = 'none';
    document.body?.appendChild(container);
    return container;
  }
}
