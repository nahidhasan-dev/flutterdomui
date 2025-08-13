import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/helper/seo_injectable.dart';
import 'package:flutter_dom_ui/dom_injector.dart';

/// A scrollable container that behaves like [SingleChildScrollView] but
/// can inject a corresponding HTML `<div>` structure for SEO purposes
/// when running on the web.
///
/// The HTML container uses CSS `overflow` properties to mimic scrolling
/// behavior and can include a single child element that is also SEO-injectable.
class SeoSingleChildScrollView extends StatelessWidget
    implements SeoInjectableLayout {
  /// The axis along which the scroll view scrolls.
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction (false) or
  /// the reverse direction (true).
  final bool reverse;

  /// Empty space to inscribe inside the scroll view.
  final EdgeInsetsGeometry? padding;

  /// Whether this is the primary scroll view associated with the parent.
  final bool? primary;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// An optional controller for the scroll view.
  final ScrollController? controller;

  /// The single child widget to be placed inside the scroll view.
  final Widget? child;

  /// Determines the drag start behavior for the scroll view.
  final DragStartBehavior dragStartBehavior;

  /// How to clip the content when it overflows.
  final Clip clipBehavior;

  /// Hit testing behavior of the scroll view.
  final HitTestBehavior hitTestBehavior;

  /// Optional restoration ID for state restoration.
  final String? restorationId;

  /// How the keyboard should be dismissed when scrolling.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Creates a [SeoSingleChildScrollView].
  const SeoSingleChildScrollView({
    super.key,

    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.child,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      primary: primary,
      physics: physics,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      clipBehavior: clipBehavior,
      hitTestBehavior: hitTestBehavior,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: child,
    );
  }

  @override
  void injectHtmlTo(WebHTMLElement parent) {
    if (!kIsWeb) return;
    final document = webWindow.document;

    // Create a container div to mimic the scroll view
    final divContainer = document.createElement('div') as WebHTMLDivElement;
    divContainer.id = _generateRandomId();

    divContainer.style
      ..overflowY = scrollDirection == Axis.vertical ? 'auto' : 'hidden'
      ..overflowX = scrollDirection == Axis.horizontal ? 'auto' : 'hidden'
      ..maxHeight = '100%'
      ..maxWidth = '100%';

    // Add padding if any
    if (padding != null) {
      final resolved = padding!.resolve(TextDirection.ltr);
      divContainer.style
        ..paddingTop = '${resolved.top}px'
        ..paddingBottom = '${resolved.bottom}px'
        ..paddingLeft = '${resolved.left}px'
        ..paddingRight = '${resolved.right}px';
    }

    // Inject the child widget as HTML
    if (child != null) {
      _appendWidgetToContainer(child!, divContainer);
    }

    parent.appendChild(divContainer);
  }

  /// Helper to inject child widgets recursively.
  void _appendWidgetToContainer(Widget widget, WebHTMLElement container) {
    if (widget is SeoInjectable) {
      final el = (widget as SeoInjectable).createHtmlElement();
      if (el != null) container.appendChild(el);
    } else if (widget is SeoInjectableLayout) {
      (widget as SeoInjectableLayout).injectHtmlTo(container);
    }
  }

  /// Generates a random HTML id for the container.
  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return 'scrollView_${List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join()}';
  }
}
