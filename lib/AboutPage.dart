import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0), // Uniform padding around the screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New Container widget with "About us" section
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 36),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF2A3A4B),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 19, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text Widget on the left
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Stop Complaining\n',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: Color(0xFFF3E6E6),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'About Things\n',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: Color(0xFFF3E6E6),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'We’re Capable Of\n',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: Color(0xFFF3E6E6),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Fixing',
                                      style: GoogleFonts.getFont(
                                        'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        color: Color(0xFFF3E6E6),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            // GIF Widget on the right
                            Container(
                              width: 132, // Adjust the width as needed
                              height: 150, // Adjust the height as needed
                              margin: EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/gif/fixing.gif', // Update with your GIF path
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // "About us" section
                  Container(
                    margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'About us',
                        style: GoogleFonts.getFont(
                          'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            // Description section directly following the "About us" section
            Container(
              margin: EdgeInsets.only(
                  top: 0, bottom: 20), // Remove extra space between sections
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Launched in 2024, the Fixing app was created to address the increasing need for accessible, reliable repair solutions across various domains. As our reliance on furniture, electronics, and mechanical systems grows, Fixing aims to empower users with the knowledge and tools needed to handle repairs and maintenance tasks efficiently. Our mission is to make repair and maintenance accessible, straightforward, and achievable for everyone. We believe that with the right resources and guidance, anyone can tackle repairs and extend the life of their furniture, electronics, and mechanical systems. By offering comprehensive instructions, expert advice, and a supportive community, we aim to revolutionize how people approach repair and maintenance tasks.',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF000000),
                ),
              ),
            ),

            SizedBox(height: 0), // Space between sections

            // Privacy Policy section
            Container(
              margin: EdgeInsets.only(bottom: 15), // Increased bottom margin
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'We are committed to protecting your privacy and ensuring a safe experience while using our app. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this policy carefully to understand our views and practices regarding your personal data and how we will treat it.',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF000000),
                ),
              ),
            ),

            SizedBox(height: 20), // Space between sections

            // Terms of Service section
            Container(
              margin: EdgeInsets.only(bottom: 15), // Increased bottom margin
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Terms of Service',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'By using the Salahly app, you agree to comply with and be bound by these Terms of Service. If you do not agree with any part of these terms, you must not use the app.',
                style: GoogleFonts.getFont(
                  'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
