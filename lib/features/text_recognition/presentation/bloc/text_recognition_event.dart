import 'package:equatable/equatable.dart';

sealed class TextRecognitionEvent extends Equatable {
  const TextRecognitionEvent();

  @override
  List<Object?> get props => [];
}

class TextRecognitionImageSelected extends TextRecognitionEvent {
  final String imagePath;

  const TextRecognitionImageSelected({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class TextRecognitionClearRequested extends TextRecognitionEvent {
  const TextRecognitionClearRequested();
}
