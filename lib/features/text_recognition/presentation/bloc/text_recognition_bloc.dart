import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/recognize_text_usecase.dart';
import 'text_recognition_event.dart';
import 'text_recognition_state.dart';

class TextRecognitionBloc extends Bloc<TextRecognitionEvent, TextRecognitionState> {
  final RecognizeTextUseCase recognizeTextUseCase;

  TextRecognitionBloc({required this.recognizeTextUseCase})
      : super(const TextRecognitionInitial()) {
    on<TextRecognitionImageSelected>(_onImageSelected);
    on<TextRecognitionClearRequested>(_onClearRequested);
  }

  Future<void> _onImageSelected(
    TextRecognitionImageSelected event,
    Emitter<TextRecognitionState> emit,
  ) async {
    emit(const TextRecognitionLoading());
    final (failure, result) = await recognizeTextUseCase(event.imagePath);
    if (failure != null) {
      emit(TextRecognitionError(errorMessage: failure.message));
    } else if (result != null) {
      emit(TextRecognitionSuccess(imagePath: event.imagePath, result: result));
    } else {
      emit(const TextRecognitionError(errorMessage: 'Unknown error occurred.'));
    }
  }

  void _onClearRequested(
    TextRecognitionClearRequested event,
    Emitter<TextRecognitionState> emit,
  ) {
    emit(const TextRecognitionInitial());
  }
}
