import 'package:flutter_alarm_app/constants/dir_path.dart';

class OnboardingContent {
  String? videoPath;
  String? title;
  String? description;

  OnboardingContent({this.videoPath, this.title, this.description});
}

List<OnboardingContent> contents = [
  OnboardingContent(
    videoPath: DirPath.onBoarding_vid_1,
    title: 'Discover the world, one journey at a time.',
    description:
        "From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today.",
  ),
  OnboardingContent(
    videoPath: DirPath.onBoarding_vid_2,
    title: 'Explore new horizons, one step at a time.',
    description:
        "Every trip holds a story waiting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.",
  ),
  OnboardingContent(
    videoPath: DirPath.onBoarding_vid_3,
    title: 'See the beauty, one journey at a time.',
    description:
        "Travel made simple and exciting—discover places you’ll love and moments you’ll never forget.",
  ),
];
