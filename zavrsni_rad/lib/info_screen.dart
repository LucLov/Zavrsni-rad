import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Informacije o projektu",
        style: TextStyle(fontSize: 30),),
        backgroundColor: Color(0XFFC4E2FF),
        foregroundColor: Color(0xFF9D3D25),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 40.0),
          onPressed: () {
            Navigator.of(context).pop(); // Vraća korisnika na prethodnu stranicu
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column (
          mainAxisSize: MainAxisSize.min, // Da ne zauzme previše prostora
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
          '''Mobilna aplikacija "Mjesec po Mjesec" izrađena je u sklopu Završnog rada prijediplomskog studija na Fakultetu elektrotehnike i računarstva Sveučilišta u Zagrebu, ak. god. 2024./2025.''',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Svrha aplikacije je omogućiti korisnicima da na jednostavan i zanimljiv način savladaju mjesece u godini kretajući se kroz različita godišnja doba.",
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Implementacija: Lucija Lovrić\n"
            "Mentorstvo: prof. dr. sc. Željka Car, univ. mag. ing. comp. Ana Radović",
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          )
        ],),
      ),
    );
  }
}
