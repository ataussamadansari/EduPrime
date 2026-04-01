import 'package:get/get.dart';
import '../../data/models/exam_api_model.dart';
import '../../data/repositories/exam_repository.dart';

class ExamsController extends GetxController {
  final _repo = ExamRepository();

  final RxList<ExamApiModel> upcoming = <ExamApiModel>[].obs;
  final RxList<ExamApiModel> past = <ExamApiModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    error.value = '';
    try {
      final results = await Future.wait([
        _repo.getUpcoming(),
        _repo.getPastResults(),
      ]);
      upcoming.value = results[0];
      past.value = results[1];
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
