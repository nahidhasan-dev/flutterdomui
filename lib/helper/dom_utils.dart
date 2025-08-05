import 'package:flutter_dom_ui/dom_injector.dart';

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

WebHTMLElement _ensureMain(WebHTMLDivElement container) {
  WebElement? main = container.querySelector('main');
  if (main == null) {
    main = container.ownerDocument!.createElement('main') as WebHTMLElement;
    container.appendChild(main);
  }
  return main as WebHTMLElement;
}
