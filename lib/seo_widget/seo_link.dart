import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A widget that renders a clickable link in Flutter and injects
/// a corresponding HTML `<a>` element for SEO purposes when running on the web.
///
/// This is useful because Flutter Web renders primarily in a `<canvas>`,
/// which is not indexable by search engines. By implementing [SeoInjectable],
/// this widget ensures that crawlers can read and index the link as real HTML.
///
/// ### Example usage:
/// ```dart
/// SeoLink(
///   href: 'https://example.com',
///   text: 'Visit Example',
///   title: 'Go to example.com',
///   onTap: () => print('Link clicked!'),
/// )
/// ```
///
/// When running on the web, this will also create an HTML `<a>` element
/// with the given `href`, `text`, and `title` attributes.
class SeoLink extends StatelessWidget implements SeoInjectable {
  /// The URL the link points to.
  final String href;

  /// The text to display for the link.
  final String text;

  /// Optional title attribute for the HTML `<a>` element.
  final String? title;

  /// Optional text style for the Flutter widget.
  final TextStyle? style;

  /// Optional HTML `id` attribute for the `<a>` element.
  /// If not provided, a random ID is generated.
  final String? id;

  /// Optional callback triggered when the link is tapped in Flutter.
  final void Function()? onTap;

  /// Creates a [SeoLink] widget.
  const SeoLink({
    super.key,
    required this.href,
    required this.text,
    this.title,
    this.style,
    this.id,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style:
              style ??
              const TextStyle(
                color: Color(0xFF0000EE),
                decoration: TextDecoration.underline,
              ),
        ),
      ),
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    if (!kIsWeb) return null;

    final anchor = WebDocument().createElement('a') as WebHTMLElement;
    anchor.setAttribute('href', href);
    anchor.setAttribute('rel', 'noopener');
    anchor.setAttribute('target', '_blank');
    anchor.setAttribute('id', id ?? _generateRandomId());
    anchor.textContent = text;
    if (title != null) anchor.setAttribute('title', title!);

    return anchor;
  }

  /// Generates a random HTML element ID for the link if none is provided.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'link_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
