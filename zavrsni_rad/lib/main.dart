import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/naslovnica2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Positioned buttons at 3/4 of the screen height
            Positioned(
              top: MediaQuery.of(context).size.height * 0.65, 
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: 800,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[100],
                        foregroundColor: Color(0xFF9D3D25),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                          fontFamily: "Sans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        "Nauči i provježbaj znanje o mjesecima",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 800,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[100],
                        foregroundColor: Color(0xFF9D3D25),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(
                          fontFamily: "Sans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        "Ispitaj znanje o mjesecima",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info button (lower-left corner)
            Positioned(
              bottom: 20, // Adjust the bottom padding
              left: 20, // Adjust left padding
              child: IconButton(
                onPressed: () {
                  print("Info button pressed");
                },
                icon: Icon(Icons.info, size: 80, color: Color(0xFFA93741)), // ℹ️ Info icon
                tooltip: "Info",
              ),
            ),
            // Help button (lower-right corner)
            Positioned(
              bottom: 20, // Adjust bottom padding
              right: 20, // Adjust right padding
              child: IconButton(
                onPressed: () {
                  print("Help button pressed");
                },
                icon: Icon(Icons.help, size: 80, color: Color(0xFFA93741)), // ❓ Help icon
                tooltip: "Help",
              ),
            ),
            Positioned(
              top: 20, // Distance from the top
              right: 20, // Distance from the right
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), // Makes it round
                  padding: EdgeInsets.all(15), // Adds space inside the button
                  backgroundColor: Colors.grey[800], // Dark grey button
                ),
                child: Icon(Icons.settings, size: 40, color: Colors.white), // White settings icon
              ),
            ),
          ],
        ),
      ),
    );
  }
}