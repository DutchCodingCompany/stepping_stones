import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:stepping_stones/src/stone/stone_context.dart';

/// The base on which different stone command can be build.
/// Be default a command name is based on the name of the class extending the [Stone] in snake_case.
///
/// For example:
/// ```dart
/// class HelloWorld extends Stone {
///   @override
///   void step() {
///     print('Hello world!');
///   }
/// }
/// ```
///
/// When added to provided to `runSteppingStones` it will be available as a command `hello_world` and
/// will print 'Hello world!'.
abstract class Stone {
  /// Specify environment variable that are needed for executing the command.
  /// Guards will prevent the executing of the stone command when a specified environment is missing.
  /// For example:
  /// ```dart
  /// @override
  /// Set<String> get guards => {'MY_ENV'};
  /// ```
  Set<String> get guards => {};

  /// Specify [Stone]s that need to be executed before executing this [Stone] command.
  /// For example:
  /// ```dart
  /// @override
  /// Set<Stone> get preRun => { HelloWorld() };
  /// ```
  Set<Stone> get preRun => {};

  /// Sets a description for the [Stone] command which will be printing in the help command.
  /// For example:
  /// ```dart
  /// @override
  /// String? get description => 'Prints hello world';
  /// ```
  String? get description => null;

  /// Provide a ArgParser to parse additional options for the [Stone] command.
  /// For example:
  /// ```dart
  /// @override
  /// ArgParser? get parser => ArgParser()..addFlag('input', abbr: 'i', help: 'Provide a input file');
  /// ```
  ArgParser? get parser => null;

  /// Get a list of available environment variables.
  /// If a .env was specified when running the command it will be included in the [envs].
  Map<String, String> get envs => _context.envs;

  /// List of provided .env files when running the command.
  Set<String> get envFiles => _context.envFiles;

  /// List of args that we're provided.
  List<String> get args => _context.args;

  /// [ArgResults] from the executed command. These will be available if a [parser] was provided.
  ArgResults? get argResults => _context.argResults;

  late final StoneContext _context;

  /// Used for providing the context in which the command is run.
  /// Should not be used outside the library.
  // ignore: avoid_setters_without_getters
  set context(StoneContext context) {
    _context = context;
  }

  /// Specify the command or things that need to be executed when running this [Stone] command.
  /// For example:
  /// ```dart
  /// @override
  /// void step() {
  ///   print('Hello world!');
  /// }
  /// ```
  FutureOr<void> step();

  /// Simple helper for logging messages.
  void log(Object? message) {
    stdout.writeln('⚡️$message');
  }

  /// Helper for running shell commands. If a shell fails it will also exit the program.
  /// For example:
  /// ```dart
  /// await run('dart format');
  /// ```
  FutureOr<void> run(String command) async {
    log('Running command: $command');
    final parts = command.split(' ');
    final result = await Process.start(
      parts.first,
      parts.sublist(1),
      runInShell: true,
    );
    await stdout.addStream(result.stdout);
    await stderr.addStream(result.stderr);

    final exitCode = await result.exitCode;
    if (exitCode != 0) {
      exit(exitCode);
    }
  }

  @override
  String toString() {
    final type = runtimeType.toString();
    final exp = RegExp('(?<=[a-z])[A-Z]');

    return type.replaceAllMapped(exp, (m) => '_${m.group(0)}').toLowerCase();
  }
}
