import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart'; // Import the LoginPage class
import 'signup.dart'; // Import the SignUpScreen class
import 'dart:async'; // To handle the delay for splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to the main screen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyWidget()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg'), // Your logo image
            const SizedBox(height: 20), // Space between logo and text
            const Text(
              'SALAHLY',
              style: TextStyle(
                fontFamily: 'Major Mono Display',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset(
                        'assets/images/logo.jpg',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 20, 0, 300),
                    child: const Text(
                      'SALAHLY',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(29)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFFD3E5ED), Color(0x61B7ACCD)],
                  stops: <double>[0, 1],
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.45,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.15,
            child: GestureDetector(
              onTap: () {
                print("Sign up button tapped"); // Debugging print statement
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 193, 101, 209),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: SizedBox(
                  width: 266,
                  height: 46,
                  child: Center(
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        height: 1.6,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            left: MediaQuery.of(context).size.width * 0.1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: RichText(
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
                        color: Color.fromARGB(
                            255, 193, 101, 209), // Highlight the "Login" text
                        decoration: TextDecoration
                            .underline, // Optional: underline the text
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage()), // Remove const
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: const Text(
              'All the services you need, right at your fingertips.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                height: 1.3,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
