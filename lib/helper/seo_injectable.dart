import 'package:flutter_dom_ui/dom_injector.dart';

abstract class SeoInjectable {
  WebHTMLElement? createHtmlElement();
}

abstract class SeoInjectableLayout {
  void injectHtmlTo(WebHTMLElement parent);
}
