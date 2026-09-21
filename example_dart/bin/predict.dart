import 'dart:io';

void main(List<String> args) async {
  print('========================================================');
  print('     HeySanaModel - Dart CLI Prediction Runner         ');
  print('========================================================\n');

  // If arguments provided: <Age> <Duration> <Type> <Activity> <Budget>
  List<String> predictArgs;
  if (args.length >= 5) {
    predictArgs = args;
  } else {
    // Default test profile
    print('ℹ️  No arguments provided. Running default test tourist profile:');
    print('   Age: 30 | Duration: 7 Days | Family | Cultural | \$1500 USD\n');
    print('👉 Tip: You can pass custom values anytime:');
    print('   dart run example_dart/bin/predict.dart <Age> <Days> <Type> <Activity> <Budget>');
    print('   Example: dart run example_dart/bin/predict.dart 55 14 Couple Luxury 8000\n');
    predictArgs = ['30', '7', 'Family', 'Cultural', '1500'];
  }

  // Find project root
  final projectDir = Directory.current.path.endsWith('example_dart')
      ? '..'
      : '.';

  final csprojPath = '$projectDir/src/heysanamodel.csproj';

  print('⚡ Invoking Prediction Engine...');
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
