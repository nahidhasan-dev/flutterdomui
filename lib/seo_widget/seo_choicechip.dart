import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A Flutter ChoiceChip widget that also injects a semantic HTML `<button>`
/// element into the DOM when running on Web, enabling better SEO and accessibility.
///
/// Implements [SeoInjectableLayout], allowing it to be part of a semantic DOM hierarchy.
///
/// This widget behaves exactly like a [ChoiceChip] in Flutter but adds
/// HTML DOM injection support to render a corresponding HTML button.
class SeoChoicechip extends StatelessWidget implements SeoInjectableLayout {
  /// Creates a [SeoChoicechip] that wraps a standard [ChoiceChip] and injects
  /// semantic HTML for SEO support on the Web.
  const SeoChoicechip({
    super.key,
    this.avatar,
    required this.label,
    this.labelStyle,
    this.labelPadding,
    this.onSelected,
    this.pressElevation,
    required this.selected,
    this.selectedColor,
    this.disabledColor,
    this.tooltip,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.color,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
    this.avatarBoxConstraints,
    this.chipAnimationStyle,
  });

  /// An optional widget to display before the label, typically an [Icon] or [CircleAvatar].
  final Widget? avatar;

  /// The widget to display as the label inside the chip.
  final Widget label;

  /// The style to use for the label text.
  final TextStyle? labelStyle;

  /// Padding around the label widget.
  final EdgeInsetsGeometry? labelPadding;

  /// Callback when the chip is tapped.
  final void Function(bool)? onSelected;

  /// Elevation of the chip when pressed.
  final double? pressElevation;

  /// Whether this chip is currently selected.
  final bool selected;

  /// Background color when selected.
  final Color? selectedColor;

  /// Background color when disabled.
  final Color? disabledColor;

  /// Tooltip text when hovering over the chip.
  final String? tooltip;

  /// Border side of the chip.
  final BorderSide? side;

  /// The shape of the chip's outer border.
  final OutlinedBorder? shape;

  /// Clip behavior for this widget.
  final Clip clipBehavior;

  /// Focus node for handling keyboard focus.
  final FocusNode? focusNode;

  /// Whether this chip should auto-focus.
  final bool autofocus;

  /// A [WidgetStateProperty] that defines the chip’s color based on widget state.
  final WidgetStateProperty<Color?>? color;

  /// The background color when not selected.
  final Color? backgroundColor;

  /// Padding inside the chip.
  final EdgeInsetsGeometry? padding;

  /// The visual density of the chip.
  final VisualDensity? visualDensity;

  /// Tap target size of the chip.
  final MaterialTapTargetSize? materialTapTargetSize;

  /// Elevation of the chip.
  final double? elevation;

  /// Shadow color behind the chip.
  final Color? shadowColor;

  /// Color overlay applied to the surface of the chip.
  final Color? surfaceTintColor;

  /// Icon theme used when the chip contains icons.
  final IconThemeData? iconTheme;

  /// Shadow color when selected.
  final Color? selectedShadowColor;

  /// Whether to show the checkmark when selected.
  final bool? showCheckmark;

  /// Color of the checkmark.
  final Color? checkmarkColor;

  /// Shape border for the avatar.
  final ShapeBorder avatarBorder;

  /// Constraints to apply to the avatar.
  final BoxConstraints? avatarBoxConstraints;

  /// Controls the animation behavior of the chip.
  final ChipAnimationStyle? chipAnimationStyle;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onSelected != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
      child: ChoiceChip(
        key: key,
        avatar: avatar,
        label: label,
        labelStyle: labelStyle,
        labelPadding: labelPadding,
        onSelected: onSelected,
        pressElevation: pressElevation,
        selected: selected,
        selectedColor: selectedColor,
        disabledColor: disabledColor,
        tooltip: tooltip,
        side: side,
        shape: shape,
        clipBehavior: clipBehavior,
        focusNode: focusNode,
        autofocus: autofocus,
        color: color,
        backgroundColor: backgroundColor,
        padding: padding,
        visualDensity: visualDensity,
        materialTapTargetSize: materialTapTargetSize,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        iconTheme: iconTheme,
        selectedShadowColor: selectedShadowColor,
        showCheckmark: showCheckmark,
        checkmarkColor: checkmarkColor,
        avatarBorder: avatarBorder,
        avatarBoxConstraints: avatarBoxConstraints,
        chipAnimationStyle: chipAnimationStyle,
      ),
    );
  }

  /// Injects a semantic HTML `<button>` representing this chip into the [parent] element.
  ///
  /// This is only executed on Web (`kIsWeb == true`) and is used to improve
  /// SEO and accessibility for search engines and assistive technologies.
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;

    // Create a semantic <button> element
    final button = document.createElement('button') as WebHTMLElement;
    button.id = _generateRandomId();
    button.setAttribute('type', 'button');
    button.setAttribute('role', 'button');
    button.setAttribute('aria-pressed', selected.toString());

    button.className =
        selected ? 'seo-choice-chip selected' : 'seo-choice-chip';

    // Append the label widget’s HTML equivalent
    _appendWidgetToContainer(label, button);

    // Append to the parent container
    parent.appendChild(button);
  }

  /// Appends the HTML version of a [Widget] into the given HTML [container],
  /// if the widget implements [SeoInjectable] or [SeoInjectableLayout].
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  /// Generates a unique random HTML element ID.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'choice_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
