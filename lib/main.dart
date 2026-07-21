import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_strings.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/skin_controller.dart';
import 'core/notification/notification_service.dart';
import 'core/widgets/crt_overlay.dart';
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
import 'presentation/pages/profile/skin_settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDependencies();
  runApp(const MyApp());
}

Future<void> _initDependencies() async {
  final getIt = GetIt.instance;

  const secureStorage = FlutterSecureStorage();
  getIt.registerSingleton(secureStorage);

  await SkinController.instance.init(secureStorage);
  getIt.registerSingleton(SkinController.instance);

  final authLocalDS = AuthLocalDataSource(secureStorage);
  getIt.registerSingleton(authLocalDS);

  final apiClient = ApiClient();
  getIt.registerSingleton(apiClient);

  final notificationService = NotificationService();
  await notificationService.init();
  getIt.registerSingleton(notificationService);

  getIt.registerSingleton(UserRepository(apiClient));
  getIt.registerSingleton(ScheduleRepository(apiClient));
  getIt.registerSingleton(BookkeepingRepository(apiClient));
}

Page<void> _noTransitionPage(GoRouterState state, Widget child) {
  return NoTransitionPage<void>(
    key: state.pageKey,
    child: child,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final status = _authBloc.state.status;
    final location = state.uri.toString();
    final isAuthPage =
        location == '/splash' ||
        location == '/login' ||
        location == '/register' ||
        location == '/forgot-password';

    if (status == AuthStatus.initial || status == AuthStatus.loading) {
      return location == '/splash' ? null : '/splash';
    }

    if (status == AuthStatus.unauthenticated) {
      return isAuthPage ? null : '/login';
    }

    if (status == AuthStatus.authenticated && isAuthPage) {
      return '/home';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    final getIt = GetIt.instance;

    _authBloc = AuthBloc(
      getIt<UserRepository>(),
      getIt<AuthLocalDataSource>(),
    )..add(CheckAuthStatus());

    _router = GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(_authBloc.stream),
      redirect: _redirect,
      routes: [
        GoRoute(
          path: '/splash',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const SplashPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const LoginPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const RegisterPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/forgot-password',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const ForgotPasswordPage(),
            ),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) => BlocProvider.value(
            value: _authBloc,
            child: MainShell(
              currentIndex: mainNavIndexForLocation(state.uri.toString()),
              child: child,
            ),
          ),
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _noTransitionPage(
                state,
                const HomePage(),
              ),
            ),
            GoRoute(
              path: '/schedule',
              pageBuilder: (context, state) => _noTransitionPage(
                state,
                const ScheduleListPage(),
              ),
            ),
            GoRoute(
              path: '/bookkeeping',
              pageBuilder: (context, state) => _noTransitionPage(
                state,
                const RecordListPage(),
              ),
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => _noTransitionPage(
                state,
                const ProfilePage(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/schedule/create',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const ScheduleFormPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/schedule/edit/:id',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: ScheduleFormPage(
                scheduleId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/schedule/:id',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: ScheduleDetailPage(
                scheduleId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/create',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const RecordFormPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/edit/:id',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: RecordFormPage(
                recordId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/:id',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: RecordDetailPage(
                recordId: int.parse(state.pathParameters['id']!),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/bookkeeping/statistics',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const StatisticsPage(),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/edit',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            BlocProvider.value(
              value: _authBloc,
              child: const EditProfilePage(),
            ),
          ),
        ),
        GoRoute(
          path: '/profile/skin',
          pageBuilder: (context, state) => _noTransitionPage(
            state,
            const SkinSettingsPage(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => ScheduleBloc(getIt<ScheduleRepository>())),
        BlocProvider(create: (_) => BookkeepingBloc(getIt<BookkeepingRepository>())),
      ],
      child: AnimatedBuilder(
        animation: SkinController.instance,
        builder: (context, _) {
          return MaterialApp.router(
            title: AppStrings.appName,
            theme: AppTheme.lightTheme,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
            ],
            builder: (context, child) => CrtOverlay(child: child!),
          );
        },
      ),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
