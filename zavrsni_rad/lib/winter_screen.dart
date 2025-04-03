import 'package:flutter/material.dart';
import 'spring_screen.dart';
import 'summer_screen.dart';
import 'fall_screen.dart';

void main() {
  runApp(MaterialApp(
    home: WinterScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class WinterScreen extends StatelessWidget {
  const WinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          _buildWinterPage(context),
          SpringScreen(),
          SummerScreen(), 
          FallScreen(),// Add another page if you want to swipe to it
        ],
      ),
    );
  }

  Widget _buildWinterPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/winter_screen.png', // Replace with your image
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
                    "1. SIJEČANJ\n Sa siječnjem započinjemo novu godinu. Tada dane najčešće provodimo odmarajući se i uživajući u zimskim radostima s obitelji i prijateljima.",
                    24),
              ),
              //const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    "2. VELJAČA\n U veljači obilježavamo Maškare kada oblačimo razne kostime i Dan zaljubljenih koji provodimo s onima koje volimo.\nOvo je najkraći mjesec - najčešće ima 28 dana, a svake četvrte godine dan više.",
                    24),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    "3. OŽUJAK\n Proljetni vjesnici najavljuju dolazak sunčanih dana, a i samo proljeće kreće krajem mjeseca.",
                    24),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color(0xFF004AAD),
                    ),
                  ),
                  child: const Text(
                    "Provježbaj znanje o zimskim mjesecima!",
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
