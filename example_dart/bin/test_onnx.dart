import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  print('========================================================');
  print('     HeySanaModel - ONNX Model Verification & Test     ');
  print('========================================================\n');

  // Multi-Feature Arguments: <Age> <Days> <Type> <Activity> <Budget> [Season] [Fitness] [Stay]
  final predictArgs = args.isNotEmpty ? args : <String>[];

  // Find project root
  final projectDir = Directory.current.path.endsWith('example_dart') ? '..' : '.';
  final csprojPath = '$projectDir/src/heysanamodel.csproj';
  final onnxModelPath = '$projectDir/artifacts/model.onnx';

  final onnxFile = File(onnxModelPath);
  if (!onnxFile.existsSync()) {
    print('❌ Error: ONNX model not found at: $onnxModelPath');
    return;
  }

  final fileSizeKB = (onnxFile.lengthSync() / 1024).toStringAsFixed(1);
  print('📁 Found ONNX Model: ${onnxFile.path} ($fileSizeKB KB)');

  print('⚡ Invoking ONNX Runtime Engine (via Microsoft.ML.OnnxRuntime)...\n');

  final process = await Process.run(
    'dotnet',
    ['run', '--project', csprojPath, '--configuration', 'Release', '--', '--onnx', ...predictArgs],
    workingDirectory: projectDir,
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );

  if (process.exitCode != 0) {
    print('❌ ONNX test failed:');
    print(process.stderr);
    return;
  }

  print(process.stdout);
}

