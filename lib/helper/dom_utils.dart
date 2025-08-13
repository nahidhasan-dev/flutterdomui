import 'package:flutter_dom_ui/dom_injector.dart';

/// Ensures that the SEO main container element exists in the document.
///
/// Looks for a `<div>` with id `seo-content`. If not found, it creates one
/// with `display: none` and appends it to the document body. Then it ensures
/// a `<main>` element exists inside the container.
///
/// Returns the `<main>` element wrapped as [WebHTMLElement].
WebHTMLElement ensureSeoMainElement() {
  final document = webWindow.document;
  WebElement? containerEl = document.getElementById('seo-content');
  if (containerEl == null) {
    final div = document.createElement('div') as WebHTMLDivElement;
    div.id = 'seo-content';
    div.style.display = 'none';
    document.body?.appendChild(div);
    return _ensureMain(div);
  } else {
    return _ensureMain(containerEl as WebHTMLDivElement);
  }
}

/// Ensures that the given [container] has a `<main>` element inside.
///
/// If a `<main>` element does not exist, it creates one and appends it to
/// the [container].
///
/// Returns the `<main>` element wrapped as [WebHTMLElement].
WebHTMLElement _ensureMain(WebHTMLDivElement container) {
  WebElement? main = container.querySelector('main');
  if (main == null) {
    main = container.ownerDocument!.createElement('main') as WebHTMLElement;
    container.appendChild(main);
  }
  return main as WebHTMLElement;
}
