import 'package:quickseatreservation/features/layouts/domain/entities/table_entity.dart';
import 'package:quickseatreservation/features/bookTable/domain/repositories/booking_repository.dart';

class GetAvailableTablesUseCase {
  final BookingRepository repository;

  GetAvailableTablesUseCase(this.repository);

  Future<List<TableEntity>> execute({
    required String date,
    required String slotId,
    required int partySize,
  }) async {
    return await repository.getAvailableTables(
      date: date,
      slotId: slotId,
      partySize: partySize,
    );
  }
}
