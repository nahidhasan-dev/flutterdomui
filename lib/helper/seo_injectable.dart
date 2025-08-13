import 'package:flutter_dom_ui/dom_injector.dart';

/// Interface for classes that can create a custom HTML element for SEO.
///
/// Implement this interface to provide a DOM element representation
/// for your Flutter widget that can be injected into the web page.
abstract class SeoInjectable {
  /// Creates and returns a [WebHTMLElement] to represent this object in the DOM.
  ///
  /// Returns `null` if no element should be created.
  WebHTMLElement? createHtmlElement();
}

/// Interface for classes that can inject HTML elements into a parent container.
///
/// Implement this interface to define how your HTML element should be added
/// to the DOM tree.
abstract class SeoInjectableLayout {
  /// Injects the HTML element into the given [parent] container.
  void injectHtmlTo(WebHTMLElement parent);
}
