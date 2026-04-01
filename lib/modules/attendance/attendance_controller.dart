import 'package:get/get.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/attendance_repository.dart';

class AttendanceController extends GetxController {
  final _repo = AttendanceRepository();

  final Rx<AttendanceSummary?> summary = Rx(null);
  final RxList<AttendanceRecord> records = <AttendanceRecord>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<DateTime> focusedMonth = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx(null);

  // Map<dateString, List<records>> for quick lookup
  final RxMap<String, List<AttendanceRecord>> calendarMap =
      <String, List<AttendanceRecord>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll(focusedMonth.value);
  }

  Future<void> _loadAll(DateTime month) async {
    isLoading.value = true;
    error.value = '';
    try {
      final monthStr =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      final results = await Future.wait([
        _repo.getSummary(),
        _repo.getCalendar(monthStr),
      ]);
      summary.value = results[0] as AttendanceSummary;
      final recs = results[1] as List<AttendanceRecord>;
      records.value = recs;
      _buildCalendarMap(recs);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _buildCalendarMap(List<AttendanceRecord> recs) {
    final map = <String, List<AttendanceRecord>>{};
    for (final r in recs) {
      final key = _dateKey(r.date);
      map.putIfAbsent(key, () => []).add(r);
    }
    calendarMap.value = map;
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Returns null if no data, true if all present, false if any absent
  bool? statusForDay(DateTime day) {
    final key = _dateKey(day);
    final recs = calendarMap[key];
    if (recs == null || recs.isEmpty) return null;
    return recs.every((r) => r.isPresent);
  }

  List<AttendanceRecord> recordsForDay(DateTime day) =>
      calendarMap[_dateKey(day)] ?? [];

  void onMonthChanged(DateTime month) {
    focusedMonth.value = month;
    selectedDay.value = null;
    _loadAll(month);
  }

  void onDaySelected(DateTime day) {
    selectedDay.value = day;
  }
}
