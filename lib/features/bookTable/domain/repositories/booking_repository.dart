import '../../../layouts/domain/entities/table_entity.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingEntity booking);
  Future<List<TableEntity>> getAvailableTables({
    required String date,
    required String slotId,
    required int partySize,
  });
  Future<List<BookingEntity>> getAllBookings();
  Future<void> updateBookingStatus(String bookingId, String status);
}
