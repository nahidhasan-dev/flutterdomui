import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// Enum representing the type of input for the SEO text field.
enum InputType { text, textarea }

/// A Flutter [TextField] widget that can inject a corresponding HTML input
/// element for SEO when running on the web.
///
/// Depending on the [type] or [keyboardType], this will render either
/// an `<input>` or `<textarea>` element in the DOM.
class SeoTextField extends StatelessWidget implements SeoInjectable {
  /// Controller for managing the text being edited.
  final TextEditingController? controller;

  /// Optional HTML id for the input element.
  final String? id;

  /// Placeholder text displayed inside the input when empty.
  final String? placeholder;

  /// Type of input to render: single-line text or multiline textarea.
  final InputType? type;

  /// Keyboard type for the input (maps to HTML input types when applicable).
  final TextInputType? keyboardType;

  /// Decoration for the Flutter TextField.
  final InputDecoration? decoration;

  /// Text style for the input text.
  final TextStyle? style;

  /// Maximum number of lines for multiline input.
  final int? maxLines;

  /// Minimum number of lines for multiline input.
  final int? minLines;

  /// Whether the text is obscured (e.g., password field).
  final bool obscureText;

  /// Creates a [SeoTextField] widget.
  const SeoTextField({
    super.key,
    this.controller,
    this.id,
    this.placeholder,
    this.type,
    this.keyboardType,
    this.decoration,
    this.style,
    this.maxLines,
    this.minLines,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration =
        decoration?.copyWith(hintText: decoration?.hintText ?? placeholder) ??
        InputDecoration(hintText: placeholder);
    return TextField(
      controller: controller,
      decoration: effectiveDecoration,
      style: style,
      keyboardType: keyboardType,

      maxLines:
          maxLines ?? (effectiveInputType == InputType.textarea ? null : 1),
      minLines: minLines,
      obscureText: obscureText,
    );
  }

  @override
  WebHTMLElement? createHtmlElement() {
    if (!kIsWeb) return null;

    final document = webWindow.document;
    late WebHTMLElement element;

    // Create textarea for multiline, otherwise input element.
    if (effectiveInputType == InputType.textarea) {
      element = document.createElement('textarea') as WebHTMLElement;
      if (maxLines != null) {
        element.setAttribute('rows', '$maxLines');
      }
    } else {
      element = document.createElement('input') as WebHTMLElement;
      final htmlInputType = _mapKeyboardTypeToHtmlInputType();
      element.setAttribute('type', htmlInputType);
    }

    element.id = id ?? _generateRandomId();

    if (placeholder != null) {
      element.setAttribute('placeholder', placeholder!);
    }

    if (controller != null && controller!.text.isNotEmpty) {
      element.setAttribute('value', controller!.text);
    }

    return element;
  }

  /// Determines the effective input type based on [type] or [keyboardType].
  InputType get effectiveInputType {
    if (type != null) return type!;
    if (keyboardType == TextInputType.multiline) return InputType.textarea;
    return InputType.text;
  }

  String _mapKeyboardTypeToHtmlInputType() {
    if (obscureText) return 'password';

    switch (keyboardType) {
      case TextInputType.emailAddress:
        return 'email';
      case TextInputType.number:
        return 'number';
      case TextInputType.phone:
        return 'tel';
      case TextInputType.url:
        return 'url';
      case TextInputType.visiblePassword:
        return 'password';
      case TextInputType.datetime:
        return 'datetime-local';
      case TextInputType.multiline:
        return 'text';
      case TextInputType.name:
        return 'text';
      case TextInputType.streetAddress:
        return 'text';
      default:
        return 'text';
    }
  }

  /// Generates a random HTML id for the input.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'input_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
