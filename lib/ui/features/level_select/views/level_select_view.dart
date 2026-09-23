import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers.dart';
import 'package:jigsaw/ui/core/widgets/tangible_widgets.dart';
import '../../game/jigsaw/jigsaw_screen.dart';

class LevelSelectView extends ConsumerStatefulWidget {
  const LevelSelectView({super.key});

  @override
  ConsumerState<LevelSelectView> createState() => _LevelSelectViewState();
}

class _LevelSelectViewState extends ConsumerState<LevelSelectView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeViewModelProvider.notifier).loadProgress());
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSkinProvider);
    final state = ref.watch(homeViewModelProvider);
    final highestCompleted = state.progress?.highestLevelCompleted ?? 0;
    final currentLevel = state.progress?.currentLevel ?? 1;
    final int totalLevelsToShow = math.max(currentLevel, highestCompleted) + 10;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TangibleIconButton(
              icon: Icons.arrow_back_rounded,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'Levels',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: PastelPalette.textDark,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(18),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.88,
        ),
        itemCount: totalLevelsToShow,
        itemBuilder: (context, index) {
          final levelNumber = index + 1;
          final isCompleted = levelNumber <= highestCompleted;
          final isCurrent = levelNumber == currentLevel;
          final isLocked = levelNumber > currentLevel;

          final Color tileColor;
          final Color tileBevel;
          final Color textColor;

          if (isCompleted) {
            tileColor = PastelPalette.mint;
            tileBevel = PastelPalette.mintBevel;
            textColor = PastelPalette.mintText;
          } else if (isCurrent) {
            tileColor = PastelPalette.butter;
            tileBevel = PastelPalette.butterBevel;
            textColor = PastelPalette.butterText;
          } else {
            tileColor = PastelPalette.locked;
            tileBevel = PastelPalette.lockedBevel;
            textColor = PastelPalette.lockedText;
          }

          return TangibleButton(
            height: double.infinity,
            color: tileColor,
            bevelColor: tileBevel,
            elevation: isLocked ? 2 : 3,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            onPressed: isLocked
                ? null
                : () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JigsawScreen(levelNumber: levelNumber),
                      ),
                    );
                    ref.read(homeViewModelProvider.notifier).loadProgress();
                  },
            child: isLocked
                ? Icon(
                    Icons.lock_rounded,
                    size: 22,
                    color: PastelPalette.lockedText,
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$levelNumber',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        if (isCompleted) ...[
                          const SizedBox(height: 2),
                          Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: textColor,
                          ),
                        ] else if (isCurrent) ...[
                          const SizedBox(height: 2),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: textColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
