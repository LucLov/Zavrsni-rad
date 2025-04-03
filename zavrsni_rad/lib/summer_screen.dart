import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: SummerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SummerScreen extends StatelessWidget {
  const SummerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          //_buildWinterPage(context),
          _buildSummerPage(context), // Add another page if you want to swipe to it
        ],
      ),
    );
  }

  Widget _buildSummerPage(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/summer_screen.png', // Replace with your image
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
                    "7. SRPANJ\n Ljetni praznici su u punom jeku, a često se baš srpanj i kolovoz smatraju najtoplijim mjesecima u godini.",
                    24),
              ),
              //const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: _buildBox(
                    "8. KOLOVOZ\n Vrijeme je žetve, a i početka berbe nekih voćnih kultura. \nŠto se tiče obale i otoka, sve vrvi od turista.",
                    24),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBox(
                    "9. RUJAN\n Jesen je na vidiku - dani su još uvijek topli, a noći postaju svježije. Đaci su ponovno krenuli u školske klupe.",
                    24),
              ),
              const SizedBox(height: 140),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color(0xFFFF3131),
                    ),
                  ),
                  child: const Text(
                    "Provježbaj znanje o ljetnim mjesecima!",
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
