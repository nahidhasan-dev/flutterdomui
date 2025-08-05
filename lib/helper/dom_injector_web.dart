import 'package:web/web.dart' as web;

typedef WebHTMLElement = web.HTMLElement;
typedef WebHTMLDivElement = web.HTMLDivElement;
typedef WebHTMLImageElement = web.HTMLImageElement;
typedef WebElement = web.Element;
typedef WebDocument = web.Document;
final webWindow = web.window;

void clearElementChildren(web.HTMLElement container) {
  while (container.firstChild != null) {
    container.removeChild(container.firstChild!);
  }
}
