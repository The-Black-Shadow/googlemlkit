import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:googlemlkit/core/errors/failures.dart';
import 'package:googlemlkit/features/text_recognition/domain/entities/text_result.dart';
import 'package:googlemlkit/features/text_recognition/domain/usecases/recognize_text_usecase.dart';
import 'package:googlemlkit/features/text_recognition/presentation/bloc/text_recognition_bloc.dart';
import 'package:googlemlkit/features/text_recognition/presentation/bloc/text_recognition_event.dart';
import 'package:googlemlkit/features/text_recognition/presentation/bloc/text_recognition_state.dart';

class MockRecognizeTextUseCase extends Mock implements RecognizeTextUseCase {}

void main() {
  late MockRecognizeTextUseCase mockRecognizeTextUseCase;
  late TextRecognitionBloc bloc;

  setUp(() {
    mockRecognizeTextUseCase = MockRecognizeTextUseCase();
    bloc = TextRecognitionBloc(recognizeTextUseCase: mockRecognizeTextUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tImagePath = 'path/to/image.png';
  const tTextResult = TextResult(
    recognizedText: 'Hello World',
    lines: ['Hello', 'World'],
  );
  const tFailure = TextRecognitionFailure(message: 'Error recognizing text');

  test('initial state should be TextRecognitionInitial', () {
    expect(bloc.state, const TextRecognitionInitial());
  });

  blocTest<TextRecognitionBloc, TextRecognitionState>(
    'should emit [TextRecognitionLoading, TextRecognitionSuccess] when image processing is successful',
    build: () {
      when(() => mockRecognizeTextUseCase(any()))
          .thenAnswer((_) async => (null, tTextResult));
      return bloc;
    },
    act: (bloc) => bloc.add(
        const TextRecognitionImageSelected(imagePath: tImagePath)),
    expect: () => [
      const TextRecognitionLoading(),
      const TextRecognitionSuccess(imagePath: tImagePath, result: tTextResult),
    ],
    verify: (_) {
      verify(() => mockRecognizeTextUseCase(tImagePath)).called(1);
    },
  );

  blocTest<TextRecognitionBloc, TextRecognitionState>(
    'should emit [TextRecognitionLoading, TextRecognitionError] when image processing fails',
    build: () {
      when(() => mockRecognizeTextUseCase(any()))
          .thenAnswer((_) async => (tFailure, null));
      return bloc;
    },
    act: (bloc) => bloc.add(
        const TextRecognitionImageSelected(imagePath: tImagePath)),
    expect: () => [
      const TextRecognitionLoading(),
      const TextRecognitionError(errorMessage: 'Error recognizing text'),
    ],
  );

  blocTest<TextRecognitionBloc, TextRecognitionState>(
    'should emit [TextRecognitionInitial] when clear request event is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const TextRecognitionClearRequested()),
    expect: () => [
      const TextRecognitionInitial(),
    ],
  );
}
