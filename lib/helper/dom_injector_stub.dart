/// A placeholder type for `HTMLElement` when running on non-web platforms.
///
/// On non-web targets, this is simply a `dynamic` type to avoid compile errors.
typedef WebHTMLElement = dynamic;

/// A placeholder type for generic web elements when running on non-web platforms.
typedef WebElement = dynamic;

/// A placeholder type for `HTMLDivElement` when running on non-web platforms.
typedef WebHTMLDivElement = dynamic;

/// A placeholder type for `HTMLImageElement` when running on non-web platforms.
typedef WebHTMLImageElement = dynamic;

/// A placeholder type for the HTML document object when running on non-web platforms.
typedef WebDocument = dynamic;

/// Represents the `window` object in web environments.
///
/// On non-web platforms, this is always `null`.
final webWindow = null;

/// Clears all children of the given [container] element.
///
/// On non-web platforms, this is a no-op.
void clearElementChildren(Object container) {}
