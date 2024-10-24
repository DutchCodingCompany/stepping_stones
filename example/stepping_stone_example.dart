import 'package:stepping_stones/stepping_stones.dart';

import '../bin/build_steps.dart';
import '../bin/default_steps.dart';

void main(List<String> args) async {
  await runSteppingStones(
    [
      ...defaultSteps,
      ...buildSteps,
    ],
    args,
  );
}
