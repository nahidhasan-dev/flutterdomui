import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoLink extends StatelessWidget implements SeoInjectable {
  final String href;
  final String text;
  final String? title;
  final TextStyle? style;
  final String? id;
  final void Function()? onTap;

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
    return GestureDetector(
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

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'link_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
