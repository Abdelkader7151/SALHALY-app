import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_application/services/database.dart';
import 'package:random_string/random_string.dart';
import 'login.dart'; // Ensure this import is correct

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _regionController = TextEditingController();
  final _addressController = TextEditingController(); // Address controller

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileNumberController.dispose();
    _regionController.dispose();
    _addressController.dispose(); // Dispose the address controller
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validate password length
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 8 characters long')),
      );
      return;
    }

    // Validate that passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Validate mobile number length and that it contains only numbers
    if (_mobileNumberController.text.length != 11 ||
        !_mobileNumberController.text.contains(RegExp(r'^[0-9]+$'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Mobile number must be 11 digits and contain only numbers')),
      );
      return;
    }

    try {
      // Create user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Generate a random ID for Firestore document
      String id = randomAlphaNumeric(10);

      // Prepare user info map for Firestore, including 'profilenormal' as photo
      Map<String, dynamic> userInfoMap = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "mobileNumber": _mobileNumberController.text,
        "region": _regionController.text,
        "address": _addressController.text, // Include the address
        "email": _emailController.text,
        "id": id,
        "photo": "profilenormal", // Add 'profilenormal' as photo
      };

      // Add user details to Firestore using your database service
      await DatabaseMethods().addUserDetails(userInfoMap, id).then((value) {});

      // Create an initial document in the 'paymentHistory' subcollection
      Map<String, dynamic> initialPaymentHistory = {
        "category": "Initial Category",
        "cost": 0,
        "date": DateTime.now(),
        "fixed": false,
        "worker": "Initial Worker"
      };

      // Add the initial document to the 'paymentHistory' subcollection within the user's document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid) // Use the UID of the created user
          .collection('paymentHistory')
          .add(initialPaymentHistory);

      // Notify user of success and navigate to login screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account: ${e.message}')),
      );
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
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
              const SizedBox(height: 100), // Push image down by 100 pixels
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

              // Sign-up form
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.3,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFD3E5ED), // Lighter shade
                      Color(0x61B7ACCD), // Darker shade with 38% opacity
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
                child: Column(
                  children: [
                    _buildTransparentTextField(
                        "Enter First Name", _firstNameController),
                    const SizedBox(height: 15),
                    _buildTransparentTextField(
                        "Enter Last Name", _lastNameController),
                    const SizedBox(height: 15),
                    _buildTransparentTextField(
                        "Enter Mobile Number", _mobileNumberController),
                    const SizedBox(height: 15),
                    _buildTransparentTextField(
                        "Enter Region", _regionController),
                    const SizedBox(height: 15),
                    _buildTransparentTextField(
                        "Enter Address", _addressController), // Address field
                    const SizedBox(height: 15),
                    _buildTransparentTextField("Enter Email", _emailController),
                    const SizedBox(height: 15),
                    _buildTransparentTextField(
                      "Enter Password",
                      _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    _buildTransparentTextField(
                      "Confirm Password",
                      _confirmPasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 193, 101, 209), // Background color
                        foregroundColor: Colors.white, // Text color
                        elevation: 0, // Remove shadow for flat look
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(19), // Rounded corners
                        ),
                        fixedSize: const Size(266, 46), // Button size
                      ),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 193, 101, 209),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
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

  // Transparent TextField Widget
  Widget _buildTransparentTextField(
      String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0x80FFFFFF), // White with 50% opacity
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: InputBorder.none,
          hintText: label,
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 40,
    );
  }
}
