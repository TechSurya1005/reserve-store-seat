import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/get_all_bookings_usecase.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/update_booking_status_usecase.dart';
import 'package:quickseatreservation/features/layouts/domain/entities/table_entity.dart';
import 'package:quickseatreservation/features/bookTable/domain/entities/booking_entity.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/create_booking_usecase.dart';
import 'package:quickseatreservation/features/bookTable/domain/usecases/get_available_tables_usecase.dart';

class BookingViewModel extends ChangeNotifier {
  final GetAvailableTablesUseCase _getAvailableTablesUC;
  final CreateBookingUseCase _createBookingUC;
  final FetchBookingsUseCase _getAllBookingsUC;
  final UpdateBookingStatusUseCase _updateBookingStatusUC;

  BookingViewModel({
    required GetAvailableTablesUseCase getAvailableTablesUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required FetchBookingsUseCase getAllBookingsUseCase,
    required UpdateBookingStatusUseCase updateBookingStatusUseCase,
  }) : _getAvailableTablesUC = getAvailableTablesUseCase,
       _createBookingUC = createBookingUseCase,
       _getAllBookingsUC = getAllBookingsUseCase,
       _updateBookingStatusUC = updateBookingStatusUseCase {
    debugPrint("BookingViewModel initialized");
    debugPrint("getAvailableTablesUseCase: $getAvailableTablesUseCase");
    debugPrint("createBookingUseCase: $createBookingUseCase");
    debugPrint("getAllBookingsUseCase: $getAllBookingsUseCase");
    debugPrint("updateBookingStatusUseCase: $updateBookingStatusUseCase");
  }

  List<TableEntity> _availableTables = [];
  List<TableEntity> get availableTables => _availableTables;

  TableEntity? _selectedTable;
  TableEntity? get selectedTable => _selectedTable;

  void setSelectedTable(TableEntity? table) {
    _selectedTable = table;
    notifyListeners();
  }

  void clearSelectedTable() {
    _selectedTable = null;
    notifyListeners();
  }

  List<BookingEntity> _allBookings = [];
  List<BookingEntity> get allBookings => _allBookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchAvailableTables({
    required String date,
    required String slotId,
    required int partySize,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _availableTables = await _getAvailableTablesUC.execute(
        date: date,
        slotId: slotId,
        partySize: partySize,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching available tables: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking({
    required String tableId,
    required String timeSlotId,
    required String date,
    required int partySize,
    required String customerName,
    required String customerPhone,
    required String specialRequests,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final booking = BookingEntity(
        tableId: tableId,
        timeSlotId: timeSlotId,
        date: date,
        status: 'booked',
        partySize: partySize,
        customerName: customerName,
        customerPhone: customerPhone,
        specialRequests: specialRequests,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _createBookingUC.execute(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error creating booking: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchAllBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allBookings = await _getAllBookingsUC.execute();
      _isLoading = false;
      notifyListeners();
    } catch (e, stack) {
      debugPrint("Error fetching all bookings: $e");
      debugPrint("Stack trace: $stack");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _updateBookingStatusUC.execute(bookingId, 'cancelled');
      await fetchAllBookings(); // Refresh
      return true;
    } catch (e) {
      debugPrint("Error cancelling booking: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> seatGuest(String bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _updateBookingStatusUC.execute(bookingId, 'seated');
      await fetchAllBookings(); // Refresh
      return true;
    } catch (e) {
      debugPrint("Error seating guest: $e");
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Filtering Logic
  List<BookingEntity> filterBookings(String filter, String searchQuery) {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String tomorrow = DateFormat(
      'yyyy-MM-dd',
    ).format(now.add(const Duration(days: 1)));

    return _allBookings.where((booking) {
      bool matchesFilter = true;
      if (filter == 'Today') {
        matchesFilter = booking.date == today;
      } else if (filter == 'Tomorrow') {
        matchesFilter = booking.date == tomorrow;
      } else if (filter == 'Waitlist') {
        matchesFilter = booking.date != today && booking.date != tomorrow;
      } else if (filter == 'All') {
        matchesFilter = true;
      }

      bool matchesSearch =
          searchQuery.isEmpty ||
          booking.customerName.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          booking.customerPhone.contains(searchQuery);

      return matchesFilter && matchesSearch;
    }).toList();
  }
}
