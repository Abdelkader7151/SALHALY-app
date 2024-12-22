import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'HomeScreen.dart'; // Import the HomePage

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  double _rating = 0; // Initialize rating

  // Define customizable colors
  final Color gradientStartColor1 = Color.fromARGB(255, 38, 68, 150);
  final Color gradientEndColor1 = Color.fromARGB(255, 96, 209, 212);
  final Color gradientStartColor2 = Color.fromARGB(211, 172, 218, 240);
  final Color gradientEndColor2 = Color.fromARGB(211, 172, 218, 240);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image positioned at the very top
            Container(
              margin: EdgeInsets.only(top: 5), // No margin from the top
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/gif/repairr.gif',
                  width: width * 0.85, // Responsive width
                  height: height * 0.20, // Responsive height
                  fit: BoxFit.cover, // Fit the image properly
                ),
              ),
            ),
            // Text in the center with gradient
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: height * 0.06), // Responsive spacing
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: <Color>[gradientStartColor1, gradientEndColor1],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Thank You For Choosing Salahly',
                        textAlign: TextAlign.center, // Center text horizontally
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.08, // Responsive font size
                          color: Colors
                              .white, // Text color is set to white to see the gradient
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02), // Responsive space
                  Text(
                    'Rate the App',
                    textAlign: TextAlign.center, // Center text horizontally
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.06, // Responsive font size
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.02), // Responsive padding
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.02), // Responsive padding
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating; // Store the rating value
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Button at the bottom center with gradient matching the text
            Padding(
              padding: EdgeInsets.all(width * 0.05), // Responsive padding
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const HomePage(), // Navigate to HomePage
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        width * 0.05), // Responsive border radius
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[gradientStartColor2, gradientEndColor2],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.02), // Responsive padding
                  child: Center(
                    child: Text(
                      'Return to Home Page',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: width * 0.05, // Responsive font size
                        color: Color.fromARGB(255, 10, 9,
                            9), // Ensure text is visible against gradient
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
