import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserService.dart';
import 'ThankYouPage.dart'; // Import the ThankYouPage

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;
  late Future<Map<String, dynamic>?> _workerDataFuture;

  @override
  void initState() {
    super.initState();
    _workerDataFuture = _fetchWorkerData();
  }

  Future<Map<String, dynamic>?> _fetchWorkerData() async {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? '';
      if (email.isEmpty) {
        throw Exception('No logged-in user found.');
      }

      UserService userService = UserService();
      List<Map<String, dynamic>> payments =
          await userService.getActivePaymentsForUser(email);

      if (payments.isNotEmpty) {
        return payments.first;
      }
    } catch (e) {
      print('Error fetching worker data: $e');
    }
    return null;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
        title: Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _workerDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading worker data'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No worker data found'));
          }

          final workerData = snapshot.data!;
          final fullName = workerData['worker'] ?? 'Worker';
          final List<String> nameParts = fullName.split(' ');
          final String firstName =
              nameParts.isNotEmpty ? nameParts.first : 'Worker';
          final String lastName = nameParts.length > 1 ? nameParts.last : '';

          final String imagePath = 'assets/workers/${firstName}${lastName}.jpg';

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: screenWidth * 0.32,
                    height: screenWidth * 0.32,
                    child: workerData['worker'] != null
                        ? null
                        : Icon(
                            Icons.person,
                            size: screenWidth * 0.32,
                            color: Colors.grey,
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  '$firstName $lastName',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.05,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Rate your experience with $firstName $lastName',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.045,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Care to share more about it?',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.045,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    gradient: const LinearGradient(
                      colors: <Color>[
                        Color(0xFFD3E5ED),
                        Color(0x61B7ACCD),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  width: double.infinity,
                  height: screenHeight * 0.35,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: TextField(
                      controller: _feedbackController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write your feedback here...',
                        hintStyle: GoogleFonts.roboto(
                          color: Colors.black54,
                          fontSize: screenWidth * 0.045,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(212, 183, 224, 243),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Get the logged-in user's email
                        String email =
                            FirebaseAuth.instance.currentUser?.email ?? '';
                        if (email.isEmpty) {
                          throw Exception('No logged-in user found.');
                        }

                        // Get active payments for the user
                        UserService userService = UserService();
                        List<Map<String, dynamic>> payments =
                            await userService.getActivePaymentsForUser(email);

                        if (payments.isNotEmpty) {
                          String workerName = payments.first['worker'];
                          if (workerName != null) {
                            // Mark worker payments as "Past"
                            await userService
                                .markWorkerPaymentsAsPastByName(workerName);

                            // Save feedback to Firestore
                            await FirebaseFirestore.instance
                                .collection('feedbacks')
                                .add({
                              'email': email,
                              'worker': workerName,
                              'rating': _rating,
                              'feedback': _feedbackController.text,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            // Navigate to ThankYouPage
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const ThankYouPage(),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print('Error saving feedback: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.07),
                      ),
                      minimumSize: Size(screenWidth * 0.9, screenHeight * 0.08),
                    ),
                    child: Text(
                      'Publish Feedback',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.05,
                        color: const Color.fromARGB(255, 19, 7, 7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
