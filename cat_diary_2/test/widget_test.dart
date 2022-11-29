// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cat_diary_2/main.dart';
import 'package:cat_diary_2/memory_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    const item = Item(name: "add more todos", points: '0');
    //expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('MemoriesItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MemoriesItem(
                item: Item(name: "test", points: "0"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('MemoriesItem has a Circle Avatar', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: MemoriesItem(
                item: const Item(name: "test", points: "0"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Icon? ctext = circ.child as Icon?;
    expect(circ.backgroundColor, Colors.black54);
  });

  testWidgets('Default Memories has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Memories()));

    final listItemFinder = find.byType(MemoriesItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to Memories', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Memories()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byKey(const Key("TextInput")));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(MemoriesItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  testWidgets("Unit test for the new TextField", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Memories()));
    await tester.pump();

    await tester.tap(find.byKey(const Key("TextInput")));
    await tester.pump();

    expect(find.byKey(const Key("Thought Key")), findsOneWidget);
  });

  // One to test the tap and press actions on the items?
  // I can also make this unit test work!
  /* unfortunetely I got rid of this floating action button on the main page
  wanted to keep the unit test here because Ian made it and I didn't want to get 
  rid of his work

  testWidgets("Testing the floating action buttons on the main page",
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Memories()));
    await tester.pump();

    await tester.tap(find.byKey(const Key("Increment")));
    await tester.pump();

    expect(find.byKey(const Key("Increment")), findsOneWidget);

    await tester.tap(find.byKey(const Key("Decrement")));
    await tester.pump();

    expect(find.byKey(const Key("Decrement")), findsOneWidget);
  });
*/
  testWidgets("Testing the floating action buttons in the text field page",
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Memories()));
    await tester.pump();

    await tester.tap(find.byKey(const Key("TextInput")));
    await tester.pump();

    expect(find.byKey(const Key("Pointsgood")), findsOneWidget);
    await tester.tap(find.byKey(const Key("Pointsgood")));
    await tester.pump();

    expect(find.byKey(const Key("Pointsbad")), findsOneWidget);
    await tester.tap(find.byKey(const Key("Pointsbad")));
    await tester.pump();
  });
}
