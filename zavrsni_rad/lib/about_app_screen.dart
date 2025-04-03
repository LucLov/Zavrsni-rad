import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Informacije o aplikaciji",
        style: TextStyle(fontSize: 30)),
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
        child: SingleChildScrollView (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Optional, depending on the layout you want
            children: [
              Text(
                '''Ova je mobilna aplikacija zasnovana na principu "Različitih načina reprezentacije" Univerzalnog dizajna za učenje (Universal Design in Learning, UDL) kako bi pružila interaktivno i personalizirano obrazovno iskustvo pri učenju mjeseca u godini.''',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                '''Namijenjena je široj publici što uključuje djecu, osobe s poteškoćama te učenike hrvatskog i engleskog jezika.''',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                '''Ova ozbiljna igra je zamišljena da korisnika vodi kroz 3 različite faze: učenje o mjesecima, vježbanje i ispitivanje znanja o mjesecima.''',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Optional space between text blocks
              Text(
                '''Korisnik će kroz sekvencijalni pristup naučiti o mjesecima unutar svakog godišnjeg doba (zima, proljeće, ljeto, jesen). Nakon učenja o mjesecima u godišnjem dobu, to znanje će se i provježbati jednostavnom igrom povezivanja pojmova. Kada se korisnik upozna sa svim mjesecima, imat će mogućnost ispitati stečeno znanje u obliku kviza. Korisniku će se na kraju kviza ispisati njegov rezultat.''',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),),
      ),
    );
  }
}
