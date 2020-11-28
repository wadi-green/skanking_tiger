# Test Coverage

The tests in this project don't aim to provide 100% code coverage. They are more focused on testing the important features to ensure their proper behavior.
Such tests include: button clicks, navigation, smoke tests, widget loading, etc.  

There are two types of tests conducted inside the app:
1. **Unit tests**: to test a single function, method, or class. The goal of a unit test is to verify the correctness of a unit of logic under a variety of conditions.
2. **Widget tests**: to test a single widget (i.e component test). The goal of a widget test is to verify that the widget’s UI looks and interacts as expected.

## Running unit and widget tests

### From inside the editor (Android studio or VSCode)
1. Open the test file  
2. Press the run icon next to the test or group of tests you want to run

### From the terminal
1. Open the root of the project in a terminal
2. Run the following command:
```dart
flutter test test/test_name.dart
```

**Note**: To run all unit and widget tests at once, run the command:
```dart
flutter test
``` 

## Golden tests

A subtype of the widget tests performed in the app is "Golden Tests". What they do is that they allow us to verify that complex widgets are rendering 
properly by doing the rendering then comparing them to snapshots that we manually verify.

All these tests are located under `test/golden_test.dart` and the corresponding images are located under the `test/golden` directory.

In case any of the widgets were updated and you'd like to regenerate the snapshots that the tests are comparing to, simply run the following command:
```dart
flutter test --update-goldens test/golden_tests.dart
``` 

After that you can check the generated images and verify that they look as expected. 

**PS:** Golden tests may sometimes render a visual representation of the text or icons without rendering the actual text or icon. They aim to test
the overall look not the exact words written in the widget. So if you see black rectangles instead of text in the generated goldens, that's expected
and doesn't mean there's a problem 