import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:stepping_stones/src/stone/stone.dart';
import 'package:stepping_stones/src/stone/stone_context.dart';

/// Entry point of running the provided [Stone]s.
/// Pass a list of [Stone]s and the [args] from a dart entry point.
///
/// For example:
/// ```dart
/// void main(List<String> args) async {
///   await runSteppingStones(
///     [
///       ...defaultSteps,
///       ...buildSteps,
///     ],
///     args,
///   );
/// }
/// ```
Future<void> runSteppingStones(List<Stone> stones, List<String> args) async {
  final parser = _createParser(stones);

  final argResult = parser.parse(args);

  if (args.isEmpty) {
    stderr.write('No stone command provided');
    _help(stones, parser);
    exit(1);
  }

  final stoneCommand = argResult.command?.name;

  if (stoneCommand == 'help') {
    _help(stones, parser);
    exit(0);
  }

  final stone = stones.firstWhereOrNull((s) => s.toString() == stoneCommand);

  if (stone == null) {
    stderr.write('Stone command not found: $stoneCommand');
    _help(stones, parser);
    exit(1);
  } else {
    final context = StoneContext.fromArgs(argResult);

    await _runStep(stone, context);
  }

  //TODO(Guldem): Add version check warning
}

Future<void> _runStep(Stone stone, StoneContext context) async {
  stone.context = context;
  context.guard(stone.guards);

  for (final preStone in stone.preRun) {
    await _runStep(preStone, context);
  }

  await stone.step();
}

ArgParser _createParser(List<Stone> stones) {
  final parser = ArgParser()
    ..addMultiOption('env', abbr: 'e', help: 'Load environment variables from a file')
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output')
    ..addFlag('help', abbr: 'h', help: 'Print this help description');

  final addedCommands = <String>{};
  for (final step in stones) {
    final name = step.toString();
    if (addedCommands.contains(name)) {
      throw ArgumentError('Duplicate stone command name: $name');
    } else {
      parser.addCommand(name, step.parser);
      addedCommands.add(name);
    }
  }
  return parser;
}

void _help(List<Stone> stones, ArgParser parser) {
  stdout
    ..writeln('Usage: <command>  [options]\n')
    ..writeln(parser.usage)
    ..writeln('\nAvailable stone commands:');

  final longestStepLength = stones.fold(0, (previousValue, e) {
    final name = e.toString();
    return previousValue > name.length ? previousValue : name.length;
  });

  for (final stone in stones) {
    final name = stone.toString();

    final padding = ' ' * (longestStepLength - name.length);
    stdout.writeln('$name:$padding\t ${stone.description ?? ''}');
    if (stone.parser?.usage.isNotEmpty ?? false) {
      final emptyPadding = ' ' * (longestStepLength + 1);
      stdout.writeln('$emptyPadding\t ${stone.parser!.usage}');
    }
  }
}
