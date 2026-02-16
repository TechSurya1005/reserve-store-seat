import '../entities/time_slot_entity.dart';
import '../repositories/layout_repository.dart';

class UpdateTimeSlotUseCase {
  final LayoutRepository repository;

  UpdateTimeSlotUseCase(this.repository);

  Future<void> execute(TimeSlotEntity timeSlot) async {
    return await repository.updateTimeSlot(timeSlot);
  }
}
