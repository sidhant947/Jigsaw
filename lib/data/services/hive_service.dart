import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/user_progress.dart';
import 'user_progress_adapter.dart';

class HiveService {
  static const String _progressBoxName = 'jigsaw_progress';
  static const String _progressKey = 'progress';

  static const String _settingsBoxName = 'jigsaw_settings';
  static const String _hintHelperKey = 'hint_helper';

  late Box<UserProgress> _progressBox;
  late Box<dynamic> _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProgressAdapter());
    }
    _progressBox = await Hive.openBox<UserProgress>(_progressBoxName);
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
  }

  Future<UserProgress> getProgress() async {
    try {
      return _progressBox.get(_progressKey) ?? const UserProgress();
    } catch (_) {
      return const UserProgress();
    }
  }

  Future<void> saveProgress(UserProgress progress) async {
    await _progressBox.put(_progressKey, progress);
  }

  Future<void> clearProgress() async {
    await _progressBox.delete(_progressKey);
  }

  bool getHintHelper() {
    return _settingsBox.get(_hintHelperKey, defaultValue: false) as bool;
  }

  Future<void> setHintHelper(bool enabled) async {
    await _settingsBox.put(_hintHelperKey, enabled);
  }

  static const String _onboardingKey = 'has_seen_onboarding';

  bool getHasSeenOnboarding() {
    return _settingsBox.get(_onboardingKey, defaultValue: false) as bool;
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    await _settingsBox.put(_onboardingKey, seen);
  }

  static const String _appSkinKey = 'app_skin';

  String getAppSkin() {
    return _settingsBox.get(_appSkinKey, defaultValue: 'pastel') as String;
  }

  Future<void> setAppSkin(String skin) async {
    await _settingsBox.put(_appSkinKey, skin);
  }

  static const String _unifiedImagesKey = 'unified_puzzle_images';

  List<String> getUnifiedImages(List<String> defaultImages) {
    final list = _settingsBox.get(_unifiedImagesKey);
    if (list != null && list is List) {
      final casted = List<String>.from(list)
          .where((img) => !img.startsWith('assets/') || defaultImages.contains(img))
          .toList();
      if (casted.isNotEmpty) return casted;
    }
    final merged = <String>[...defaultImages];
    for (int s = 3; s <= 10; s++) {
      final sList = _settingsBox.get('grid_images_$s');
      if (sList != null && sList is List) {
        for (final item in sList) {
          if (item is String &&
              (!item.startsWith('assets/') || defaultImages.contains(item)) &&
              !merged.contains(item)) {
            merged.add(item);
          }
        }
      }
    }
    return merged;
  }

  Future<void> saveUnifiedImages(List<String> images) async {
    await _settingsBox.put(_unifiedImagesKey, images);
  }

  List<String> getGridImages(int gridSize, List<String> defaultImages) {
    final list = _settingsBox.get('grid_images_$gridSize');
    if (list != null && list is List) {
      final casted = List<String>.from(list);
      if (casted.isNotEmpty) return casted;
    }
    return defaultImages;
  }

  Future<void> saveGridImages(int gridSize, List<String> images) async {
    await _settingsBox.put('grid_images_$gridSize', images);
  }
}
