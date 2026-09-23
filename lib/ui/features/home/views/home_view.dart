import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers.dart';
import 'package:jigsaw/ui/core/widgets/tangible_widgets.dart';
import '../../game/jigsaw/jigsaw_screen.dart';
import '../../level_select/views/level_select_view.dart';
import '../../onboarding/views/onboarding_view.dart';
import '../../settings/views/settings_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(homeViewModelProvider.notifier).loadProgress();
      if (!mounted) return;
      final hiveService = ref.read(hiveServiceProvider);
      if (!hiveService.getHasSeenOnboarding()) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingView()),
        );
      }
    });
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showRandomPuzzleDialog(BuildContext context) {
    int selectedGrid = 4;
    String? selectedImagePath;
    final images = ref.read(puzzleImagesProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
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
                    Text(
                      'Random Puzzle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: PastelPalette.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select Image',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: PastelPalette.textDark,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 64,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final isSelected = selectedImagePath == null;
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedImagePath = null;
                                });
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: PastelPalette.butter.withValues(
                                    alpha: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? PastelPalette.butterBevel
                                        : PastelPalette.neutralBorder,
                                    width: isSelected ? 3 : 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shuffle_rounded,
                                      color: PastelPalette.butterText,
                                      size: 24,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Random',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: PastelPalette.butterText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          final imgPath = images[index - 1];
                          final isSelected = selectedImagePath == imgPath;
                          final isAsset = imgPath.startsWith('assets/');
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedImagePath = imgPath;
                              });
                            },
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? PastelPalette.mintBevel
                                      : PastelPalette.neutralBorder,
                                  width: isSelected ? 3 : 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: isAsset
                                    ? Image.asset(
                                        imgPath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: PastelPalette.locked,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 20,
                                                      color: PastelPalette
                                                          .lockedText,
                                                    ),
                                                  ),
                                                ),
                                      )
                                    : Image.file(
                                        File(imgPath),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: PastelPalette.locked,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      size: 20,
                                                      color: PastelPalette
                                                          .lockedText,
                                                    ),
                                                  ),
                                                ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Grid Size: ${selectedGrid}x$selectedGrid',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: PastelPalette.textDark,
                        fontSize: 16,
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: PastelPalette.mint,
                        inactiveTrackColor: PastelPalette.neutralBevel,
                        thumbColor: PastelPalette.mintBevel,
                        overlayColor: PastelPalette.mint.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: selectedGrid.toDouble(),
                        min: 3,
                        max: 10,
                        divisions: 7,
                        onChanged: (val) {
                          setModalState(() {
                            selectedGrid = val.round();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TangibleButton(
                            height: 48,
                            color: PastelPalette.locked,
                            bevelColor: PastelPalette.lockedBevel,
                            elevation: 3,
                            onPressed: () => Navigator.pop(context),
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
                            height: 48,
                            color: PastelPalette.mint,
                            bevelColor: PastelPalette.mintBevel,
                            elevation: 3,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JigsawScreen(
                                    levelNumber: 1,
                                    gridSize: selectedGrid,
                                    isRandom: true,
                                    selectedImage: selectedImagePath,
                                  ),
                                ),
                              );
                            },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: PastelPalette.mintText,
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSkinProvider);
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TangibleIconButton(
              icon: Icons.star_rounded,
              color: PastelPalette.butter,
              bevelColor: PastelPalette.butterBevel,
              iconColor: PastelPalette.butterText,
              onPressed: () =>
                  _launchUrl('https://github.com/sidhant947/Jigsaw'),
            ),
          ),
        ),
        centerTitle: true,
        title: state.progress != null
            ? TangibleBadge(
                color: PastelPalette.surface,
                bevelColor: PastelPalette.neutralBevel,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      color: PastelPalette.butterText,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Level ${state.progress!.currentLevel}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: PastelPalette.textDark,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: TangibleIconButton(
                icon: Icons.favorite_rounded,
                color: PastelPalette.peach,
                bevelColor: PastelPalette.peachBevel,
                iconColor: PastelPalette.peachText,
                onPressed: () => _launchUrl('https://ko-fi.com/sidhant947'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Text(
                  'Jigsaw',
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.textDark,
                    letterSpacing: -1.0,
                    shadows: [
                      Shadow(
                        color: PastelPalette.neutralBevel,
                        offset: const Offset(0, 5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              TangibleButton(
                height: 58,
                color: PastelPalette.mint,
                bevelColor: PastelPalette.mintBevel,
                onPressed: state.isLoading
                    ? null
                    : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JigsawScreen(
                              levelNumber: state.progress?.currentLevel ?? 1,
                            ),
                          ),
                        );
                        ref.read(homeViewModelProvider.notifier).loadProgress();
                      },
                child: Text(
                  'Play',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.mintText,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TangibleButton(
                height: 56,
                color: PastelPalette.lavender,
                bevelColor: PastelPalette.lavenderBevel,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelSelectView(),
                    ),
                  );
                  ref.read(homeViewModelProvider.notifier).loadProgress();
                },
                child: Text(
                  'Levels',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: PastelPalette.lavenderText,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TangibleButton(
                height: 56,
                color: PastelPalette.butter,
                bevelColor: PastelPalette.butterBevel,
                onPressed: () => _showRandomPuzzleDialog(context),
                child: Text(
                  'Random',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: PastelPalette.butterText,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TangibleButton(
                height: 56,
                color: PastelPalette.sky,
                bevelColor: PastelPalette.skyBevel,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsView()),
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: PastelPalette.skyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
