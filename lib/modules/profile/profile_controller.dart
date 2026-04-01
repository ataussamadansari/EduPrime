import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../core/utils/app_routes.dart';

class ProfileController extends GetxController {
  final _repo = ProfileRepository();
  final _dashRepo = DashboardRepository();

  final Rx<UserModel?> user = Rx(null);
  final Rx<QuickStats?> quickStats = Rx(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    isLoading.value = true;
    error.value = '';
    try {
      final results = await Future.wait([
        _repo.getProfile(),
        _dashRepo.getDashboard(),
      ]);
      user.value = results[0] as UserModel;
      quickStats.value = (results[1] as DashboardModel).quickStats;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() => _loadAll();

  Future<void> logout() async {
    await _repo.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
