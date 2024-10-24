import 'dart:async';

import 'package:stepping_stones/src/stone/stone.dart';

final defaultSteps = <Stone>[
  Clean(),
  Format(),
  Get(),
  Analyze(),
  CheckFormat(),
  CheckStyle(),
  CodeGen(),
  CodeGenWatcher(),
  UpdateGoldens(),
];

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

class Analyze extends Stone {
  @override
  FutureOr<void> step() async {
    await run('flutter analyze --no-pub --no-fatal-infos');
  }
}

class CheckFormat extends Stone {
  @override
  FutureOr<void> step() async {
    await run('dart format --output=none -l 120 --set-exit-if-changed .');
  }
}

class CheckStyle extends Stone {
  @override
  Set<Stone> preRun = {Analyze(), CheckFormat()};

  @override
  void step() {}
}


class CodeGen extends Stone {
  @override
  Set<Stone> preRun = {Get()};

  @override
  FutureOr<void> step() async {
    await run('flutter pub run build_runner build --delete-conflicting-outputs');
  }
}

class CodeGenWatcher extends Stone {
  @override
  Set<Stone> preRun = {Get()};

  @override
  FutureOr<void> step() async {
    await run('flutter pub run build_runner watch --delete-conflicting-outputs');
  }
}

class UpdateGoldens extends Stone {
  @override
  FutureOr<void> step() async {
    await run('flutter test --update-goldens');
  }
}
