import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A SEO-friendly button widget that can render both a Flutter `ElevatedButton`
/// and an equivalent HTML `<button>` element when running on the web.
///
/// This widget implements [SeoInjectable] so that it can create
/// a DOM representation for search engines and web crawlers.
///
/// ### Features:
/// - Works as a normal Flutter `ElevatedButton` in native apps.
/// - Creates an HTML `<button>` for SEO purposes in Flutter Web.
/// - Allows custom styling, text, and accessibility attributes.
class SeoButton extends StatelessWidget implements SeoInjectable {
  /// The text label displayed on the button.
  final String label;

  /// Optional text style for the button label in Flutter UI.
  final TextStyle? labelStyle;

  /// Callback when the button is pressed in Flutter UI.
  final VoidCallback? onPressed;

  /// Optional HTML element `id` for the button in the DOM.
  ///
  /// If not provided, a random ID will be generated.
  final String? id;

  /// Optional Flutter button style.
  final ButtonStyle? style;

  /// Creates a [SeoButton] widget.
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
    // Builds the standard Flutter ElevatedButton
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(label, style: labelStyle),
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    // Only create HTML element if running on the web
    if (!kIsWeb) return null;

    // Create a native HTML <button> element
    final button = webWindow.document.createElement('button') as WebHTMLElement;
    button.textContent = label;

    // Set the HTML id attribute (for SEO and DOM access)
    button.id = id ?? _generateRandomId();

    // Optional: Add ARIA role for better accessibility
    button.setAttribute('role', 'button');

    return button;
  }

  /// Generates a short random HTML element ID.
  ///
  /// This is used if no [id] is provided by the user.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'btn_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
