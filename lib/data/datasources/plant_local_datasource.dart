import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_guard/data/models/plant_model.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';

abstract class PlantLocalDatasource {
  Future<void> addPlant(PlantModel plantModel);
  Future<void> deletePlant(PlantModel plantModel);
  Future<List<PlantEntity>> getPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
}

class PlantLocalDatasourceImpl implements PlantLocalDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PlantLocalDatasourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;
  CollectionReference<Map<String, dynamic>> get _plantsCollection {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to access plants');
    }
    return _firestore.collection('users').doc(user.uid).collection('plants');
  }

  @override
  Future<List<PlantEntity>> getPlants({String? category}) async {
    try {
      Query query = _plantsCollection.orderBy('createdAt', descending: true);
      if (category != null && category != 'All') {
        query = query.where('category', isEqualTo: category);
      }
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PlantModel.fromJson(doc as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch plants: ${e.toString()}');
    }
  }

  @override
  Future<PlantEntity?> getPlantById(String id) async {
    try {
      final doc = await _plantsCollection.doc(id).get();
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return PlantModel(
        id: id,
        name: data['name'],
        subtitle: data['subtitle'],
        category: data['category'],
        waterPercent: data['waterPercent'],
        lightPercent: data['lightPercent'],
        tempPercent: data['tempPercent'],
        airQualityPercent: data['airQualityPercent'],
        image: data['image'],
      );
    } catch (e) {
      throw Exception('Failed to fetch plant: ${e.toString()}');
    }
  }

  @override
  Future<void> addPlant(PlantModel plantModel) async {
    try {
      final plantData = plantModel.toJson();
      await _plantsCollection.doc(plantModel.id).set(plantData);
    } catch (e) {
      throw Exception('Failed to add plant: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePlant(PlantModel plantModel) async {
    try {
      await _plantsCollection.doc(plantModel.id).delete();
    } catch (e) {
      throw Exception('Failed to delete plant: ${e.toString()}');
    }
  }
}
