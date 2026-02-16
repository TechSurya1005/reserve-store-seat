import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/table_model.dart';
import '../models/time_slot_model.dart';
import 'package:quickseatreservation/app/constants/AppCollections.dart';

abstract class LayoutRemoteDataSource {
  Future<void> createTable(TableModel table);
  Future<void> createTimeSlot(TimeSlotModel timeSlot);
  Future<void> updateTimeSlot(TimeSlotModel timeSlot);
  Future<List<TableModel>> getTables();
  Future<List<TimeSlotModel>> getTimeSlots();
}

class LayoutRemoteDataSourceImpl implements LayoutRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createTable(TableModel table) async {
    try {
      await _firestore.collection(AppCollections.tables).add(table.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createTimeSlot(TimeSlotModel timeSlot) async {
    try {
      await _firestore
          .collection(AppCollections.timeSlots)
          .add(timeSlot.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTimeSlot(TimeSlotModel timeSlot) async {
    try {
      if (timeSlot.id == null)
        throw Exception("Time slot ID is required for update");
      await _firestore
          .collection(AppCollections.timeSlots)
          .doc(timeSlot.id)
          .update(timeSlot.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TableModel>> getTables() async {
    try {
      final snapshot = await _firestore.collection(AppCollections.tables).get();
      return snapshot.docs
          .map((doc) => TableModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TimeSlotModel>> getTimeSlots() async {
    try {
      final snapshot = await _firestore
          .collection(AppCollections.timeSlots)
          .get();
      return snapshot.docs
          .map((doc) => TimeSlotModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
