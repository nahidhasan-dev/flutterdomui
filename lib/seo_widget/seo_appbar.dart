import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A Flutter AppBar widget that supports SEO-friendly HTML injection.
///
/// Implements [SeoInjectableLayout] for injecting HTML representation
/// of the AppBar into the DOM, and [PreferredSizeWidget] to specify height.
class SeoAppBar extends StatelessWidget
    implements SeoInjectableLayout, PreferredSizeWidget {
  /// The widget displayed before the [title], typically an icon or back button.
  final Widget? leading;

  /// Whether the leading widget should be automatically implied if null.
  final bool? automaticallyImplyLeading;

  /// The primary widget displayed in the AppBar, usually a [Text] widget.
  final Widget? title;

  /// Widgets to display on the right side of the AppBar.
  final List<Widget>? actions;

  /// A widget behind the toolbar and the tab bar.
  final Widget? flexibleSpace;

  /// The color of the AppBar's shadow.
  final Color? shadowColor;

  /// Surface tint color overlay for the AppBar.
  final Color? surfaceTintColor;

  /// The shape of the AppBar's material.
  final ShapeBorder? shape;

  /// Background color of the AppBar.
  final Color? backgroundColor;

  /// Foreground color of AppBar content.
  final Color? foregroundColor;

  /// Theme for icons in the AppBar.
  final IconThemeData? iconTheme;

  /// Theme for action icons in the AppBar.
  final IconThemeData? actionsIconTheme;

  /// Height of the toolbar.
  final double? toolbarHeight;

  /// Width reserved for the leading widget.
  final double? leadingWidth;

  /// Whether the title should be centered.
  final bool? centerTitle;

  /// Text style for the toolbar widgets.
  final TextStyle? toolbarTextStyle;

  /// Text style for the title widget.
  final TextStyle? titleTextStyle;

  /// Creates a [SeoAppBar] with optional parameters.
  const SeoAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.centerTitle,
    this.toolbarTextStyle,
    this.titleTextStyle,
  });

  /// The preferred size of the AppBar, based on [toolbarHeight].
  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight!);

  /// Builds the Flutter AppBar widget.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      centerTitle: centerTitle,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
    );
  }

  /// Injects the AppBar as SEO-friendly HTML elements into the [parent] container.
  ///
  /// Only works on Flutter Web. Non-web platforms are no-ops.
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;
    final headerContainer = document.createElement('header') as WebHTMLElement;

    // Leading
    if (leading != null) {
      _appendWidgetToContainer(leading!, headerContainer);
    }

    // Title
    if (title != null) {
      _appendWidgetToContainer(title!, headerContainer);
    }

    // Actions
    if (actions != null && actions!.isNotEmpty) {
      final actionsContainer = document.createElement('div') as WebHTMLElement;
      for (final action in actions!) {
        _appendWidgetToContainer(action, actionsContainer);
      }
      headerContainer.appendChild(actionsContainer);
    }

    parent.appendChild(headerContainer);
  }

  /// Helper method to append a widget to a [container] as HTML.
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }
}
