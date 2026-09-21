import 'dart:io';
import 'dart:typed_data';

void main() async {
  print('========================================================');
  print('  HeySanaModel - Dart Raw URL Download & Verification  ');
  print('========================================================\n');

  const rawUrl =
      'https://raw.githubusercontent.com/Santa8232/heysanamodel/main/artifacts/model.onnx';

  print('🌐 Target GitHub Raw URL:');
  print('   $rawUrl\n');

  final client = HttpClient();
  final stopwatch = Stopwatch()..start();

  try {
    print('⏳ Sending HTTP GET request...');
    final uri = Uri.parse(rawUrl);
    final request = await client.getUrl(uri);
    final response = await request.close();

    print('📡 Response received:');
    print('   - Status Code: ${response.statusCode} ${response.reasonPhrase}');
    print('   - Content-Type: ${response.headers.value(HttpHeaders.contentTypeHeader)}');
    print('   - Content-Length: ${response.headers.value(HttpHeaders.contentLengthHeader)} bytes');

    if (response.statusCode != 200) {
      print('\n❌ Download failed with HTTP Status ${response.statusCode}');
      return;
    }

    // Read response bytes
    final bytesBuilder = BytesBuilder();
    await for (final chunk in response) {
      bytesBuilder.add(chunk);
    }
    stopwatch.stop();

    final downloadedBytes = bytesBuilder.toBytes();
    print('\n📥 Download completed in ${stopwatch.elapsedMilliseconds} ms');
    print('   - Total Bytes: ${downloadedBytes.length} bytes');

    // Save to local test file
    final outputFile = File('downloaded_model.onnx');
    await outputFile.writeAsBytes(downloadedBytes);
    print('💾 Saved downloaded model to: ${outputFile.path}');

    // Verify against local repository model if exists
    final localRepoFiles = [
      File('artifacts/model.onnx'),
      File('../artifacts/model.onnx'),
    ];

    File? existingModel;
    for (final f in localRepoFiles) {
      if (await f.exists()) {
        existingModel = f;
        break;
      }
    }

    if (existingModel != null) {
      final existingBytes = await existingModel.readAsBytes();
      final matches = _compareBytes(downloadedBytes, existingBytes);
      print('\n🔍 Comparison with local model (${existingModel.path}):');
      print('   - Local File Size:       ${existingBytes.length} bytes');
      print('   - Downloaded File Size:  ${downloadedBytes.length} bytes');
      print('   - Exact Byte Match:      ${matches ? "✅ 100% IDENTICAL" : "❌ MISMATCH"}');
    }

    print('\n========================================================');
    print('  🎉 Dart Test PASSED: Raw GitHub URL is fully active!');
    print('========================================================');
  } catch (e) {
    print('\n❌ Error downloading model: $e');
  } finally {
    client.close();
  }
}

bool _compareBytes(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
