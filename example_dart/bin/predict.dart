import 'dart:io';

void main(List<String> args) async {
  print('========================================================');
  print('    HeySanaModel - Manipur Tourist Place Predictor     ');
  print('========================================================\n');

  // Multi-Feature Arguments: <Age> <Days> <Type> <Activity> <Budget> [Season] [Fitness] [Stay]
  List<String> predictArgs;
  if (args.length >= 5) {
    predictArgs = args;
  } else {
    // Default test profile for Manipur Tourism
    print('ℹ️  No arguments provided. Running rich sample Manipur tourist profile:');
    print('   Age: 26 | Duration: 4 Days | Friends | Trekking | \$200 USD | Summer | Active | Camping\n');
    print('👉 Tip: You can pass custom tourist values with all 8 features:');
    print('   dart run example_dart/bin/predict.dart <Age> <Days> <Type> <Activity> <Budget> [Season] [Fitness] [Stay]\n');
    print('   Feature Options:');
    print('     - Type:       Solo | Friends | Family | Couple');
    print('     - Activity:   Trekking | Boating | Wildlife | Cultural | Historical | Shopping | Adventure | Pottery | Caving | Waterfalls | Gardens');
    print('     - Season:     Winter | Spring | Summer | Autumn');
    print('     - Fitness:    Relaxed | Moderate | Active');
    print('     - Stay:       Resort | Homestay | Hotel | Camping | Farmstay\n');
    print('   Examples:');
    print('     - Dzukou Valley:  dart run example_dart/bin/predict.dart 24 4 Solo Trekking 160 Summer Active Camping');
    print('     - Loktak Lake:    dart run example_dart/bin/predict.dart 32 3 Couple Boating 270 Winter Relaxed Resort');
    print('     - Kangla Fort:    dart run example_dart/bin/predict.dart 45 1 Family Historical 80 Winter Relaxed Hotel');
    print('     - Shirui Hills:   dart run example_dart/bin/predict.dart 28 5 Friends Adventure 420 Spring Active Homestay');
    print('     - Andro Village:  dart run example_dart/bin/predict.dart 30 1 Solo Pottery 50 Autumn Relaxed Homestay');
    print('     - Tamenglong:     dart run example_dart/bin/predict.dart 27 3 Solo Caving 220 Winter Active Camping');
    print('     - Sadu Chiru:     dart run example_dart/bin/predict.dart 35 2 Family Waterfalls 130 Spring Moderate Resort');
    print('     - Kakching:       dart run example_dart/bin/predict.dart 48 2 Family Gardens 120 Winter Relaxed Farmstay\n');
    predictArgs = ['26', '4', 'Friends', 'Trekking', '200', 'Summer', 'Active', 'Camping'];
  }

  // Find project root
  final projectDir = Directory.current.path.endsWith('example_dart')
      ? '..'
      : '.';

  final csprojPath = '$projectDir/src/heysanamodel.csproj';

  print('⚡ Invoking Manipur Prediction Engine...');
  final process = await Process.run(
    'dotnet',
    ['run', '--project', csprojPath, '--configuration', 'Release', '--', '--predict', ...predictArgs],
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
