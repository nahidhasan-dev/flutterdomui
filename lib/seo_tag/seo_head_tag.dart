import 'package:flutter/foundation.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// Represents different HTML `<head>` tags that can be injected.
enum HeadTag { title, link, meta, script }

/// Extension on [HeadTag] to get its string name for DOM usage.
extension TextTagExtension on HeadTag {
  String get name => toString().split('.').last;
}

/// Utility class for injecting SEO-related `<head>` elements into the DOM.
///
/// Only works in Flutter Web. On non-web platforms, all methods are no-ops.
class SeoHeadTag {
  /// Injects a `<head>` element specified by [tag] into the document.
  ///
  /// Optionally, provide [attributes] to set element attributes,
  /// and [innerText] for text content (ignored for `<meta>` tags).
  ///
  /// Existing `<title>`, canonical `<link>`, or Open Graph `<meta>` tags
  /// with the same identifiers will be removed before injection.
  static void inject({
    required HeadTag tag,
    Map<String, String>? attributes,
    String? innerText,
  }) {
    if (!kIsWeb) return;

    final document = webWindow.document;

    // Remove existing <title>
    if (tag.name.toLowerCase() == 'title') {
      final existingTitles = document.head?.getElementsByTagName('title');
      if (existingTitles != null) {
        for (int i = 0; i < existingTitles.length; i++) {
          existingTitles.item(i)?.remove();
        }
      }
    }

    // For <link rel="canonical">, remove existing canonical links
    if (tag == HeadTag.link &&
        attributes != null &&
        attributes['rel'] == 'canonical') {
      final existingCanonicals = document.head?.querySelectorAll(
        'link[rel="canonical"]',
      );
      if (existingCanonicals != null) {
        for (int i = 0; i < existingCanonicals.length; i++) {
          final node = existingCanonicals.item(i);
          if (node != null) {
            node.parentNode?.removeChild(node);
          }
        }
      }
    }

    // For <meta property="og:*"> Open Graph tags, remove existing ones with same property
    if (tag == HeadTag.meta &&
        attributes != null &&
        attributes.containsKey('property')) {
      final property = attributes['property'];
      if (property != null && property.startsWith('og:')) {
        final existingMeta = document.head?.querySelectorAll(
          'meta[property="$property"]',
        );
        if (existingMeta != null) {
          for (int i = 0; i < existingMeta.length; i++) {
            final node = existingMeta.item(i);
            if (node != null) {
              node.parentNode?.removeChild(node);
            }
          }
        }
      }
    }

    final element = document.createElement(tag.name);

    // Set attributes
    attributes?.forEach((key, value) {
      element.setAttribute(key, value);
    });

    if (innerText != null && tag != HeadTag.meta) {
      element.textContent = innerText;
    }

    document.head?.appendChild(element);
  }

  /// Inject canonical URL <link rel="canonical" href="..." /> into `<head>`.
  static void injectCanonicalUrl(String url) {
    inject(tag: HeadTag.link, attributes: {'rel': 'canonical', 'href': url});
  }

  /// Injects Open Graph `<meta>` tags for social media sharing.
  ///
  /// Supported tags include `og:title`, `og:image`, `og:url`, `og:type`,
  /// and `og:description`. Only non-null parameters are injected.
  static void injectOpenGraph({
    String? title,
    String? image,
    String? url,
    String? type,
    String? description,
  }) {
    if (title != null) {
      inject(
        tag: HeadTag.meta,
        attributes: {'property': 'og:title', 'content': title},
      );
    }
    if (image != null) {
      inject(
        tag: HeadTag.meta,
        attributes: {'property': 'og:image', 'content': image},
      );
    }
    if (url != null) {
      inject(
        tag: HeadTag.meta,
        attributes: {'property': 'og:url', 'content': url},
      );
    }
    if (type != null) {
      inject(
        tag: HeadTag.meta,
        attributes: {'property': 'og:type', 'content': type},
      );
    }
    if (description != null) {
      inject(
        tag: HeadTag.meta,
        attributes: {'property': 'og:description', 'content': description},
      );
    }
  }
}
