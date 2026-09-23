import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/tangible_widgets.dart';
import '../../../providers.dart';
import '../../settings/views/settings_view.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key, this.isRevisit = false});

  final bool isRevisit;

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding({bool goToSettings = false}) async {
    await ref.read(hiveServiceProvider).setHasSeenOnboarding(true);
    if (!mounted) return;
    if (widget.isRevisit) {
      Navigator.pop(context);
      if (goToSettings) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsView()),
        );
      }
    } else {
      if (goToSettings) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsView()),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSkinProvider);

    final steps = [
      _OnboardingStep(
        icon: Icons.volunteer_activism_rounded,
        color: PastelPalette.peach,
        bevelColor: PastelPalette.peachBevel,
        textColor: PastelPalette.peachText,
        title: 'Free & Open Source',
        subtitle: 'Built for everyone, no ads or tracking',
        description:
            'Jigsaw is a non-commercial, FOSS app. To keep the app lightweight and respect licenses, it comes with a compact set of default puzzle images.',
      ),
      _OnboardingStep(
        icon: Icons.add_photo_alternate_rounded,
        color: PastelPalette.sky,
        bevelColor: PastelPalette.skyBevel,
        textColor: PastelPalette.skyText,
        title: 'Add Your Own Images',
        subtitle: 'Import photos directly in Settings',
        description:
            'You can add as many images as you like! Simply open Settings and tap "Add" to select photos from your device library to play as puzzles.',
      ),
      _OnboardingStep(
        icon: Icons.extension_rounded,
        color: PastelPalette.mint,
        bevelColor: PastelPalette.mintBevel,
        textColor: PastelPalette.mintText,
        title: 'Endless Possibilities',
        subtitle: 'Personalized puzzle experience',
        description:
            'Turning your favorite memories, artwork, and wallpapers into puzzles makes every game unique. Customize your collection and enjoy!',
      ),
    ];

    final isLast = _currentPage == steps.length - 1;

    return Scaffold(
      backgroundColor: PastelPalette.canvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: steps.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TangibleCard(
                          color: step.color,
                          bevelColor: step.bevelColor,
                          padding: const EdgeInsets.all(28),
                          borderRadius: BorderRadius.circular(32),
                          elevation: 6,
                          child: Icon(
                            step.icon,
                            size: 64,
                            color: step.textColor,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: PastelPalette.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: step.bevelColor,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TangibleCard(
                          color: PastelPalette.surface,
                          bevelColor: PastelPalette.neutralBevel,
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            step.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              color: PastelPalette.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                steps.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? PastelPalette.mintBevel
                        : PastelPalette.neutralBevel,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: isLast
                  ? Column(
                      children: [
                        TangibleButton(
                          height: 56,
                          color: PastelPalette.sky,
                          bevelColor: PastelPalette.skyBevel,
                          onPressed: () =>
                              _completeOnboarding(goToSettings: true),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings_rounded,
                                color: PastelPalette.skyText,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Open Settings & Add Images',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: PastelPalette.skyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TangibleButton(
                          height: 54,
                          color: PastelPalette.mint,
                          bevelColor: PastelPalette.mintBevel,
                          onPressed: () => _completeOnboarding(),
                          child: Text(
                            'Got It, Start Playing',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: PastelPalette.mintText,
                            ),
                          ),
                        ),
                      ],
                    )
                  : TangibleButton(
                      height: 56,
                      color: PastelPalette.mint,
                      bevelColor: PastelPalette.mintBevel,
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: PastelPalette.mintText,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  const _OnboardingStep({
    required this.icon,
    required this.color,
    required this.bevelColor,
    required this.textColor,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final Color bevelColor;
  final Color textColor;
  final String title;
  final String subtitle;
  final String description;
}
