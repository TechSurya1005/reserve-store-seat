import '../entities/time_slot_entity.dart';
import '../repositories/layout_repository.dart';

class CreateTimeSlotUseCase {
  final LayoutRepository repository;

  CreateTimeSlotUseCase(this.repository);

  Future<void> execute(TimeSlotEntity timeSlot) async {
    return await repository.createTimeSlot(timeSlot);
  }
}
