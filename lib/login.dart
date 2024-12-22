import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updatePaymentHistory(String email) async {
    try {
      QuerySnapshot paymentHistorySnapshot = await _firestore
          .collection('paymentHistory')
          .where('email', isEqualTo: email)
          .get();

      for (var doc in paymentHistorySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Extract the date and time from the document
        String dateString = data['date'] ?? '';
        String timeString = data['time'] ?? '';

        if (dateString.isNotEmpty && timeString.isNotEmpty) {
          try {
            // Parse the date and time strings
            DateTime paymentDateTime = _parseDateTime(dateString, timeString);
            DateTime now = DateTime.now();

            // Compare the current time with the payment time
            Duration difference = now.difference(paymentDateTime);

            // Check if the difference is greater than 2 hours and update the state
            if (difference.inHours >= 2) {
              if (data['state'] != 'Cancelled') {
                await doc.reference
                    .update({'state': 'Past'}); // Update state to 'Past'
              }
            }
          } catch (e) {
            print("Error parsing date/time: $e");
          }
        }
      }
    } catch (e) {
      print("Error updating payment history: $e");
    }
  }

  DateTime _parseDateTime(String dateString, String timeString) {
    // Split the date and time strings into their components
    List<String> dateParts = dateString.split('/');
    List<String> timeParts = timeString.split(':');

    // Ensure the date and time parts have the expected number of elements
    if (dateParts.length != 3 || timeParts.length != 3) {
      throw FormatException("Invalid date or time format");
    }

    // Convert the date and time parts to integers
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    int second = int.parse(timeParts[2]);

    // Create a DateTime object using the parsed values
    return DateTime(year, month, day, hour, minute, second);
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Update payment history for the logged-in user
      await _updatePaymentHistory(userCredential.user!.email!);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add a SizedBox to create space above the image
              const SizedBox(height: 100),

              // First part: Logo and title
              Image.asset(
                'assets/images/logo.jpg',
                height: 190,
              ),
              const SizedBox(height: 20),
              const Text(
                'SALAHLY',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Second part: Email, Password, Sign In Button, and Forgot Password
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.3,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0xFFD3E5ED), // Lighter shade
                      Color(0x61B7ACCD), // Darker shade with 38% opacity
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment:
                          Alignment.centerLeft, // Aligns the text to the left
                      child: GestureDetector(
                        onTap: () {
                          // Handle forgot password
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200, // Adjust the width as necessary
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(
                              0x616104F8), // Purple with 38% opacity
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
