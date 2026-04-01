import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/course_model.dart';

class CoursesController extends GetxController {
  // Keep as Rx so the AppBar icon Obx still works
  final RxBool isGridView = true.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  final List<String> categories = DummyData.categories;
  final List<CourseModel> _allCourses = DummyData.courses;

  List<CourseModel> get filteredCourses {
    return _allCourses.where((c) {
      final matchesCategory = selectedCategory.value == 'All' ||
          c.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          c.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.instructor.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
    update(); // notify GetBuilder
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
    update(); // notify GetBuilder
  }

  void updateSearch(String q) {
    searchQuery.value = q;
    update(); // notify GetBuilder
  }
}
