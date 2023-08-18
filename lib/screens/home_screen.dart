import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/pet.dart';
import '../screens/pet_details_screen.dart';
import '../providers/save_pet.dart';
import '../screens/add_pet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pet> _pet = [];
  var _isLoading = true;
  String? _error;

  void _addPet() async {
    final petData = await Navigator.of(context).push<Pet>(
      MaterialPageRoute(
        builder: (context) => const AddPetScreen(),
      ),
    );
    if (petData != null) {
      setState(() {
        _pet.add(petData);
      });
    }
    return;
  }

  void _getData() async {
    var data = Provider.of<SavePet>(context, listen: false);
    await data.getPet();
    setState(() {
      _pet = data.pet;
      _isLoading = data.isLoading;
      _error = data.error;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Pet's added yet."),
    );
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 241, 132, 148),
        ),
      );
    }
    if (_pet.isNotEmpty) {
      content = GridView.builder(
          itemCount: _pet.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (ctx, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black87,
                      title: Text(
                        _pet[i].name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PetDetails(
                                  title: _pet[i].name,
                                  breed: _pet[i].name,
                                  description: _pet[i].description,
                                  imageUrl: _pet[i].imageUrl,
                                )));
                      },
                      child: Image.memory(
                        filterQuality: FilterQuality.high,
                        base64Decode(_pet[i].imageUrl),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            );
          });
    }
    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 241, 132, 148),
        title: const Text('My Pet'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Pet'), // <-- Text
        backgroundColor: const Color.fromARGB(255, 241, 132, 148),
        icon: const Icon(
          Icons.add,
          size: 24.0,
        ),
        onPressed: _addPet,
      ),
    );
  }
}
