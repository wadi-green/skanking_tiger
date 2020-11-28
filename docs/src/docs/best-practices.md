# Best Practices

## Analysis Options

Dart provides some default rules when it comes to code analysis, but these rules can be overriden through the `analysis_options.yaml` file.
By default, the dart linting rules aren't very strict and don't enfore all the best practices. For this reason, I used [Lint for Dart/Flutter](https://pub.dev/packages/lint) in this project to provide stricter rules and make sure the codebase stays healthy.

In addition to that, I override some linting rules on top of the lint package for more consistency. The overriden rules are:
- `prefer_relative_imports`: in order to avoid breaking the code when renaming the package, it's preferred to use relative imports inside of the lib folder. [Source](https://dart-lang.github.io/linter/lints/prefer_relative_imports.html)
- `prefer_single_quotes`: To ensure consistency in the entire project, this rule is used to enforce using single quotes for strings whenever possible.
