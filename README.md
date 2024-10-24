<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# Dart Stepping Stones: A Simplified Command Sharing Package

**Inspired by Makefile and Gradle, Stepping Stones provides a straightforward way to define and execute common commands within your Dart projects. By writing these commands directly in Dart code, you can easily share and reuse them across different parts of your application.**

## Key features:

- Define custom commands (Stones): Create reusable Dart functions to encapsulate frequently used operations.
- Organize commands: Group related commands into logical structures for better management.
- Execute commands: Easily invoke defined commands with a simple syntax.
- Flexibility: Customize command execution behavior with options and arguments.

Example:

```dart
import 'package:stepping_stones/stepping_stones.dart';

void main(List<String> args) async {
  await runSteppingStones(
    [
      Clean(),
      Format(),
      Get(),
    ],
    args,
  );
}

class Clean extends Stone {
  @override
  FutureOr<void> step() async {
    await run('flutter clean');
  }
}

class Format extends Stone {
  @override
  FutureOr<void> step() async {
    await run('dart format -l 120 .');
  }
}

class Get extends Stone {
  @override
  FutureOr<void> step() async {
    await run('flutter pub get');
  }
}
```

To execute the commands, run the following Dart script:

```bash
dart run bin/main.dart format
````

or compile the configuration into a executable:

```bash
dart compile exe bin/main.dart -o bin/awesome
```

and run it with:
```bash
.bin/awesome format
```

## Benefits:

- Use Dart: Define commands in Dart code, leveraging the language's features and ecosystem.
- Improved code organization: Centralize and manage common commands in a single location.
- Enhanced productivity: Quickly execute frequently used tasks without repetitive typing.
- Simplified collaboration: Share command definitions with team members for efficient project workflows.
- Stepping Stones offers a convenient and efficient solution for streamlining operations in your Dart projects.

## Getting started

Add `stepping_stones` to your projects dev dependencies:

```bash
dart pub add --dev stepping_stones
```

Create a Dart file with a `main` entry point as starting point for running your `stones`.

```dart
import 'package:stepping_stones/stepping_stones.dart';

void main(List<String> args) async {
  await runSteppingStones(
    [
     // Add your stones here
    ],
    args,
  );
}
```

Create a new class that extends `Stone` and override the `step` method to define your command.

```dart
class MyStone extends Stone {
  @override
  FutureOr<void> step() async {
    // Add your command here
  }
}
```

Add your stone to the `runSteppingStones` function in your `main` method. 

Run the script with `dart run bin/main.dart` and pass the name of the stone in snake_case.

## Additional information

It's just a simple helper utility we like to use to share commands between projects and team members. 
Feel free to leave some feedback or open a pull request :)
