import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dom_ui/flutter_dom_ui.dart';

void main() {
  testWidgets('SeoText renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SeoText('Hello SEO!')));
    expect(find.text('Hello SEO!'), findsOneWidget);
  });

  testWidgets('SeoButton renders and taps', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SeoButton(onPressed: () => tapped = true, label: 'Tap me'),
      ),
    );
    await tester.tap(find.text('Tap me'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('SeoContainer renders child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SeoContainer(child: Text('Inside container'))),
    );
    expect(find.text('Inside container'), findsOneWidget);
  });

  testWidgets('SeoColumn lays out children vertically', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: SeoColumn(children: [Text('One'), Text('Two')])),
    );
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
  });

  testWidgets('SeoRow lays out children horizontally', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: SeoRow(children: [Text('Left'), Text('Right')])),
    );
    expect(find.text('Left'), findsOneWidget);
    expect(find.text('Right'), findsOneWidget);
  });

  testWidgets('SeoImage renders with semantics', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SeoImage(src: 'https://example.com/image.png', alt: 'Alt Image'),
      ),
    );
    expect(find.byType(SeoImage), findsOneWidget);
  });

  testWidgets('SeoLink renders and taps', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SeoLink(
          href: 'https://example.com',
          onTap: () => tapped = true,
          text: 'Click Link',
        ),
      ),
    );
    await tester.tap(find.text('Click Link'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('SeoTextField renders with initial text', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController(text: 'Initial');
    await tester.pumpWidget(
      MaterialApp(home: SeoTextField(controller: controller)),
    );
    expect(find.byType(SeoTextField), findsOneWidget);
    expect(find.text('Initial'), findsOneWidget);
  });

  testWidgets('SeoAppBar renders title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: SeoAppBar(title: Text('SEO AppBar'))),
      ),
    );
    expect(find.text('SEO AppBar'), findsOneWidget);
  });

  testWidgets('SeoCenter centers child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SeoCenter(child: Text('Centered'))),
    );
    expect(find.text('Centered'), findsOneWidget);
  });

  testWidgets('SeoScaffold renders with app bar and body', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SeoScaffold(
          metaTitle: 'Title',
          appBar: SeoAppBar(title: Text('Title')),
          body: Text('Body content'),
        ),
      ),
    );
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Body content'), findsOneWidget);
  });

  testWidgets('SeoInitializer can wrap child', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SeoInitializer(child: Text('SEO Init'))),
    );
    expect(find.text('SEO Init'), findsOneWidget);
  });
}
