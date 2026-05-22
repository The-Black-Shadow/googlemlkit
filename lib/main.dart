import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/router.dart';
import 'features/text_recognition/presentation/bloc/text_recognition_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<TextRecognitionBloc>(),
      child: MaterialApp.router(
        title: 'Smart OCR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0B0C10),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7F00FF),
            secondary: Color(0xFFE100FF),
            surface: Color(0xFF1F2833),
          ),
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
