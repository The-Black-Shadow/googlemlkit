import '../../../../core/errors/failures.dart';
import '../entities/text_result.dart';
import '../repositories/text_recognition_repository.dart';

class RecognizeTextUseCase {
  final TextRecognitionRepository repository;

  const RecognizeTextUseCase({required this.repository});

  Future<(Failure?, TextResult?)> call(String imagePath) {
    return repository.recognizeText(imagePath);
  }
}
