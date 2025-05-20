import 'dart:io';
import 'package:flutter/material.dart';
import '../models/plate_model.dart';
import '../services/firebase_service.dart';
import '../services/plate_service.dart';

class PlateViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final PlateService _plateService = PlateService();

  List<Plate> plates = [];
  bool isLoading = false;
  File? pickedImage;
  String ngrokUrl = '';

  Future<void> fetchPlates() async {
    _firebaseService.listenPlates().listen((event) {
      List<Plate> loadedPlates = [];
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final usersData = dataSnapshot.value as Map<dynamic, dynamic>;
        for (var userEntry in usersData.entries) {
          final platesMap = userEntry.value['plates'] as Map<dynamic, dynamic>?;
          if (platesMap != null) {
            for (var plateEntry in platesMap.entries) {
              loadedPlates.add(Plate.fromMap(Map<String, dynamic>.from(plateEntry.value)));
            }
          }
        }
      }
      plates = loadedPlates;
      notifyListeners();
    });
  }

  Future<void> loadNgrokUrl() async {
    ngrokUrl = await _firebaseService.getNgrokUrl();
  }

  Future<Map<String, dynamic>?> processImage(File image) async {
    pickedImage = image;
    isLoading = true;
    notifyListeners();

    await loadNgrokUrl();
    final data = await _plateService.uploadImageToServer(ngrokUrl, image);

    isLoading = false;
    notifyListeners();

    return data;
  }

  Future<void> savePlate(Plate plate) async {
    await _firebaseService.savePlate(_firebaseService.getUserId(), plate.toMap());
  }

  isMyPlate(Plate plate) {}
}
