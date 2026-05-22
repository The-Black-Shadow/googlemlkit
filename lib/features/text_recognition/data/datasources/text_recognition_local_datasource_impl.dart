import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/text_result_model.dart';
import 'text_recognition_local_datasource.dart';

class TextRecognitionLocalDataSourceImpl
    implements TextRecognitionLocalDataSource {
  const TextRecognitionLocalDataSourceImpl();

  @override
  Future<TextResultModel> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      final List<String> lines = <String>[];
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          lines.add(line.text);
        }
      }
      return TextResultModel(recognizedText: recognizedText.text, lines: lines);
    } catch (e) {
      throw TextRecognitionException(message: e.toString());
    } finally {
      await textRecognizer.close();
    }
  }
}
