import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/course_repository.dart';

class LessonPlayerController extends GetxController {
  final _repo = CourseRepository();

  final Rx<LessonModel?> lesson = Rx(null);
  final RxBool isLoading = false.obs;
  final RxBool isVideoReady = false.obs;
  final RxBool isCompleted = false.obs;
  final RxString error = ''.obs;

  VideoPlayerController? videoCtrl;
  ChewieController? chewieCtrl;

  late int lessonId;
  late int courseId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    lessonId = args['lessonId'] as int;
    courseId = args['courseId'] as int;
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    isLoading.value = true;
    error.value = '';
    try {
      final l = await _repo.getLesson(lessonId);
      lesson.value = l;
      isCompleted.value = l.isCompleted;
      if (l.videoUrl != null && l.videoUrl!.isNotEmpty) {
        await _initVideo(l.videoUrl!);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initVideo(String url) async {
    videoCtrl = VideoPlayerController.networkUrl(Uri.parse(url));
    await videoCtrl!.initialize();
    chewieCtrl = ChewieController(
      videoPlayerController: videoCtrl!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      placeholder: Container(color: Colors.black),
    );
    // Auto-save progress when video ends
    videoCtrl!.addListener(_onVideoTick);
    isVideoReady.value = true;
  }

  void _onVideoTick() {
    final ctrl = videoCtrl;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    final total = ctrl.value.duration.inSeconds;
    final pos = ctrl.value.position.inSeconds;
    if (total > 0 && pos >= total - 2 && !isCompleted.value) {
      _saveProgress(100, pos, true);
    }
  }

  Future<void> _saveProgress(
      double percent, int watchedSeconds, bool completed) async {
    try {
      await _repo.updateLessonProgress(
        lessonId,
        progressPercentage: percent,
        watchedSeconds: watchedSeconds,
        isCompleted: completed,
      );
      if (completed) isCompleted.value = true;
    } catch (_) {}
  }

  Future<void> markComplete() async {
    final pos = videoCtrl?.value.position.inSeconds ?? 0;
    await _saveProgress(100, pos, true);
    Get.snackbar(
      'Lesson Complete!',
      'Great job. Keep going!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.9),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    videoCtrl?.removeListener(_onVideoTick);
    videoCtrl?.dispose();
    chewieCtrl?.dispose();
    super.onClose();
  }
}
