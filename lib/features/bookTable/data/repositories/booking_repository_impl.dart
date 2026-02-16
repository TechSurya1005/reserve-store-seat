import 'package:quickseatreservation/features/layouts/data/datasources/layout_remote_data_source.dart';
import 'package:quickseatreservation/features/layouts/domain/entities/table_entity.dart';
import 'package:quickseatreservation/features/bookTable/data/datasources/booking_remote_data_source.dart';
import 'package:quickseatreservation/features/bookTable/domain/entities/booking_entity.dart';
import 'package:quickseatreservation/features/bookTable/data/models/booking_model.dart';
import 'package:quickseatreservation/features/bookTable/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource bookingRemoteDataSource;
  final LayoutRemoteDataSource layoutRemoteDataSource;

  BookingRepositoryImpl({
    required this.bookingRemoteDataSource,
    required this.layoutRemoteDataSource,
  });

  @override
  Future<void> createBooking(BookingEntity booking) async {
    final model = BookingModel(
      tableId: booking.tableId,
      timeSlotId: booking.timeSlotId,
      date: booking.date,
      status: booking.status,
      partySize: booking.partySize,
      customerName: booking.customerName,
      customerPhone: booking.customerPhone,
      specialRequests: booking.specialRequests,
      createdAt: booking.createdAt,
      updatedAt: booking.updatedAt,
    );
    await bookingRemoteDataSource.createBooking(model);
  }

  @override
  Future<List<TableEntity>> getAvailableTables({
    required String date,
    required String slotId,
    required int partySize,
  }) async {
    // 1. Fetch all active tables from layout data source
    final allTableModels = await layoutRemoteDataSource.getTables();

    // 2. Filter by isActive and capacity
    final suitableTables = allTableModels.where((table) {
      return table.isActive && table.size >= partySize;
    }).toList();

    // 3. Fetch existing bookings for this date/slot
    final existingBookings = await bookingRemoteDataSource.getBookings(
      date,
      slotId,
    );
    final bookedTableIds = existingBookings.map((b) => b.tableId).toSet();

    // 4. Exclude booked tables
    return suitableTables
        .where((table) => !bookedTableIds.contains(table.id))
        .toList();
  }

  @override
  Future<List<BookingEntity>> getAllBookings() async {
    final models = await bookingRemoteDataSource.getAllBookings();
    return models; // BookingModel extends BookingEntity
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await bookingRemoteDataSource.updateBookingStatus(bookingId, status);
  }
}
