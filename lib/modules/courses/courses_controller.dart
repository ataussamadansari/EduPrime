import 'package:get/get.dart';
import '../../data/models/course_category_model.dart';
import '../../data/models/courses_list_model.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/course_repository.dart';

class CoursesController extends GetxController {
  final _repo = CourseRepository();

  // UI state
  final RxBool isGridView = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;

  // Filters
  final RxString searchQuery = ''.obs;
  final Rx<CourseCategoryModel?> selectedCategory = Rx(null);

  // Data
  final RxList<DashboardCourse> courses = <DashboardCourse>[].obs;
  final RxList<CourseCategoryModel> categories = <CourseCategoryModel>[].obs;
  PaginationModel? _pagination;

  bool get hasNextPage => _pagination?.hasNextPage ?? false;

  @override
  void onInit() {
    super.onInit();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    isLoading.value = true;
    error.value = '';
    try {
      // Load categories and first page of courses in parallel
      final results = await Future.wait([
        _repo.getCourseCategories(),
        _repo.getCourses(page: 1),
      ]);
      categories.value = results[0] as List<CourseCategoryModel>;
      final list = results[1] as CoursesListModel;
      courses.value = list.items;
      _pagination = list.pagination;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyFilters() async {
    isLoading.value = true;
    error.value = '';
    try {
      final list = await _repo.getCourses(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        categoryId: selectedCategory.value?.id,
        page: 1,
      );
      courses.value = list.items;
      _pagination = list.pagination;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore.value || !hasNextPage) return;
    isLoadingMore.value = true;
    try {
      final list = await _repo.getCourses(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        categoryId: selectedCategory.value?.id,
        page: (_pagination?.currentPage ?? 1) + 1,
      );
      courses.addAll(list.items);
      _pagination = list.pagination;
    } catch (_) {
    } finally {
      isLoadingMore.value = false;
    }
  }

  void onSearchChanged(String q) {
    searchQuery.value = q;
    applyFilters();
  }

  void selectCategory(CourseCategoryModel? cat) {
    selectedCategory.value = cat;
    applyFilters();
  }

  void toggleView() => isGridView.value = !isGridView.value;

  Future<void> retry() => _loadInitial();
}
