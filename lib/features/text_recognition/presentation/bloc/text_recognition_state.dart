import 'package:equatable/equatable.dart';
import '../../domain/entities/text_result.dart';

sealed class TextRecognitionState extends Equatable {
  const TextRecognitionState();

  @override
  List<Object?> get props => [];
}

class TextRecognitionInitial extends TextRecognitionState {
  const TextRecognitionInitial();
}

class TextRecognitionLoading extends TextRecognitionState {
  const TextRecognitionLoading();
}

class TextRecognitionSuccess extends TextRecognitionState {
  final String imagePath;
  final TextResult result;

  const TextRecognitionSuccess({
    required this.imagePath,
    required this.result,
  });

  @override
  List<Object?> get props => [imagePath, result];
}

class TextRecognitionError extends TextRecognitionState {
  final String errorMessage;

  const TextRecognitionError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
