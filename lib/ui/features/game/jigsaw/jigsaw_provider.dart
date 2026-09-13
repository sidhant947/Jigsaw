import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';
import 'jigsaw_engine.dart';

class JigsawState {
  final JigsawLevel level;
  final List<int> currentTiles;
  final int? selectedIndex;
  final bool isSolved;
  final int hintsRemaining;

  JigsawState({
    required this.level,
    required this.currentTiles,
    this.selectedIndex,
    this.isSolved = false,
    required this.hintsRemaining,
  });

  JigsawState copyWith({
    JigsawLevel? level,
    List<int>? currentTiles,
    int? selectedIndex,
    bool? isSolved,
    int? hintsRemaining,
    bool clearSelection = false,
  }) {
    return JigsawState(
      level: level ?? this.level,
      currentTiles: currentTiles ?? this.currentTiles,
      selectedIndex: clearSelection ? null : (selectedIndex ?? this.selectedIndex),
      isSolved: isSolved ?? this.isSolved,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
    );
  }

  int get wrongTilesCount {
    int count = 0;
    for (int i = 0; i < currentTiles.length; i++) {
      if (currentTiles[i] != i) {
        count++;
      }
    }
    return count;
  }
}

class JigsawViewModel extends Notifier<JigsawState> {
  final _engine = JigsawEngine();
  final List<JigsawState> _history = [];

  bool get canUndo => _history.isNotEmpty;

  static int maxHintsForSize(int size) {
    if (size <= 4) return 1;
    if (size <= 7) return 2;
    return 5;
  }

  static JigsawState _initialState() {
    final engine = JigsawEngine();
    final level = engine.generateLevel(level: 1, size: 3);
    return JigsawState(
      level: level,
      currentTiles: List.from(level.initialTiles),
      hintsRemaining: maxHintsForSize(level.size),
    );
  }

  @override
  JigsawState build() {
    return _initialState();
  }

  void initGame({
    int? levelNumber,
    int? gridSize,
    JigsawDifficulty? difficulty,
    bool isRandom = false,
    String? selectedImage,
  }) {
    _history.clear();
    final size = gridSize ??
        (isRandom && levelNumber != null
            ? JigsawEngine.sizeForLevel(levelNumber)
            : (levelNumber != null ? JigsawEngine.sizeForLevel(levelNumber) : 4));
    final allImages = ref.read(allGridImagesProvider);
    final level = _engine.generateLevel(
      level: isRandom ? null : (levelNumber ?? 1),
      size: size,
      difficulty: difficulty,
      isRandom: isRandom,
      availableImages: allImages,
      selectedImage: selectedImage,
    );
    state = JigsawState(
      level: level,
      currentTiles: List.from(level.initialTiles),
      hintsRemaining: maxHintsForSize(level.size),
    );
  }

  void newGame() {
    _history.clear();
    final allImages = ref.read(allGridImagesProvider);
    final level = _engine.generateLevel(
      size: state.level.size,
      difficulty: state.level.difficulty,
      isRandom: true,
      availableImages: allImages,
    );
    state = JigsawState(
      level: level,
      currentTiles: List.from(level.initialTiles),
      hintsRemaining: maxHintsForSize(level.size),
      isSolved: false,
    );
  }

  void selectTile(int index) {
    if (state.isSolved) return;

    if (state.selectedIndex == null) {
      state = state.copyWith(selectedIndex: index);
    } else if (state.selectedIndex == index) {
      state = state.copyWith(clearSelection: true);
    } else {
      swapTiles(state.selectedIndex!, index);
    }
  }

  void swapTiles(int from, int to) {
    if (state.isSolved || from == to) {
      state = state.copyWith(clearSelection: true);
      return;
    }

    _history.add(state.copyWith());

    final newTiles = List<int>.from(state.currentTiles);
    final temp = newTiles[from];
    newTiles[from] = newTiles[to];
    newTiles[to] = temp;

    final solved = _checkSolved(newTiles);
    state = state.copyWith(
      currentTiles: newTiles,
      clearSelection: true,
      isSolved: solved,
    );
  }

  void undo() {
    if (_history.isEmpty || state.isSolved) return;
    state = _history.removeLast();
  }

  void restartLevel() {
    _history.clear();
    state = JigsawState(
      level: state.level,
      currentTiles: List.from(state.level.initialTiles),
      hintsRemaining: maxHintsForSize(state.level.size),
      isSolved: false,
    );
  }

  void useHint() {
    if (state.isSolved) return;

    int targetSlot = -1;
    for (int i = 0; i < state.currentTiles.length; i++) {
      if (state.currentTiles[i] != i) {
        targetSlot = i;
        break;
      }
    }

    if (targetSlot == -1) return;

    int fromSlot = state.currentTiles.indexOf(targetSlot);
    if (fromSlot == -1) return;

    _history.add(state.copyWith());

    final newTiles = List<int>.from(state.currentTiles);
    final temp = newTiles[targetSlot];
    newTiles[targetSlot] = newTiles[fromSlot];
    newTiles[fromSlot] = temp;

    final solved = _checkSolved(newTiles);
    state = state.copyWith(
      currentTiles: newTiles,
      isSolved: solved,
      clearSelection: true,
    );
  }

  bool _checkSolved(List<int> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != i) return false;
    }
    return true;
  }
}

final jigsawViewModelProvider =
    NotifierProvider.autoDispose<JigsawViewModel, JigsawState>(
      JigsawViewModel.new,
    );
