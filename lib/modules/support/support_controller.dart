import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/support_ticket_model.dart';
import '../../data/repositories/support_repository.dart';

class SupportController extends GetxController {
  final _repo = SupportRepository();

  final RxList<SupportTicketModel> tickets = <SupportTicketModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  // Form fields
  final subjectCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  final RxString selectedCategory = 'general'.obs;
  final RxString selectedPriority = 'medium'.obs;

  static const categories = ['general', 'technical', 'billing', 'course'];
  static const priorities = ['low', 'medium', 'high'];

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    isLoading.value = true;
    error.value = '';
    try {
      tickets.value = await _repo.getTickets();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitTicket() async {
    if (subjectCtrl.text.trim().isEmpty || messageCtrl.text.trim().isEmpty) {
      Get.snackbar('Validation', 'Subject and message are required.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSubmitting.value = true;
    try {
      final ticket = await _repo.createTicket(
        subject: subjectCtrl.text.trim(),
        message: messageCtrl.text.trim(),
        category: selectedCategory.value,
        priority: selectedPriority.value,
      );
      tickets.insert(0, ticket);
      subjectCtrl.clear();
      messageCtrl.clear();
      selectedCategory.value = 'general';
      selectedPriority.value = 'medium';
      Get.back(); // close create sheet
      Get.snackbar(
        'Ticket Submitted',
        'We will get back to you soon.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    subjectCtrl.dispose();
    messageCtrl.dispose();
    super.onClose();
  }
}
