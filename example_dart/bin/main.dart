import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:onnxruntime/onnxruntime.dart';

void main(List<String> arguments) async {
  print('==============================================');
  print('  HeySanaModel - Tourism Dart CLI Tester');
  print('==============================================\n');

  // 1. GitHub Raw URL & Local File Check
  const githubRawUrl =
      'https://raw.githubusercontent.com/<your-username>/heysanamodel/main/artifacts/model.onnx';

  final localModelFile = File('../artifacts/model.onnx');
  File targetModelFile;

  if (await localModelFile.exists()) {
    print('📁 Found local ONNX model file at: ${localModelFile.path}');
    targetModelFile = localModelFile;
  } else {
    print('🌐 Downloading ONNX model from GitHub Raw URL...');
    print('   URL: $githubRawUrl');
    
    try {
      final response = await http.get(Uri.parse(githubRawUrl));
      if (response.statusCode == 200) {
        targetModelFile = File('downloaded_model.onnx');
        await targetModelFile.writeAsBytes(response.bodyBytes);
        print('✅ Downloaded ONNX model successfully!');
      } else {
        print('❌ Could not fetch model over HTTP (Status ${response.statusCode}).');
        print('   Please make sure to push artifacts/model.onnx to GitHub first.');
        return;
      }
    } catch (e) {
      print('❌ Error downloading model: $e');
      return;
    }
  }

  // 2. Initialize ONNX Runtime Environment
  print('\n⚡ Initializing ONNX Runtime in Dart CLI...');
  OrtEnv.instance.init();
  final sessionOptions = OrtSessionOptions();
  final session = OrtSession.fromFile(targetModelFile, sessionOptions);

  print('✅ ONNX Session loaded successfully!');

  // 3. Define Sample Input Features for Prediction
  print('\n🔍 Testing Tourist Profile Prediction:');
  print('   - Age: 30');
  print('   - Duration (Days): 7');
  print('   - Traveler Type: Family');
  print('   - Preferred Activity: Cultural');
  print('   - Budget (USD): $1500');

  // Prepare input feature tensor: [Age, DurationDays, TravelerType_OneHot(4), PreferredActivity_OneHot(4), BudgetUSD]
  final inputData = Float32List.fromList([
    30.0, // Age
    7.0,  // DurationDays
    0.0, 1.0, 0.0, 0.0, // TravelerType: Family
    0.0, 0.0, 1.0, 0.0, // PreferredActivity: Cultural
    1500.0 // BudgetUSD
  ]);
  final inputShape = [1, 11];

  final inputTensor = OrtValueTensor.createTensorWithDataList(inputData, inputShape);
  final runOptions = OrtRunOptions();
  final inputs = {'Features': inputTensor};

  // 4. Run Model Prediction
  print('\n🚀 Running ONNX Inference...');
  final outputs = session.run(runOptions, inputs);

  print('\n🎉 Inference completed!');
  print('   Model Output Elements: ${outputs.length}');

  // Release memory resources
  inputTensor.release();
  runOptions.release();
  sessionOptions.release();
  session.release();

  print('\n==============================================');
  print('  Dart CLI Test Completed Successfully!');
  print('==============================================');
}
