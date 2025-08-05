import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

class SeoAppBar extends StatelessWidget
    implements SeoInjectableLayout, PreferredSizeWidget {
  final Widget? leading;
  final bool? automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final double? toolbarHeight;
  final double? leadingWidth;
  final bool? centerTitle;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;

  const SeoAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
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

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight!);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
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

  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }
}
