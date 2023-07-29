import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/save_pet.dart';
import '../models/pet.dart';
import '../widgets/pet_image_picker.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _form = GlobalKey<FormState>();

  File? _selecteImage;
  var _enteredName = '';
  var _enteredBreed = '';
  var _enteredDescription = '';
  var _isSending = false;

  _submit() async {
    var data = Provider.of<SavePet>(context, listen: false);
    // final prefs = await SharedPreferences.getInstance();
    // final extractedUserData =
    //     json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    // var _userId = extractedUserData['userId'];

    final isValid = _form.currentState!.validate();
    if (!isValid || _selecteImage == null) {
      return;
    }
    _form.currentState!.save();

    final bytes = io.File(_selecteImage!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);

    setState(() {
      _isSending = true;
    });

    await data.savePet(_enteredName, _enteredBreed, _enteredDescription, img64);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop(
      Pet(
          id: data.id,
          name: _enteredName,
          breed: _enteredBreed,
          description: _enteredDescription,
          imageUrl: img64),
    );
    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 241, 132, 148),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              Center(
                child: UserImagePicker(
                  onPickImage: (pickedImage) {
                    _selecteImage = pickedImage;
                  },
                ),
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Breed'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredBreed = value!;
                },
              ),
              TextFormField(
                maxLines: 5,
                maxLength: 100,
                decoration: const InputDecoration(
                  label: Text('Description'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredDescription = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 132, 148),
                  ),
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
