import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/text_result.dart';
import '../../domain/repositories/text_recognition_repository.dart';
import '../datasources/text_recognition_local_datasource.dart';

class TextRecognitionRepositoryImpl implements TextRecognitionRepository {
  final TextRecognitionLocalDataSource localDataSource;

  const TextRecognitionRepositoryImpl({required this.localDataSource});

  @override
  Future<(Failure?, TextResult?)> recognizeText(String imagePath) async {
    try {
      final result = await localDataSource.processImage(imagePath);
      return (null, result);
    } on TextRecognitionException catch (e) {
      return (TextRecognitionFailure(message: e.message), null);
    } catch (e) {
      return (TextRecognitionFailure(message: e.toString()), null);
    }
  }
}
