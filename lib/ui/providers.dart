import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/progress_repository.dart';
import '../data/services/hive_service.dart';
import 'features/game/jigsaw/jigsaw_engine.dart';
import 'features/home/view_models/home_view_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('Must be overridden in main');
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return ProgressRepository(hiveService: hiveService);
});

final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeViewModelState>(HomeViewModel.new);

final hintHelperProvider =
    NotifierProvider<HintHelperNotifier, bool>(HintHelperNotifier.new);

class HintHelperNotifier extends Notifier<bool> {
  @override
  bool build() {
    final hiveService = ref.watch(hiveServiceProvider);
    return hiveService.getHintHelper();
  }

  Future<void> toggle(bool value) async {
    state = value;
    final hiveService = ref.read(hiveServiceProvider);
    await hiveService.setHintHelper(value);
  }
}

class PuzzleImagesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final hiveService = ref.watch(hiveServiceProvider);
    return hiveService.getUnifiedImages(JigsawEngine.allDefaultImages);
  }

  Future<void> removeImage(String imagePath) async {
    final current = List<String>.from(state);
    if (current.length <= 10) return;
    current.remove(imagePath);
    state = current;
    final hiveService = ref.read(hiveServiceProvider);
    await hiveService.saveUnifiedImages(current);
    if (!imagePath.startsWith('assets/')) {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
  }

  Future<void> addImage(String imagePath) async {
    final current = List<String>.from(state);
    if (!current.contains(imagePath)) {
      current.add(imagePath);
      state = current;
      final hiveService = ref.read(hiveServiceProvider);
      await hiveService.saveUnifiedImages(current);
    }
  }

  Future<void> addImages(List<String> imagePaths) async {
    final current = List<String>.from(state);
    bool changed = false;
    for (final path in imagePaths) {
      if (!current.contains(path)) {
        current.add(path);
        changed = true;
      }
    }
    if (changed) {
      state = current;
      final hiveService = ref.read(hiveServiceProvider);
      await hiveService.saveUnifiedImages(current);
    }
  }
}

final puzzleImagesProvider =
    NotifierProvider<PuzzleImagesNotifier, List<String>>(PuzzleImagesNotifier.new);

final allGridImagesProvider = Provider<List<String>>((ref) {
  return ref.watch(puzzleImagesProvider);
});
