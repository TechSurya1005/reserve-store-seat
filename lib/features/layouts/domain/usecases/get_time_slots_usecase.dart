import '../entities/time_slot_entity.dart';
import '../repositories/layout_repository.dart';

class GetTimeSlotsUseCase {
  final LayoutRepository repository;

  GetTimeSlotsUseCase(this.repository);

  Future<List<TimeSlotEntity>> execute() async {
    return await repository.getTimeSlots();
  }
}
