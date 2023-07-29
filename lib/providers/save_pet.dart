import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/pet.dart';

class SavePet with ChangeNotifier {
  List<Pet> _pets = [];
  String? _error;
  var _id = '';
  var _isLoading = true;

  bool get isLoading => _isLoading;
  String get id => _id;
  String? get error => _error;
  List<Pet> get pet => _pets;

  Future<void> savePet(
      String petName, String breed, String description, String imageUrl) async {
    _id = '';
    final url =
        Uri.https('pet-app-487d5-default-rtdb.firebaseio.com', 'pet-list.json');
    var headers = {'Content-Type': 'application/json'};
    var requestBody = {
      'name': petName,
      'breed': breed,
      'description': description,
      'imageBase64': imageUrl
    };
    var response =
        await http.post(url, body: json.encode(requestBody), headers: headers);
    // print(response);
    if (response.statusCode == 200) {
      final Map<String, dynamic> resData = json.decode(response.body);
      _id = resData['name'];
    } else {
      print('something went wrong');
    }

    notifyListeners();
  }

  Future<void> getPet() async {
    _pets = [];
    final url =
        Uri.https('pet-app-487d5-default-rtdb.firebaseio.com', 'pet-list.json');
    try {
      var response = await http.get(url);
      if (response.body == 'null') {
        _isLoading = false;
        return;
      } else {
        if (response.statusCode == 200) {
          final Map<String, dynamic> petData = json.decode(response.body);
          // print(listData);
          for (final pet in petData.entries) {
            _pets.add(
              Pet(
                  id: pet.key,
                  name: pet.value['name'],
                  breed: pet.value['breed'],
                  description: pet.value['description'],
                  imageUrl: pet.value['imageBase64']),
            );
          }
        } else {
          _error = 'Failed to fetch data,Please try again later.';
        }
      }
      _isLoading = false;
    } catch (error) {
      _error = 'Something went wrong,Please try again later.';
    }

    notifyListeners();
  }
}
