import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class FetchBookingsUseCase {
  final BookingRepository repository;

  FetchBookingsUseCase(this.repository);

  Future<List<BookingEntity>> execute() async {
    return await repository.getAllBookings();
  }
}
