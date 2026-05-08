import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_strings.dart';
import 'core/storage/local_storage.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/notification/notification_service.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/schedule_repository.dart';
import 'data/repositories/bookkeeping_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/bloc/schedule/schedule_bloc.dart';
import 'presentation/bloc/bookkeeping/bookkeeping_bloc.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/auth/forgot_password_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/home/main_shell.dart';
import 'presentation/pages/schedule/schedule_list_page.dart';
import 'presentation/pages/schedule/schedule_detail_page.dart';
import 'presentation/pages/schedule/schedule_form_page.dart';
import 'presentation/pages/bookkeeping/record_list_page.dart';
import 'presentation/pages/bookkeeping/record_detail_page.dart';
import 'presentation/pages/bookkeeping/record_form_page.dart';
import 'presentation/pages/bookkeeping/statistics_page.dart';
import 'presentation/pages/profile/profile_page.dart';
import 'presentation/pages/profile/edit_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDependencies();
  runApp(const MyApp());
}

Future<void> _initDependencies() async {
  final getIt = GetIt.instance;

  final localStorage = LocalStorage();
  await localStorage.init();
  getIt.registerSingleton(localStorage);

  final secureStorage = const FlutterSecureStorage();
  getIt.registerSingleton(secureStorage);

  final authLocalDS = AuthLocalDataSource(secureStorage);
  getIt.registerSingleton(authLocalDS);

  final apiClient = ApiClient();
  getIt.registerSingleton(apiClient);

  final notificationService =
      NotificationService(FlutterLocalNotificationsPlugin());
  await notificationService.init();
  getIt.registerSingleton(notificationService);

  getIt.registerSingleton(UserRepository(apiClient));
  getIt.registerSingleton(ScheduleRepository(apiClient));
  getIt.registerSingleton(BookkeepingRepository(apiClient));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;

    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleListPage(),
            ),
            GoRoute(
              path: '/bookkeeping',
              builder: (context, state) => const RecordListPage(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
        GoRoute(
          path: '/schedule/create',
          builder: (context, state) => const ScheduleFormPage(),
        ),
        GoRoute(
          path: '/schedule/edit/:id',
          builder: (context, state) => ScheduleFormPage(
            scheduleId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/schedule/:id',
          builder: (context, state) => ScheduleDetailPage(
            scheduleId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/create',
          builder: (context, state) => const RecordFormPage(),
        ),
        GoRoute(
          path: '/bookkeeping/edit/:id',
          builder: (context, state) => RecordFormPage(
            recordId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/:id',
          builder: (context, state) => RecordDetailPage(
            recordId: int.parse(state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/statistics',
          builder: (context, state) => const StatisticsPage(),
        ),
        GoRoute(
          path: '/profile/edit',
          builder: (context, state) => const EditProfilePage(),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            getIt<UserRepository>(),
            getIt<AuthLocalDataSource>(),
          )..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (_) => ScheduleBloc(getIt<ScheduleRepository>()),
        ),
        BlocProvider(
          create: (_) => BookkeepingBloc(getIt<BookkeepingRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
