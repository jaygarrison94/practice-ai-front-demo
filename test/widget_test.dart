import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:practice_ai_front_demo/core/network/api_client.dart';
import 'package:practice_ai_front_demo/core/theme/skin_controller.dart';
import 'package:practice_ai_front_demo/data/datasources/auth_local_datasource.dart';
import 'package:practice_ai_front_demo/data/repositories/bookkeeping_repository.dart';
import 'package:practice_ai_front_demo/data/repositories/schedule_repository.dart';
import 'package:practice_ai_front_demo/data/repositories/user_repository.dart';
import 'package:practice_ai_front_demo/main.dart';

void main() {
  setUp(() async {
    final getIt = GetIt.instance;
    await getIt.reset();
    FlutterSecureStorage.setMockInitialValues({});

    const secureStorage = FlutterSecureStorage();
    final authLocalDataSource = AuthLocalDataSource(secureStorage);
    getIt.registerSingleton<FlutterSecureStorage>(secureStorage);
    await SkinController.instance.init(secureStorage);
    getIt.registerSingleton<SkinController>(SkinController.instance);
    getIt.registerSingleton<AuthLocalDataSource>(authLocalDataSource);

    final apiClient = ApiClient();
    getIt.registerSingleton<ApiClient>(apiClient);
    getIt.registerSingleton<UserRepository>(UserRepository(apiClient));
    getIt.registerSingleton<ScheduleRepository>(ScheduleRepository(apiClient));
    getIt.registerSingleton<BookkeepingRepository>(
      BookkeepingRepository(apiClient),
    );
  });

  testWidgets('App smoke test - should display app root', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    expect(find.byType(MyApp), findsOneWidget);
  });
}
