import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Feedback.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  bool _isButtonEnabled = false; // Button state
  late Timer _timer; // Timer to handle delay

  @override
  void initState() {
    super.initState();
    // Initialize the timer to enable the button after 5 seconds
    _timer = Timer(Duration(seconds: 5), () {
      setState(() {
        _isButtonEnabled = true;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFFFFFFFF),
        child: SingleChildScrollView(
          // Wrap the Column in SingleChildScrollView
          child: Padding(
            padding: EdgeInsets.only(
                top: screenHeight *
                    0.00), // Top padding relative to screen height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: screenHeight *
                          0.00), // Bottom margin relative to screen height
                  child: Container(
                    width: screenWidth * 0.3, // Adjusted width
                    height: screenHeight * 0.14, // Adjusted height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/logo.jpg'), // Replace with your asset path
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: screenHeight *
                          0.1), // Bottom margin relative to screen height
                  child: Text(
                    'Salahly Payments',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth *
                          0.06, // Font size relative to screen width
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth *
                        0.06), // Border radius relative to screen width
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xFFD3E5ED), Color(0xFFB7ACCD)],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: screenWidth * 0.07,
                        bottom: screenHeight *
                            0.01), // Padding relative to screen size
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              bottom: screenHeight *
                                  0.02), // Bottom margin relative to screen height
                          child: RichText(
                            text: TextSpan(
                              text: '     ',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth *
                                    0.1, // Font size relative to screen width
                                color: Color(0xFF000000),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Scan',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth *
                                        0.1, // Font size relative to screen width
                                    height: 2.2,
                                  ),
                                ),
                                TextSpan(
                                  text: ' To Confirm',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth *
                                        0.1, // Font size relative to screen width
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: screenHeight *
                                  0.01), // Bottom margin relative to screen height
                          child: Container(
                            width: screenWidth * 0.65, // Adjusted width
                            height: screenHeight * 0.33, // Adjusted height
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(screenWidth *
                                  0.06), // Border radius relative to screen width
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/qrcode.png'), // Replace with your asset path
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height:
                                screenHeight * 0.039), // Space from the bottom
                        Align(
                          alignment: Alignment
                              .bottomCenter, // Center the button horizontally
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: screenHeight *
                                    0.1), // Push button towards the bottom
                            child: ElevatedButton(
                              onPressed: _isButtonEnabled
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FeedbackPage(),
                                        ),
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isButtonEnabled
                                    ? Colors.purple
                                    : Colors.grey,
                                fixedSize: Size(
                                    screenWidth * 0.77,
                                    screenHeight *
                                        0.07), // Width and height relative to screen size
                              ),
                              child: Text(
                                'Go to Feedback',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth *
                                      0.05, // Font size relative to screen width
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
