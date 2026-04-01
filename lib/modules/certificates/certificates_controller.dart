import 'package:get/get.dart';
import '../../data/models/certificate_model.dart';
import '../../data/repositories/certificate_repository.dart';

class CertificatesController extends GetxController {
  final _repo = CertificateRepository();

  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCertificates();
  }

  Future<void> fetchCertificates() async {
    isLoading.value = true;
    error.value = '';
    try {
      certificates.value = await _repo.getCertificates();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
