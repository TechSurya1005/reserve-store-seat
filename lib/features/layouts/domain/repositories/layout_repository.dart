import '../entities/table_entity.dart';
import '../entities/time_slot_entity.dart';

abstract class LayoutRepository {
  Future<void> createTable(TableEntity table);
  Future<void> createTimeSlot(TimeSlotEntity timeSlot);
  Future<void> updateTimeSlot(TimeSlotEntity timeSlot);
  Future<List<TableEntity>> getTables();
  Future<List<TimeSlotEntity>> getTimeSlots();
}
