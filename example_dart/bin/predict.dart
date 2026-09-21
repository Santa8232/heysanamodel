import 'dart:io';

void main(List<String> args) async {
  print('========================================================');
  print('    HeySanaModel - Manipur Tourist Place Predictor     ');
  print('========================================================\n');

  // If arguments provided: <Age> <Duration> <Type> <Activity> <Budget>
  List<String> predictArgs;
  if (args.length >= 5) {
    predictArgs = args;
  } else {
    // Default test profile for Manipur Tourism
    print('ℹ️  No arguments provided. Running sample Manipur tourist profile:');
    print('   Age: 29 | Duration: 3 Days | Couple | Boating | \$250 USD\n');
    print('👉 Tip: You can pass custom tourist values anytime:');
    print('   dart run example_dart/bin/predict.dart <Age> <Days> <Type> <Activity> <Budget>');
    print('   Examples:');
    print('     - Trekking:   dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160');
    print('     - Heritage:   dart run example_dart/bin/predict.dart 45 1 Family Historical 80');
    print('     - Adventure:  dart run example_dart/bin/predict.dart 28 5 Friends Adventure 420');
    print('     - Shopping:   dart run example_dart/bin/predict.dart 40 1 Family Shopping 180\n');
    predictArgs = ['29', '3', 'Couple', 'Boating', '250'];
  }

  // Find project root
  final projectDir = Directory.current.path.endsWith('example_dart')
      ? '..'
      : '.';

  final csprojPath = '$projectDir/src/heysanamodel.csproj';

  print('⚡ Invoking Manipur Prediction Engine...');
  final process = await Process.run(
    'dotnet',
    ['run', '--project', csprojPath, '--', '--predict', ...predictArgs],
    workingDirectory: projectDir,
  );

  if (process.exitCode != 0) {
    print('❌ Prediction failed:');
    print(process.stderr);
    return;
  }

  // Print the prediction output
  print(process.stdout);
}
