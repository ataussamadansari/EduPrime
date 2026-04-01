import 'package:get/get.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/course_repository.dart';

class MyLearningController extends GetxController {
  final _repo = CourseRepository();

  final RxList<DashboardCourse> courses = <DashboardCourse>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyCourses();
  }

  Future<void> fetchMyCourses() async {
    isLoading.value = true;
    error.value = '';
    try {
      courses.value = await _repo.getMyCourses();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
