import '../../domain/entities/table_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/repositories/layout_repository.dart';
import '../datasources/layout_remote_data_source.dart';
import '../models/table_model.dart';
import '../models/time_slot_model.dart';

class LayoutRepositoryImpl implements LayoutRepository {
  final LayoutRemoteDataSource remoteDataSource;

  LayoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createTable(TableEntity table) async {
    final model = TableModel(
      area: table.area,
      name: table.name,
      size: table.size,
      isActive: table.isActive,
      createdAt: table.createdAt,
      updatedAt: table.updatedAt,
    );
    await remoteDataSource.createTable(model);
  }

  @override
  Future<void> createTimeSlot(TimeSlotEntity timeSlot) async {
    final model = TimeSlotModel(
      slotName: timeSlot.slotName,
      active: timeSlot.active,
      createdAt: timeSlot.createdAt,
      updatedAt: timeSlot.updatedAt,
    );
    await remoteDataSource.createTimeSlot(model);
  }

  @override
  Future<void> updateTimeSlot(TimeSlotEntity timeSlot) async {
    final model = TimeSlotModel(
      id: timeSlot.id,
      slotName: timeSlot.slotName,
      active: timeSlot.active,
      createdAt: timeSlot.createdAt,
      updatedAt: DateTime.now(),
    );
    await remoteDataSource.updateTimeSlot(model);
  }

  @override
  Future<List<TableEntity>> getTables() async {
    return await remoteDataSource.getTables();
  }

  @override
  Future<List<TimeSlotEntity>> getTimeSlots() async {
    return await remoteDataSource.getTimeSlots();
  }
}
