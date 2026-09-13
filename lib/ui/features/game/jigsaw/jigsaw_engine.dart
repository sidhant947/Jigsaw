import 'dart:math';

enum JigsawDifficulty { easy, medium, hard, expert }

class JigsawLevel {
  final int size;
  final String imagePath;
  final List<int> initialTiles;
  final JigsawDifficulty difficulty;

  JigsawLevel({
    required this.size,
    required this.imagePath,
    required this.initialTiles,
    this.difficulty = JigsawDifficulty.easy,
  });
}

class JigsawEngine {
  static const List<int> bossLevels = [25, 70, 135, 215, 305, 400, 499, 500];

  static bool isBossLevel(int level) =>
      bossLevels.contains(level) || (level > 500 && level % 100 == 0);

  static int sizeForLevel(int level) {
    if (level <= 25) return 3;
    if (level <= 70) return 4;
    if (level <= 135) return 5;
    if (level <= 215) return 6;
    if (level <= 305) return 7;
    if (level <= 400) return 8;
    if (level <= 499) return 9;
    return 10;
  }

  static JigsawDifficulty difficultyForLevel(int level) {
    if (isBossLevel(level)) {
      return JigsawDifficulty.expert;
    }

    if (level <= 25) {
      if (level <= 8) return JigsawDifficulty.easy;
      if (level <= 18) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else if (level <= 70) {
      final sub = level - 25;
      if (sub <= 12) return JigsawDifficulty.easy;
      if (sub <= 30) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else if (level <= 135) {
      final sub = level - 70;
      if (sub <= 15) return JigsawDifficulty.easy;
      if (sub <= 45) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else if (level <= 215) {
      final sub = level - 135;
      if (sub <= 20) return JigsawDifficulty.easy;
      if (sub <= 55) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else if (level <= 305) {
      final sub = level - 215;
      if (sub <= 20) return JigsawDifficulty.easy;
      if (sub <= 60) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else if (level <= 400) {
      final sub = level - 305;
      if (sub <= 20) return JigsawDifficulty.easy;
      if (sub <= 65) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else if (level <= 499) {
      final sub = level - 400;
      if (sub <= 20) return JigsawDifficulty.easy;
      if (sub <= 65) return JigsawDifficulty.medium;
      return JigsawDifficulty.hard;
    } else {
      final cycle = level % 10;
      if (cycle <= 2) return JigsawDifficulty.medium;
      if (cycle <= 7) return JigsawDifficulty.hard;
      return JigsawDifficulty.expert;
    }
  }

  static const List<String> allDefaultImages = [
    'assets/images/1.webp',
    'assets/images/2.webp',
    'assets/images/3.webp',
    'assets/images/4.webp',
    'assets/images/5.webp',
    'assets/images/6.webp',
    'assets/images/7.webp',
    'assets/images/8.webp',
    'assets/images/9.webp',
    'assets/images/10.webp',
    'assets/images/11.webp',
    'assets/images/12.webp',
    'assets/images/13.webp',
    'assets/images/14.webp',
    'assets/images/15.webp',
    'assets/images/16.webp',
    'assets/images/17.webp',
    'assets/images/18.webp',
    'assets/images/19.webp',
    'assets/images/20.webp',
  ];

  static Map<int, List<String>> get imagesByGridSize => {
    for (int size = 3; size <= 10; size++) size: allDefaultImages,
  };

  static List<String> imagesForSize(int size, [List<String>? availableImages]) {
    if (availableImages != null && availableImages.isNotEmpty) {
      return availableImages;
    }
    return allDefaultImages;
  }

  static String imageForLevel(int level, [List<String>? availableImages]) {
    final list = (availableImages != null && availableImages.isNotEmpty)
        ? availableImages
        : allDefaultImages;
    return list[(level - 1) % list.length];
  }

  JigsawLevel generateLevel({
    int? level,
    int? size,
    JigsawDifficulty? difficulty,
    bool isRandom = false,
    List<String>? availableImages,
    String? selectedImage,
  }) {
    final gridSize = size ?? (level != null ? sizeForLevel(level) : 4);
    final diff = difficulty ?? (level != null ? difficultyForLevel(level) : JigsawDifficulty.medium);
    final random = isRandom ? Random() : Random(level ?? 1);

    final list = (availableImages != null && availableImages.isNotEmpty)
        ? availableImages
        : allDefaultImages;
    final String imagePath;
    if (selectedImage != null && selectedImage.isNotEmpty) {
      imagePath = selectedImage;
    } else if (isRandom) {
      imagePath = list[random.nextInt(list.length)];
    } else {
      imagePath = list[((level ?? 1) - 1) % list.length];
    }

    final totalTiles = gridSize * gridSize;
    List<int> shuffled = List<int>.generate(totalTiles, (index) => index);

    int swapCount;
    switch (diff) {
      case JigsawDifficulty.easy:
        swapCount = max(6, totalTiles ~/ 2);
        break;
      case JigsawDifficulty.medium:
        swapCount = totalTiles;
        break;
      case JigsawDifficulty.hard:
        swapCount = totalTiles * 2;
        break;
      case JigsawDifficulty.expert:
        swapCount = totalTiles * 4;
        break;
    }

    for (int i = 0; i < swapCount; i++) {
      int idx1 = random.nextInt(totalTiles);
      int idx2 = random.nextInt(totalTiles);
      while (idx1 == idx2 && totalTiles > 1) {
        idx2 = random.nextInt(totalTiles);
      }
      final temp = shuffled[idx1];
      shuffled[idx1] = shuffled[idx2];
      shuffled[idx2] = temp;
    }

    bool allSolved = true;
    for (int i = 0; i < totalTiles; i++) {
      if (shuffled[i] != i) {
        allSolved = false;
        break;
      }
    }

    if (allSolved && totalTiles > 1) {
      final temp = shuffled[0];
      shuffled[0] = shuffled[1];
      shuffled[1] = temp;
    }

    return JigsawLevel(
      size: gridSize,
      imagePath: imagePath,
      initialTiles: shuffled,
      difficulty: diff,
    );
  }
}
