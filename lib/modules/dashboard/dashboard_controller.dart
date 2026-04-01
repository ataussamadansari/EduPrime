import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/course_model.dart';

class DashboardController extends GetxController {
  final RxInt bannerIndex = 0.obs;

  final banners = DummyData.banners;
  final featuredCourses = DummyData.courses.take(4).toList();
  final enrolledCourses = DummyData.enrolledCourses;

  final Map<String, dynamic> user = DummyData.userProfile;

  List<CourseModel> get continueLearning => DummyData.enrolledCourses
      .where((c) => c.progress > 0 && c.progress < 1)
      .toList();
}
