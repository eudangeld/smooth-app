// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_ui_library/dialogs/smooth_category_picker.dart';

class TestCategory extends Category<String> {
  TestCategory(String value, [Iterable<TestCategory>? children])
      : super(value, children);

  @override
  TestCategory? operator [](String childValue) {
    return super[childValue] as TestCategory?;
  }

  @override
  String get label => value;
}

TestCategory categories = TestCategory(
  'fruit',
  <TestCategory>{
    TestCategory(
      'apple',
      <TestCategory>{
        TestCategory(
          'red',
          <TestCategory>[
            TestCategory('Red Delicious'),
            TestCategory('Fuji'),
            TestCategory('Crispin'),
            TestCategory('Pink Lady'),
          ],
        ),
        TestCategory(
          'yellow',
          <TestCategory>[
            TestCategory('Yellow Delicious'),
            TestCategory('Ginger Gold'),
          ],
        ),
        TestCategory(
          'green',
          <TestCategory>[
            TestCategory('Granny Smith'),
          ],
        ),
      },
    ),
    TestCategory(
      'berry',
      <TestCategory>{
        TestCategory('blueberry'),
        TestCategory('raspberry'),
      },
    ),
  },
);

TestCategory? getCategory(Iterable<String> path) {
  if (path.isEmpty) {
    return null;
  }
  TestCategory? result = categories.value == path.first ? categories : null;
  final List<String> followPath = path.skip(1).toList();
  while (result != null && followPath.isNotEmpty) {
    result = result[followPath.first];
    followPath.removeAt(0);
  }
  return result;
}

void main() {
  group('SmoothCategoryPicker', () {
    testWidgets('can navigate', (WidgetTester tester) async {
      List<String> currentCategoryPath = <String>['fruit', 'apple'];
      Set<String> currentCategories = <String>{'Granny Smith'};
      bool requestedNewCategory = false;
      await tester.pumpWidget(
        MaterialApp(
          home: SmoothCategoryPicker<String>(
            categoryFinder: getCategory,
            currentPath: currentCategoryPath,
            currentCategories: currentCategories,
            onCategoriesChanged: (Set<String> value) {
              currentCategories = value;
            },
            onPathChanged: (Iterable<String> path) {
              currentCategoryPath = path.toList();
            },
            onAddCategory: (List<String> path) {
              requestedNewCategory = true;
            },
          ),
        ),
      );
      await tester.tap(find.text('red'));
      await tester.pumpAndSettle();
      expect(currentCategoryPath, equals(<String>['fruit', 'apple', 'red']));
      expect(currentCategories, equals(<String>{'Granny Smith'}));
      expect(requestedNewCategory, isFalse);
      await tester.pumpWidget(
        MaterialApp(
          home: SmoothCategoryPicker<String>(
            categoryFinder: getCategory,
            currentPath: currentCategoryPath,
            currentCategories: currentCategories,
            onCategoriesChanged: (Set<String> value) {
              currentCategories = value;
            },
            onPathChanged: (Iterable<String> path) {
              currentCategoryPath = path.toList();
            },
            onAddCategory: (List<String> path) {
              requestedNewCategory = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(currentCategoryPath, equals(<String>['fruit', 'apple', 'red']));
      expect(currentCategories, equals(<String>{'Granny Smith'}));
      expect(requestedNewCategory, isFalse);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(currentCategoryPath, equals(<String>['fruit', 'apple']));
      expect(currentCategories, equals(<String>{'Granny Smith'}));
      expect(requestedNewCategory, isFalse);
    });
    testWidgets('can set category List', (WidgetTester tester) async {
      List<String> currentCategoryPath = <String>['fruit', 'apple', 'red'];
      Set<String> currentCategories = <String>{'Granny Smith'};
      bool requestedNewCategory = false;
      await tester.pumpWidget(
        MaterialApp(
          home: SmoothCategoryPicker<String>(
            categoryFinder: getCategory,
            currentPath: currentCategoryPath,
            currentCategories: currentCategories,
            onCategoriesChanged: (Set<String> value) {
              currentCategories = value;
            },
            onPathChanged: (Iterable<String> path) {
              currentCategoryPath = path.toList();
            },
            onAddCategory: (List<String> path) {
              requestedNewCategory = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox).first);
      expect(currentCategoryPath, equals(<String>['fruit', 'apple', 'red']));
      expect(
          currentCategories, equals(<String>{'Granny Smith', 'Red Delicious'}));
      expect(requestedNewCategory, isFalse);
    });
    testWidgets('can create new categories', (WidgetTester tester) async {
      List<String> currentCategoryPath = <String>['fruit', 'apple', 'red'];
      Set<String> currentCategories = <String>{'Granny Smith'};
      List<String> newCategoryPath = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: SmoothCategoryPicker<String>(
            categoryFinder: getCategory,
            currentPath: currentCategoryPath,
            currentCategories: currentCategories,
            onCategoriesChanged: (Set<String> value) {
              currentCategories = value;
            },
            onPathChanged: (Iterable<String> path) {
              currentCategoryPath = path.toList();
            },
            onAddCategory: (List<String> path) {
              newCategoryPath = path;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton).first);
      expect(currentCategoryPath, equals(<String>['fruit', 'apple', 'red']));
      expect(currentCategories, equals(<String>{'Granny Smith'}));
      expect(newCategoryPath, equals(<String>['fruit', 'apple', 'red']));
    });
    testWidgets('can remove categories', (WidgetTester tester) async {
      List<String> currentCategoryPath = <String>['fruit', 'apple', 'red'];
      Set<String> currentCategories = <String>{'Granny Smith', 'Red Delicious'};
      List<String> newCategoryPath = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          home: SmoothCategoryPicker<String>(
            categoryFinder: getCategory,
            currentPath: currentCategoryPath,
            currentCategories: currentCategories,
            onCategoriesChanged: (Set<String> value) {
              currentCategories = value;
            },
            onPathChanged: (Iterable<String> path) {
              currentCategoryPath = path.toList();
            },
            onAddCategory: (List<String> path) {
              newCategoryPath = path;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.cancel).first);
      await tester.pumpAndSettle();
      expect(currentCategoryPath, equals(<String>['fruit', 'apple', 'red']));
      expect(currentCategories, equals(<String>{'Red Delicious'}));
      expect(newCategoryPath, isEmpty);
    });
  });
  group('SmoothCategoryDisplay', () {
    testWidgets('can toggle deletable', (WidgetTester tester) async {
      final Set<String> currentCategories = <String>{
        'Granny Smith',
        'Red Delicious'
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmoothCategoryDisplay<String>(
              categories: currentCategories,
              onDeleted: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.cancel), findsNothing);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmoothCategoryDisplay<String>(
              categories: currentCategories,
              onDeleted: (String value) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.cancel), findsNWidgets(2));
    });
    testWidgets('can delete', (WidgetTester tester) async {
      final Set<String> currentCategories = <String>{
        'Granny Smith',
        'Red Delicious'
      };
      expect(find.byIcon(Icons.cancel), findsNothing);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmoothCategoryDisplay<String>(
              categories: currentCategories,
              onDeleted: (String value) {
                currentCategories.remove(value);
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.cancel), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.cancel).first);
      await tester.pumpAndSettle();
      expect(currentCategories, equals(<String>{'Red Delicious'}));
    });
  });
}
