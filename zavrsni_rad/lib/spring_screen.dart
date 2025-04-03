import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: SpringScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SpringScreen extends StatelessWidget {
  const SpringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          //_buildWinterPage(context),
          _buildSpringPage(context), // Add another page if you want to swipe to it
        ],
      ),
    );
  }

  Widget _buildSpringPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/spring_screen.png', // Replace with your image
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.topRight,
                child: _buildBox(
                    "4. TRAVANJ\n Prvi dan ovog mjesec poznatiji je kao Dan šale - stoga nemoj zaboraviti nasamariti nekoga!\nInače, u travnju najčešće slavimo Uskrs i bojamo pisanice.",
                    24),
              ),
              //const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    "5. SVIBANJ\n Ovaj mjesec je obilježen vedrim proljetnim vremenom koje iskorištavamo provodeći dane u prirodi.",
                    24),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    "6. LIPANJ\n Najdulji dan u godini i početak ljeta padaju krajem ovog mjeseca. Škola završava, a polako se ide i na ljetovanje.",
                    24),
              ),
              const SizedBox(height: 125),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color(0xFFFF5757),
                    ),
                  ),
                  child: const Text(
                    "Provježbaj znanje o proljetnim mjesecima!",
                    style: TextStyle(
                      fontSize: 24, // Set the font size
                      color: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBox(String text, double fontSize) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 200,
        maxWidth: 480,
      ),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent, // Make background fully transparent
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
