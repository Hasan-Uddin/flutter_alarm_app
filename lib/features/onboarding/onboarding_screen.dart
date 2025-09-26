import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/common_widgets/custom_btn.dart';
import 'package:flutter_alarm_app/features/location/location_screen.dart';
import 'package:flutter_alarm_app/helpers/services/storage_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_page_model.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;
  late List<VideoPlayerController> _videoControllers;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _videoControllers = List.generate(contents.length, (index) {
      final controller = VideoPlayerController.asset(
        contents[index].videoPath!,
      );
      controller.setLooping(true);
      return controller;
    });

    Future.wait(_videoControllers.map((controller) => controller.initialize()))
        .then((_) {
      if (mounted) {
        setState(() {});
        _playCurrentVideo(currentIndex);
      }
    });
  }

  void _playCurrentVideo(int index) {
    _videoControllers[index].play();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // save onboarding preference
  Future<void> _storeOnboardInfo() async {
    await _storageService.setOnboardingViewed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      // Stop the previous video
                      if (currentIndex < _videoControllers.length) {
                        _videoControllers[currentIndex].pause();
                      }
                      // Play the new video
                      _playCurrentVideo(index);
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: _VideoPlayerWidget(
                              controller: _videoControllers[i],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contents[i].title!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  contents[i].description!,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Smooth Page Indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: contents.length,
                  effect: WormEffect(
                    dotWidth: 8,
                    dotHeight: 8,
                    // Color of active dot
                    activeDotColor: Theme.of(context).colorScheme.secondary,
                    // Color of inactive dot
                    dotColor: Theme.of(context).colorScheme.tertiary,
                    spacing: 10,
                  ),
                ),
              ),
              CustomBtn(
                text: currentIndex == 0 ? "Get Started" : "Next",
                onPressed: () async {
                  if (currentIndex == contents.length - 1) {
                    await _storeOnboardInfo();
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LocationScreen(),
                        ),
                      );
                    }
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),

          // Skip button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () async {
                await _storeOnboardInfo();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LocationScreen()),
                  );
                }
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const _VideoPlayerWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.54,
      child: controller.value.isInitialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
