import '../repositories/booking_repository.dart';

class UpdateBookingStatusUseCase {
  final BookingRepository repository;

  UpdateBookingStatusUseCase(this.repository);

  Future<void> execute(String bookingId, String status) async {
    return await repository.updateBookingStatus(bookingId, status);
  }
}
