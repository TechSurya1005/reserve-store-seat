import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookings(String date, String slotId);
  Future<List<BookingModel>> getAllBookings();
  Future<void> updateBookingStatus(String bookingId, String status);
}
