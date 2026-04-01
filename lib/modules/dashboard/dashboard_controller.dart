import 'package:get/get.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final _repo = DashboardRepository();

  final Rx<DashboardModel?> dashboard = Rx(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt bannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    error.value = '';
    try {
      dashboard.value = await _repo.getDashboard();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
