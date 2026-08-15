import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/close_day/presentation/screens/close_day_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/reconciliation/presentation/screens/reconcile_screen.dart';
import '../../features/setup/presentation/screens/setup_wizard_screen.dart';
import '../../features/sms/presentation/screens/import_sms_screen.dart';
import '../../features/sms/presentation/screens/sms_permission_screen.dart';
import '../../features/transaction/presentation/screens/transaction_review_screen.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/settings/presentation/providers/app_config_repository_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final config = await ref.read(appConfigRepositoryProvider.future);

      final hasCompletedSetup = await config.hasCompletedSetup();

      final location = state.matchedLocation;

      if (hasCompletedSetup) {
        if (location == '/' || location == '/setup') return '/dashboard';
        return null;
      }

      if (location == '/dashboard') return '/';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const SetupWizardScreen(),
      ),
      GoRoute(
        path: '/close-day',
        builder: (context, state) => const CloseDayScreen(),
      ),
      GoRoute(
        path: '/sms/import',
        builder: (context, state) => const ImportSmsScreen(),
      ),
      GoRoute(
        path: '/sms/permission',
        builder: (context, state) => const SmsPermissionScreen(),
      ),
      GoRoute(
        path: '/transaction/review',
        builder: (context, state) => const TransactionReviewScreen(),
      ),
      GoRoute(
        path: '/reconcile',
        builder: (context, state) => const ReconcileScreen(),
      ),
    ],
  );
});
