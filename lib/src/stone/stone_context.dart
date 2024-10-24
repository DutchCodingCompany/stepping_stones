import 'dart:io';

import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart';
import 'package:stepping_stones/src/stone/stone.dart';

/// Wrapper class for configuring all needed context information.
final class StoneContext {

  /// Wrapper class for configuring all needed context information.
  const StoneContext({
    required this.envs,
    required this.args,
    required this.argResults,
    required this.envFiles,
    required this.isVerbose,
  });

  /// Create a [StoneContext] from [ArgResults].
  factory StoneContext.fromArgs(ArgResults args) {
    final envs = {
      ...Platform.environment,
    };

    final envFiles = args.multiOption('env');

    final dotEnvs = DotEnv()..load(envFiles);

    // Is needed to include .env files envs into envs.
    // ignore: invalid_use_of_visible_for_testing_member
    envs.addAll(dotEnvs.map);

    return StoneContext(
      envs: envs,
      args: args.rest,
      argResults: args.command,
      envFiles: envFiles.toSet(),
      isVerbose: args.flag('verbose'),
    );
  }
  /// List of environment variable. Can includes .env file environment.
  final Map<String, String> envs;

  /// List of left over args from a command.
  final List<String> args;

  /// [ArgResults] when a [Stone] provide a custom parser.
  final ArgResults? argResults;

  /// Flag indicating if verbose logging is enabled
  final bool isVerbose;

  /// List of provided .env files
  final Set<String> envFiles;

  /// Run a guard check against the provided [envs]. When a env is missing it will exit the program.
  void guard(Set<String> guards) {
    final missing = guards.difference(envs.keys.toSet());
    if (missing.isNotEmpty) {
      stderr.writeln('Missing variables: ${missing.join(', ')}');
      exit(1);
    }
  }
}
