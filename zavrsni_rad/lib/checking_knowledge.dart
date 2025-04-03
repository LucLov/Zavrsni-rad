import 'package:flutter/material.dart';

class CheckingKnowledge extends StatelessWidget {
  const CheckingKnowledge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Ispitaj svoje znanje o svim mjesecima!",
        style: TextStyle(fontSize: 30),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 40.0),
          onPressed: () {
            Navigator.of(context).pop(); // Vraća korisnika na prethodnu stranicu
          },
        ),
      ),
    );
  }
}
