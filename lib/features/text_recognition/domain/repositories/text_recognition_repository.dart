import '../../../../core/errors/failures.dart';
import '../entities/text_result.dart';

abstract class TextRecognitionRepository {
  Future<(Failure?, TextResult?)> recognizeText(String imagePath);
}
