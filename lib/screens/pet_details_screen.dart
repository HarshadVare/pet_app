import 'dart:convert';
import 'package:flutter/material.dart';

class PetDetails extends StatelessWidget {
  final String title, description, breed, imageUrl;

  const PetDetails(
      {required this.title,
      required this.description,
      required this.breed,
      required this.imageUrl,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 241, 132, 148),
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.memory(
                base64Decode(imageUrl),
                // width: 50,
                // height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '$title ($breed)',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
