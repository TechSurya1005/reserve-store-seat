import 'package:flutter/material.dart';
import '../domain/entities/table_entity.dart';
import '../domain/entities/time_slot_entity.dart';
import '../domain/usecases/create_table_usecase.dart';
import '../domain/usecases/create_time_slot_usecase.dart';
import '../domain/usecases/get_tables_usecase.dart';
import '../domain/usecases/get_time_slots_usecase.dart';
import '../domain/usecases/update_time_slot_usecase.dart';

class LayoutViewModel extends ChangeNotifier {
  final CreateTableUseCase createTableUseCase;
  final CreateTimeSlotUseCase createTimeSlotUseCase;
  final UpdateTimeSlotUseCase updateTimeSlotUseCase;
  final GetTablesUseCase getTablesUseCase;
  final GetTimeSlotsUseCase getTimeSlotsUseCase;

  LayoutViewModel({
    required this.createTableUseCase,
    required this.createTimeSlotUseCase,
    required this.updateTimeSlotUseCase,
    required this.getTablesUseCase,
    required this.getTimeSlotsUseCase,
  });

  List<TableEntity> _tables = [];
  List<TableEntity> get tables => _tables;

  List<TimeSlotEntity> _timeSlots = [];
  List<TimeSlotEntity> get timeSlots => _timeSlots;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchTables() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tables = await getTablesUseCase.execute();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching tables: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTimeSlots() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _timeSlots = await getTimeSlotsUseCase.execute();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching slots: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInitialData() async {
    await Future.wait([fetchTables(), fetchTimeSlots()]);
  }

  Future<bool> createTable({
    required String area,
    required String name,
    required int size,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final table = TableEntity(
        area: area,
        name: name,
        size: size,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await createTableUseCase.execute(table);
      await fetchTables(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> createTimeSlot({
    required String slotName,
    required bool active,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final timeSlot = TimeSlotEntity(
        slotName: slotName,
        active: active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await createTimeSlotUseCase.execute(timeSlot);
      await fetchTimeSlots(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleSlotStatus(TimeSlotEntity slot, bool newStatus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedSlot = TimeSlotEntity(
        id: slot.id,
        slotName: slot.slotName,
        active: newStatus,
        createdAt: slot.createdAt,
        updatedAt: DateTime.now(),
      );
      await updateTimeSlotUseCase.execute(updatedSlot);
      await fetchTimeSlots(); // Refresh list
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
