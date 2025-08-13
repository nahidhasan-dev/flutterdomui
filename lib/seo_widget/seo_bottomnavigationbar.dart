import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A [BottomNavigationBar] widget that also supports injecting
/// semantic HTML for SEO purposes when running on the web.
///
/// This class is designed to render both the Flutter UI widget
/// and an equivalent HTML `<nav>` element for search engines.
/// It implements [SeoInjectableLayout] so it can integrate with
/// the Flutter DOM UI SEO system.
class SeoBottomNavigationBar extends StatelessWidget
    implements SeoInjectableLayout {
  /// The interactive items to display inside the navigation bar.
  ///
  /// Typically includes an icon and a label. Each item can optionally
  /// implement [SeoInjectable] or [SeoInjectableLayout] to control
  /// how it is represented in the generated HTML.
  final List<BottomNavigationBarItem> items;

  /// Called when a navigation item is tapped.
  ///
  /// The callback receives the index of the tapped item.
  final void Function(int)? onTap;

  /// The index of the currently selected item.
  final int currentIndex;

  /// The elevation of the navigation bar's material.
  final double? elevation;

  /// Defines how the items are laid out in the navigation bar.
  final BottomNavigationBarType? type;

  /// The color of the navigation bar when a fixed color layout is used.
  final Color? fixedColor;

  /// The background color of the navigation bar.
  final Color? backgroundColor;

  /// The size of the icons in the navigation items.
  final double iconSize;

  /// The color used for selected items.
  final Color? selectedItemColor;

  /// The color used for unselected items.
  final Color? unselectedItemColor;

  /// The icon theme applied to selected icons.
  final IconThemeData? selectedIconTheme;

  /// The icon theme applied to unselected icons.
  final IconThemeData? unselectedIconTheme;

  /// The font size for selected item labels.
  final double selectedFontSize;

  /// The font size for unselected item labels.
  final double unselectedFontSize;

  /// The text style for selected item labels.
  final TextStyle? selectedLabelStyle;

  /// The text style for unselected item labels.
  final TextStyle? unselectedLabelStyle;

  /// Whether to show labels for selected items.
  final bool? showSelectedLabels;

  /// Whether to show labels for unselected items.
  final bool? showUnselectedLabels;

  /// The mouse cursor to use when hovering over items.
  final MouseCursor? mouseCursor;

  /// Whether the navigation bar should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// Defines the layout of items when in landscape mode.
  final BottomNavigationBarLandscapeLayout? landscapeLayout;

  /// Whether to use the legacy color scheme for the navigation bar.
  final bool useLegacyColorScheme;

  /// Creates a [SeoBottomNavigationBar].
  const SeoBottomNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.elevation,
    this.type,
    this.fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      onTap: onTap,
      currentIndex: currentIndex,
      elevation: elevation,
      backgroundColor: backgroundColor,
      iconSize: iconSize,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedIconTheme: selectedIconTheme,
      unselectedIconTheme: unselectedIconTheme,
      selectedFontSize: selectedFontSize,
      unselectedFontSize: unselectedFontSize,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      landscapeLayout: landscapeLayout,
      useLegacyColorScheme: useLegacyColorScheme,
    );
  }

  /// Injects an HTML representation of the navigation bar into the DOM.
  ///
  /// This method is only executed when running on the web.
  /// It creates a `<nav>` container and appends each navigation
  /// item as HTML elements for SEO indexing.
  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;
    final navContainer = document.createElement('nav') as WebHTMLElement;

    // Inject each item as HTML elements
    if (items.isNotEmpty) {
      final actionsContainer = document.createElement('div') as WebHTMLElement;
      for (final item in items) {
        _appendWidgetToContainer(item, actionsContainer);
      }
      navContainer.appendChild(actionsContainer);
    }

    parent.appendChild(navContainer);
  }

  /// Appends a [BottomNavigationBarItem] to a container as an HTML element.
  ///
  /// If the item implements [SeoInjectable], it calls [createHtmlElement].
  /// If the item implements [SeoInjectableLayout], it calls [injectHtmlTo].
  void _appendWidgetToContainer(
    BottomNavigationBarItem widget,
    WebHTMLElement container,
  ) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }
}
