import 'package:go_router/go_router.dart';

import '../../features/welcome/presentation/pages/welcome_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);