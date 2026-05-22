import '../models/text_result_model.dart';

abstract class TextRecognitionLocalDataSource {
  Future<TextResultModel> processImage(String imagePath);
}
