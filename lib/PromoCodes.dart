import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoCodePage extends StatefulWidget {
  const PromoCodePage({super.key});

  @override
  _PromoCodePageState createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
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
        title: Text(
          'Promo Codes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Uniform padding around the screen
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Code 1
              Container(
                margin: EdgeInsets.only(bottom: 16), // Adjust bottom margin
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 6),
                      constraints: BoxConstraints(
                        maxWidth: 49,
                        maxHeight: 41,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/coupons.jpg',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '20% OFF',
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xFF000000),
                              ),
                              children: [
                                TextSpan(
                                  text: 'VALID UNTIL ',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                                TextSpan(
                                  text: 'December 2025',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Promo Code 2
              Container(
                margin: EdgeInsets.only(bottom: 16), // Adjust bottom margin
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 6, bottom: 4),
                      constraints: BoxConstraints(
                        maxWidth: 49,
                        maxHeight: 41,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/coupons.jpg',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10% OFF',
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                              children: [
                                TextSpan(
                                  text: 'VALID UNTIL ',
                                ),
                                TextSpan(
                                  text: 'July 2025',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Promo Code 3
              Container(
                margin: EdgeInsets.only(bottom: 20), // Adjust bottom margin
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 6, bottom: 4),
                      constraints: BoxConstraints(
                        maxWidth: 49,
                        maxHeight: 41,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/coupons.jpg',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '10% OFF',
                            style: GoogleFonts.getFont(
                              'Inter',
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.getFont(
                                'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Expired on ',
                                ),
                                TextSpan(
                                  text: 'June 2024',
                                  style: GoogleFonts.getFont(
                                    'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
