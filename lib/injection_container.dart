import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'features/text_recognition/data/datasources/text_recognition_local_datasource.dart';
import 'features/text_recognition/data/datasources/text_recognition_local_datasource_impl.dart';
import 'features/text_recognition/data/repositories/text_recognition_repository_impl.dart';
import 'features/text_recognition/domain/repositories/text_recognition_repository.dart';
import 'features/text_recognition/domain/usecases/recognize_text_usecase.dart';
import 'features/text_recognition/presentation/bloc/text_recognition_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => TextRecognitionBloc(recognizeTextUseCase: sl()),
  );

  // UseCases
  sl.registerLazySingleton(
    () => RecognizeTextUseCase(repository: sl()),
  );

  // Repositories
  sl.registerLazySingleton<TextRecognitionRepository>(
    () => TextRecognitionRepositoryImpl(localDataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<TextRecognitionLocalDataSource>(
    () => const TextRecognitionLocalDataSourceImpl(),
  );

  // Core / Network
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => sl<DioClient>().dio);
}
