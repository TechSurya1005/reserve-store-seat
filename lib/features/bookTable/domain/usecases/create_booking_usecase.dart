import 'package:quickseatreservation/features/bookTable/domain/entities/booking_entity.dart';
import 'package:quickseatreservation/features/bookTable/domain/repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<void> execute(BookingEntity booking) async {
    return await repository.createBooking(booking);
  }
}
