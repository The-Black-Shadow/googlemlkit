import 'package:go_router/go_router.dart';
import '../../features/text_recognition/presentation/pages/text_recognition_page.dart';

class AppRoutes {
  static const home = '/';
}

final goRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const TextRecognitionPage(),
    ),
  ],
);
