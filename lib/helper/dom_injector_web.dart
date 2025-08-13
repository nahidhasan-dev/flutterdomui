import 'package:web/web.dart' as web;

/// Represents a generic HTML element in the DOM.
///
/// This type alias points to [web.HTMLElement] when running in a web environment.
typedef WebHTMLElement = web.HTMLElement;

/// Represents an HTML `<div>` element in the DOM.
///
/// This type alias points to [web.HTMLDivElement].
typedef WebHTMLDivElement = web.HTMLDivElement;

/// Represents an HTML `<img>` element in the DOM.
///
/// This type alias points to [web.HTMLImageElement].
typedef WebHTMLImageElement = web.HTMLImageElement;

/// Represents any generic DOM element.
///
/// This type alias points to [web.Element].
typedef WebElement = web.Element;

/// Represents the HTML document object.
///
/// This type alias points to [web.Document].
typedef WebDocument = web.Document;

/// Reference to the global `window` object in the browser.
final webWindow = web.window;

/// Removes all child nodes from the given [container] element.
///
/// This function iterates over all children of the [container]
/// and removes them until no child remains.
///
/// Example:
/// ```dart
/// clearElementChildren(myDiv);
/// ```
void clearElementChildren(web.HTMLElement container) {
  while (container.firstChild != null) {
    container.removeChild(container.firstChild!);
  }
}
