// lib/data/datasources/plant_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/plant_entity.dart';
import '../models/plant_model.dart';

abstract class PlantDatasource {
  Future<void> addPlant(PlantModel plant);
  Future<void> deletePlant(String plantId);
  Future<List<PlantEntity>> getPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
  Stream<List<PlantEntity>> watchPlants({String? category});
}

class PlantDatasourceImpl implements PlantDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PlantDatasourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  // ✅ User-specific plants collection
  CollectionReference<Map<String, dynamic>> get _plantsCollection {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('plants');
  }

  @override
  Future<void> addPlant(PlantModel plant) async {
    try {
      await _plantsCollection.doc(plant.id).set(plant.toFirestore());
    } catch (e) {
      throw Exception('Failed to add plant: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePlant(String plantId) async {
    try {
      await _plantsCollection.doc(plantId).delete();
    } catch (e) {
      throw Exception('Failed to delete plant: ${e.toString()}');
    }
  }

  @override
  Future<List<PlantEntity>> getPlants({String? category}) async {
    try {
      Query query = _plantsCollection.orderBy('createdAt', descending: true);
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => PlantModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch plants: ${e.toString()}');
    }
  }

  @override
  Future<PlantEntity?> getPlantById(String id) async {
    try {
      final doc = await _plantsCollection.doc(id).get();
      if (!doc.exists) return null;
      return PlantModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch plant: ${e.toString()}');
    }
  }

  @override
  Stream<List<PlantEntity>> watchPlants({String? category}) {
    Query query = _plantsCollection.orderBy('createdAt', descending: true);
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => PlantModel.fromFirestore(doc)).toList(),
    );
  }
}