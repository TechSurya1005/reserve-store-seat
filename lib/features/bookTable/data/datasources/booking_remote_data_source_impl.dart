import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../app/constants/AppCollections.dart';
import '../models/booking_model.dart';
import 'booking_remote_data_source.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _firestore
          .collection(AppCollections.bookings)
          .add(booking.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookingModel>> getBookings(String date, String slotId) async {
    try {
      final snapshot = await _firestore
          .collection(AppCollections.bookings)
          .where('date', isEqualTo: date)
          .where('timeSlotId', isEqualTo: slotId)
          .where('status', isEqualTo: 'booked')
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BookingModel>> getAllBookings() async {
    try {
      final snapshot = await _firestore
          .collection(AppCollections.bookings)
          .get();
      return snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore
          .collection(AppCollections.bookings)
          .doc(bookingId)
          .update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }
}
