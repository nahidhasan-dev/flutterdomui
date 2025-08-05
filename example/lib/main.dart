import 'package:example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/flutter_dom_ui.dart';

void main() {
  runApp(SeoInitializer(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
