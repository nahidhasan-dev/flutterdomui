import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

enum InputType { text, textarea }

class SeoTextField extends StatelessWidget implements SeoInjectable {
  final TextEditingController? controller;
  final String? id;
  final String? placeholder;
  final InputType? type;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final TextStyle? style;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;

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

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'input_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
