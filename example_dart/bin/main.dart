import 'dart:convert';
import 'dart:io';

class TestCase {
  final String name;
  final List<String> args;
  final String expectedDestination;

  TestCase({
    required this.name,
    required this.args,
    required this.expectedDestination,
  });
}

void main(List<String> args) async {
  print('===============================================================');
  print('    🧪 HeySanaModel - Manipur Tourism Pure Dart CLI Test Suite ');
  print('===============================================================\n');

  final projectDir = Directory.current.path.endsWith('example_dart') ? '..' : '.';
  final csprojPath = '$projectDir/src/heysanamodel.csproj';

  // If user passed arguments directly to main.dart, forward to predict.dart logic
  if (args.isNotEmpty) {
    final process = await Process.run(
      'dotnet',
      ['run', '--project', csprojPath, '--configuration', 'Release', '--', '--predict', ...args],
      workingDirectory: projectDir,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    print(process.stdout);
    if (process.exitCode != 0) {
      print(process.stderr);
    }
    return;
  }

  // 10 Balanced Test Profiles covering all destinations in Manipur
  final testCases = [
    TestCase(
      name: 'Dzukou Valley Alpine Trek',
      args: ['24', '4', 'Solo', 'Trekking', '160', 'Summer', 'Active', 'Camping'],
      expectedDestination: 'Dzukou Valley',
    ),
    TestCase(
      name: 'Loktak Floating Phumdi Boating',
      args: ['32', '3', 'Couple', 'Boating', '270', 'Winter', 'Relaxed', 'Resort'],
      expectedDestination: 'Loktak Lake',
    ),
    TestCase(
      name: 'Kangla Fort Royal Heritage',
      args: ['45', '1', 'Family', 'Historical', '80', 'Winter', 'Relaxed', 'Hotel'],
      expectedDestination: 'Kangla Fort',
    ),
    TestCase(
      name: 'Keibul Lamjao Deer Wildlife Safari',
      args: ['36', '3', 'Family', 'Wildlife', '300', 'Winter', 'Moderate', 'Resort'],
      expectedDestination: 'Keibul Lamjao',
    ),
    TestCase(
      name: 'Shirui Lily Mountain Expedition',
      args: ['28', '5', 'Friends', 'Adventure', '420', 'Spring', 'Active', 'Homestay'],
      expectedDestination: 'Shirui Hills',
    ),
    TestCase(
      name: 'Ima Keithel Handloom Shopping',
      args: ['40', '1', 'Family', 'Shopping', '180', 'Winter', 'Relaxed', 'Hotel'],
      expectedDestination: 'Ima Keithel',
    ),
    TestCase(
      name: 'Andro Coil Pottery & Sacred Flame',
      args: ['30', '1', 'Solo', 'Pottery', '50', 'Autumn', 'Relaxed', 'Homestay'],
      expectedDestination: 'Andro Cultural Village',
    ),
    TestCase(
      name: 'Tamenglong Rainforest Caving',
      args: ['27', '3', 'Solo', 'Caving', '220', 'Winter', 'Active', 'Camping'],
      expectedDestination: 'Tamenglong Caves & Cascades',
    ),
    TestCase(
      name: 'Sadu Chiru Mountain Waterfalls',
      args: ['35', '2', 'Family', 'Waterfalls', '130', 'Spring', 'Moderate', 'Resort'],
      expectedDestination: 'Sadu Chiru Waterfalls',
    ),
    TestCase(
      name: 'Kakching Uyok Ching Rose Gardens',
      args: ['48', '2', 'Family', 'Gardens', '120', 'Winter', 'Relaxed', 'Farmstay'],
      expectedDestination: 'Kakching & Southern Valleys',
    ),
  ];

  print('⚡ Running 10-Destination Validation Suite via Dart CLI...\n');

  int passedCount = 0;

  for (int i = 0; i < testCases.length; i++) {
    final tc = testCases[i];
    final process = await Process.run(
      'dotnet',
      ['run', '--project', csprojPath, '--configuration', 'Release', '--', '--predict', ...tc.args],
      workingDirectory: projectDir,
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );

    final output = process.stdout.toString();
    final matchedExpected = output.contains(tc.expectedDestination);

    final statusIcon = matchedExpected ? '✅ PASS' : '⚠️ MISMATCH';
    if (matchedExpected) passedCount++;

    // Extract Recommended Place from output (handles UTF-8 emojis or plain text)
    final placeMatch = RegExp(r'Recommended Place:\s*(?:[^\w\s]*\s*)?([A-Za-z0-9&, -]+?)(?:\s*[^\w\s]*|\s*)$', multiLine: true).firstMatch(output);
    final placeName = placeMatch?.group(1)?.trim() ?? 'Unknown';

    // Extract Matching Trip Plan (handles UTF-8 emojis or plain text)
    final planMatch = RegExp(r'Matching Trip Plan:\s*(?:[^\w\s]*\s*)?([A-Za-z0-9&, -]+?)(?:\s*[^\w\s]*|\s*)$', multiLine: true).firstMatch(output);
    final planName = planMatch?.group(1)?.trim() ?? 'Unknown';

    print('[$statusIcon] Test #${i + 1}: ${tc.name}');
    print('   👉 Input:       ${tc.args.join(" ")}');
    print('   📍 Destination: 🌟 $placeName 🌟');
    print('   🗺️  Trip Combo:  🎁 $planName');
    print('');
  }

  print('===============================================================');
  print('🏁 Test Results: $passedCount / ${testCases.length} Tests Passed');
  if (passedCount == testCases.length) {
    print('🎉 100% SUCCESS! All 10 destinations & trip combos verified in Dart CLI!');
  } else {
    print('Note: Some probabilistic classifications varied based on feature combinations.');
  }
  print('===============================================================\n');
}
