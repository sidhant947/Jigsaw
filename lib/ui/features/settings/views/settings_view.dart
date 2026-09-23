import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../providers.dart';
import 'package:jigsaw/ui/core/widgets/tangible_widgets.dart';
import '../../onboarding/views/onboarding_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(puzzleImagesProvider);

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
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: PastelPalette.textDark,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          TangibleCard(
            color: PastelPalette.surface,
            bevelColor: PastelPalette.neutralBevel,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: PastelPalette.sky.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.lightbulb_rounded,
                    color: PastelPalette.skyText,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hint Helper',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: PastelPalette.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Display hint button on puzzle screen',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: PastelPalette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: ref.watch(hintHelperProvider),
                  activeThumbColor: PastelPalette.mint,
                  activeTrackColor: PastelPalette.mint.withValues(alpha: 0.4),
                  inactiveThumbColor: PastelPalette.lockedText,
                  inactiveTrackColor: PastelPalette.neutralBevel,
                  onChanged: (val) {
                    ref.read(hintHelperProvider.notifier).toggle(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'App Theme',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: PastelPalette.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Customize your color scheme',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: PastelPalette.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: AppSkin.values.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final skin = AppSkin.values[index];
                final currentSkin = ref.watch(appSkinProvider);
                final isSelected = skin == currentSkin;
                final palette = AppPaletteData.forSkin(skin);

                return GestureDetector(
                  onTap: () {
                    ref.read(appSkinProvider.notifier).setSkin(skin);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: palette.canvas,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? PastelPalette.mintBevel
                            : PastelPalette.neutralBevel,
                        width: isSelected ? 3.5 : 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: PastelPalette.mintBevel
                                    .withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 24,
                              color: palette.mintText,
                            )
                          : Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: palette.mint,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Puzzle Images',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: PastelPalette.textDark,
                ),
              ),
              TangibleBadge(
                color: PastelPalette.butter,
                bevelColor: PastelPalette.butterBevel,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                borderRadius: BorderRadius.circular(12),
                elevation: 2,
                child: Text(
                  '${images.length} images',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: PastelPalette.butterText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'All pre-installed images are from Pixabay and free to use under the Pixabay license.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: PastelPalette.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: images.length + 1,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddImageButton(context, ref);
                }
                final imagePath = images[index - 1];
                return _buildImageCard(context, ref, imagePath, images.length);
              },
            ),
          ),
          const SizedBox(height: 28),
          TangibleButton(
            height: 54,
            color: PastelPalette.lavender,
            bevelColor: PastelPalette.lavenderBevel,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingView(isRevisit: true),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: PastelPalette.lavenderText,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'App Info & Guide',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.lavenderText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TangibleButton(
            height: 54,
            color: PastelPalette.peach,
            bevelColor: PastelPalette.peachBevel,
            onPressed: () => _confirmReset(context, ref),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: PastelPalette.peachText,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'Reset Progress',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.peachText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddImageButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _pickAndAddImage(context, ref),
      child: SizedBox(
        width: 100,
        height: 110,
        child: Container(
          decoration: BoxDecoration(
            color: PastelPalette.skyBevel,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              color: PastelPalette.sky.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: PastelPalette.skyBevel.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_rounded,
                  size: 32,
                  color: PastelPalette.skyText,
                ),
                const SizedBox(height: 6),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.skyText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    WidgetRef ref,
    String imagePath,
    int totalCount,
  ) {
    final isAsset = imagePath.startsWith('assets/');

    return SizedBox(
      width: 100,
      height: 110,
      child: Container(
        decoration: BoxDecoration(
          color: PastelPalette.neutralBevel,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 3),
          decoration: BoxDecoration(
            color: PastelPalette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                isAsset
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: PastelPalette.locked,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: PastelPalette.lockedText,
                            ),
                          ),
                        ),
                      )
                    : Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: PastelPalette.locked,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: PastelPalette.lockedText,
                            ),
                          ),
                        ),
                      ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => _confirmDeleteImage(
                      context,
                      ref,
                      imagePath,
                      totalCount,
                    ),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: PastelPalette.peach,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: PastelPalette.peachText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndAddImage(BuildContext context, WidgetRef ref) async {
    try {
      final files = await FilePicker.pickFiles(type: FileType.image);
      if (files.isEmpty) return;

      final appDir = await getApplicationDocumentsDirectory();
      final customDir = Directory('${appDir.path}/custom_images/pool');
      if (!await customDir.exists()) {
        await customDir.create(recursive: true);
      }

      final newPaths = <String>[];
      final now = DateTime.now().millisecondsSinceEpoch;
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final cleanName = file.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
        final fileName = '${now}_${i}_$cleanName';
        final targetPath = '${customDir.path}/$fileName';

        if (file.path != null) {
          await File(file.path!).copy(targetPath);
        } else {
          final bytes = await file.readAsBytes();
          await File(targetPath).writeAsBytes(bytes);
        }
        newPaths.add(targetPath);
      }

      await ref.read(puzzleImagesProvider.notifier).addImages(newPaths);
    } catch (_) {}
  }

  void _confirmDeleteImage(
    BuildContext context,
    WidgetRef ref,
    String imagePath,
    int totalCount,
  ) {
    if (totalCount <= 10) {
      showDialog(
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
                    Icons.info_outline_rounded,
                    size: 44,
                    color: PastelPalette.peach,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Minimum 10 Images',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: PastelPalette.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The puzzle pool must have at least 10 images to ensure an optimal puzzle experience. Add another image before deleting this one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: PastelPalette.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                TangibleButton(
                  height: 46,
                  color: PastelPalette.mint,
                  bevelColor: PastelPalette.mintBevel,
                  elevation: 3,
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Got It',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: PastelPalette.mintText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final isAsset = imagePath.startsWith('assets/');

    showDialog(
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
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: isAsset
                        ? Image.asset(imagePath, fit: BoxFit.cover)
                        : Image.file(File(imagePath), fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Delete Image?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: PastelPalette.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remove this image from the puzzle pool?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: PastelPalette.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TangibleButton(
                      height: 46,
                      color: PastelPalette.locked,
                      bevelColor: PastelPalette.lockedBevel,
                      elevation: 3,
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: PastelPalette.textDark,
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
                      onPressed: () async {
                        await ref
                            .read(puzzleImagesProvider.notifier)
                            .removeImage(imagePath);
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: PastelPalette.peachText,
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
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
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
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: PastelPalette.peach,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Reset Progress?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: PastelPalette.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This clears all level progress. This action cannot be undone.',
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
                      height: 48,
                      color: PastelPalette.locked,
                      bevelColor: PastelPalette.lockedBevel,
                      elevation: 3,
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: PastelPalette.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TangibleButton(
                      height: 48,
                      color: PastelPalette.peach,
                      bevelColor: PastelPalette.peachBevel,
                      elevation: 3,
                      onPressed: () async {
                        await ref
                            .read(homeViewModelProvider.notifier)
                            .resetProgress();
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                      },
                      child: Text(
                        'Reset All',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: PastelPalette.peachText,
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
  }
}
