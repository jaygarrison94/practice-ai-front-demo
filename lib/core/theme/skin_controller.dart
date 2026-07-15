import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_skin.dart';

class SkinController extends ChangeNotifier {
  SkinController._();

  static final SkinController instance = SkinController._();

  static const _skinKey = 'selected_skin_id';

  FlutterSecureStorage? _storage;
  AppSkin _skin = AppSkins.eva;

  AppSkin get skin => _skin;

  Future<void> init(FlutterSecureStorage storage) async {
    _storage = storage;
    final savedId = await storage.read(key: _skinKey);
    _skin = AppSkins.byId(savedId);
  }

  Future<void> setSkin(AppSkin skin) async {
    if (_skin.id == skin.id) return;
    _skin = skin;
    await _storage?.write(key: _skinKey, value: skin.id);
    notifyListeners();
  }
}
