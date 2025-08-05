import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoButton extends StatelessWidget implements SeoInjectable {
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback? onPressed;
  final String? id;
  final ButtonStyle? style;

  const SeoButton({
    super.key,
    required this.label,
    this.labelStyle,
    this.onPressed,
    this.id,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label, style: labelStyle),
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    if (!kIsWeb) return null;

    final button = webWindow.document.createElement('button') as WebHTMLElement;
    button.textContent = label;
    button.id = id ?? _generateRandomId();

    // Optional: Add ARIA role for better accessibility
    button.setAttribute('role', 'button');

    return button;
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'btn_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
