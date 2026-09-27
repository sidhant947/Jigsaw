import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers.dart';
import 'package:jigsaw/ui/core/widgets/tangible_widgets.dart';
import 'jigsaw_engine.dart';
import 'jigsaw_provider.dart';

class JigsawScreen extends ConsumerStatefulWidget {
  const JigsawScreen({
    super.key,
    required this.levelNumber,
    this.gridSize,
    this.difficulty,
    this.isRandom = false,
    this.selectedImage,
  });

  final int levelNumber;
  final int? gridSize;
  final JigsawDifficulty? difficulty;
  final bool isRandom;
  final String? selectedImage;

  @override
  ConsumerState<JigsawScreen> createState() => _JigsawScreenState();
}

class _JigsawScreenState extends ConsumerState<JigsawScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(jigsawViewModelProvider.notifier).initGame(
        levelNumber: widget.levelNumber,
        gridSize: widget.gridSize,
        difficulty: widget.difficulty,
        isRandom: widget.isRandom,
        selectedImage: widget.selectedImage,
      );
    });
  }

  bool _isDialogOpen = false;

  Future<bool?> _showLeaveConfirmation(BuildContext context) async {
    if (_isDialogOpen) return false;
    _isDialogOpen = true;
    try {
      return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: TangibleCard(
            color: PastelPalette.surface,
            bevelColor: PastelPalette.neutralBevel,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    size: 48,
                    color: PastelPalette.peach,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Leave Game?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to leave? Your progress in this puzzle will be lost.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: PastelPalette.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TangibleButton(
                        height: 46,
                        color: PastelPalette.locked,
                        bevelColor: PastelPalette.lockedBevel,
                        elevation: 3,
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: PastelPalette.textDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TangibleButton(
                        height: 46,
                        color: PastelPalette.peach,
                        bevelColor: PastelPalette.peachBevel,
                        elevation: 3,
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Leave',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: PastelPalette.peachText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } finally {
      _isDialogOpen = false;
    }
  }

  Widget _buildTilePiece({
    required int pieceIndex,
    required int n,
    required double boardSize,
    required double tileSize,
    required double spacing,
    required String imagePath,
    bool isSelected = false,
  }) {
    final correctCol = pieceIndex % n;
    final correctRow = pieceIndex ~/ n;

    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: PastelPalette.mintBevel.withValues(alpha: 0.6),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
      ),
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: -correctCol * (tileSize + spacing),
              top: -correctRow * (tileSize + spacing),
              width: boardSize,
              height: boardSize,
              child: imagePath.startsWith('assets/')
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: PastelPalette.locked,
                        child: Center(
                          child: Icon(Icons.broken_image, color: PastelPalette.lockedText),
                        ),
                      ),
                    )
                  : Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: PastelPalette.locked,
                        child: Center(
                          child: Icon(Icons.broken_image, color: PastelPalette.lockedText),
                        ),
                      ),
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? PastelPalette.mint : Colors.white.withValues(alpha: 0.35),
                  width: isSelected ? 2.5 : 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSkinProvider);
    final state = ref.watch(jigsawViewModelProvider);
    final notifier = ref.read(jigsawViewModelProvider.notifier);

    ref.listen<JigsawState>(jigsawViewModelProvider, (previous, next) {
      if (next.isSolved && !(previous?.isSolved ?? false)) {
        HapticFeedback.heavyImpact();
        if (!widget.isRandom) {
          ref.read(homeViewModelProvider.notifier).completeLevel(widget.levelNumber);
        }
      }
    });

    final isBoss = JigsawEngine.isBossLevel(widget.levelNumber);

    return PopScope(
      canPop: state.isSolved,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _showLeaveConfirmation(context);
        if (shouldLeave == true && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: TangibleIconButton(
                icon: Icons.arrow_back_rounded,
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
          ),
        title: TangibleBadge(
          color: PastelPalette.surface,
          bevelColor: PastelPalette.neutralBevel,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBoss) ...[
                Icon(Icons.star_rounded, color: PastelPalette.peachText, size: 18),
                const SizedBox(width: 4),
              ],
              Text(
                widget.isRandom
                    ? 'Random'
                    : (isBoss ? 'Boss ${widget.levelNumber}' : 'Level ${widget.levelNumber}'),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: PastelPalette.textDark,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: TangibleIconButton(
                icon: Icons.refresh_rounded,
                color: PastelPalette.peach,
                bevelColor: PastelPalette.peachBevel,
                iconColor: PastelPalette.peachText,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  notifier.restartLevel();
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boardSize = math.min(constraints.maxWidth, constraints.maxHeight);
                      final n = state.level.size;
                      const spacing = 1.0;
                      final tileSize = (boardSize - ((n - 1) * spacing)) / n;

                      return SizedBox(
                        width: boardSize,
                        height: boardSize,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: n,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                          ),
                          itemCount: n * n,
                          itemBuilder: (context, index) {
                            final pieceIndex = state.currentTiles[index];
                            final isSelected = state.selectedIndex == index;

                            final tileWidget = _buildTilePiece(
                              pieceIndex: pieceIndex,
                              n: n,
                              boardSize: boardSize,
                              tileSize: tileSize,
                              spacing: spacing,
                              imagePath: state.level.imagePath,
                              isSelected: isSelected,
                            );

                            final clickableTile = GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                notifier.selectTile(index);
                              },
                              child: isSelected
                                  ? Transform.translate(
                                      offset: const Offset(0, -3),
                                      child: tileWidget,
                                    )
                                  : tileWidget,
                            );

                            if (state.isSolved) {
                              return clickableTile;
                            }

                            return DragTarget<int>(
                              onWillAcceptWithDetails: (details) => details.data != index,
                              onAcceptWithDetails: (details) {
                                HapticFeedback.mediumImpact();
                                notifier.swapTiles(details.data, index);
                              },
                              builder: (context, candidateData, rejectedData) {
                                final isHovered = candidateData.isNotEmpty;
                                return Draggable<int>(
                                  data: index,
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Transform.scale(
                                      scale: 1.06,
                                      child: _buildTilePiece(
                                        pieceIndex: pieceIndex,
                                        n: n,
                                        boardSize: boardSize,
                                        tileSize: tileSize,
                                        spacing: spacing,
                                        imagePath: state.level.imagePath,
                                        isSelected: true,
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.25,
                                    child: tileWidget,
                                  ),
                                  child: isHovered
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: PastelPalette.lavenderBevel,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: clickableTile,
                                        )
                                      : clickableTile,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: state.isSolved
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.celebration_rounded, color: PastelPalette.peach, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              widget.isRandom ? 'Puzzle Solved!' : 'Level Complete!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: PastelPalette.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TangibleButton(
                          height: 48,
                          color: PastelPalette.mint,
                          bevelColor: PastelPalette.mintBevel,
                          onPressed: () {
                            if (widget.isRandom) {
                              ref.read(jigsawViewModelProvider.notifier).newGame();
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JigsawScreen(
                                    levelNumber: widget.levelNumber + 1,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            widget.isRandom ? 'New Puzzle' : 'Next Level',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: PastelPalette.mintText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TangibleButton(
                          height: 48,
                          color: PastelPalette.lavender,
                          bevelColor: PastelPalette.lavenderBevel,
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: PastelPalette.lavenderText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TangibleButton(
                          height: 48,
                          color: PastelPalette.peach,
                          bevelColor: PastelPalette.peachBevel,
                          onPressed: () async {
                            final Uri url = Uri.parse('https://ko-fi.com/sidhant947');
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Buy me a coffee',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: PastelPalette.peachText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TangibleButton(
                            height: 52,
                            color: PastelPalette.lavender,
                            bevelColor: PastelPalette.lavenderBevel,
                            onPressed: notifier.canUndo
                                ? () {
                                    HapticFeedback.lightImpact();
                                    notifier.undo();
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.undo_rounded,
                                  color: notifier.canUndo
                                      ? PastelPalette.lavenderText
                                      : PastelPalette.lockedText,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Undo',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: notifier.canUndo
                                        ? PastelPalette.lavenderText
                                        : PastelPalette.lockedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (ref.watch(hintHelperProvider)) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: TangibleButton(
                              height: 52,
                              color: PastelPalette.butter,
                              bevelColor: PastelPalette.butterBevel,
                              onPressed: !state.isSolved
                                  ? () {
                                      HapticFeedback.mediumImpact();
                                      notifier.useHint();
                                    }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lightbulb_rounded,
                                    color: !state.isSolved
                                        ? PastelPalette.butterText
                                        : PastelPalette.lockedText,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hint',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: !state.isSolved
                                          ? PastelPalette.butterText
                                          : PastelPalette.lockedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
