import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'HomeScreen.dart';
import 'tracking.dart'; // Ensure you have the correct path
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final String category;
  final String workerName;
  final String? address; // Optional parameter
  final String? deliveryInfo; // Optional parameter
  final String workerPhoneNumber; // Added workerPhoneNumber parameter

  const PaymentPage({
    super.key,
    required this.category,
    required this.workerName,
    this.address,
    this.deliveryInfo,
    required this.workerPhoneNumber, // Added workerPhoneNumber parameter
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  bool _isCreditDetailsVisible = false;
  String? _userName;
  String? _userAddress; // To hold the user input address
  String _errorMessage = ''; // Error message if order is running
  final TextEditingController _voucherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserName();
    _userAddress = widget.address; // Initialize with the passed address, if any
  }

  void _getUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: currentUser.email)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);

        if (userDoc.exists) {
          setState(() {
            _userName = '${userDoc['firstName']} ${userDoc['lastName']}';
            _userAddress = '${userDoc['address']}';
          });
        } else {
          print('No user data found for this user.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  void _showAddressBottomSheet() {
    TextEditingController addressController =
        TextEditingController(text: _userAddress);

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Ensures the bottom sheet adjusts when the keyboard is visible
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Address',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _userAddress = addressController.text;
                    });
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreditCardBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Ensures the bottom sheet adjusts when the keyboard is visible
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Credit Card Info',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Cardholder Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Expiration Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedPaymentMethod = 'Credit';
                    });
                  },
                  child: Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkWorkerActive(String workerName) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Query paymentHistory where workerName matches and state is 'Active'
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('paymentHistory')
            .where('workerName', isEqualTo: widget.workerName)
            .where('state', isEqualTo: 'Active')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If any active order is found, return true
          return true;
        }
      } catch (e) {
        print('Error checking for active order: $e');
      }
    }
    return false; // No active order found
  }

  // Check for active orders
  Future<bool> _checkForActiveOrder() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Query paymentHistory where email matches and state is 'Active'
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('paymentHistory')
            .where('email', isEqualTo: currentUser.email)
            .where('state', isEqualTo: 'Active')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If any active order is found, return true
          return true;
        }
      } catch (e) {
        print('Error checking for active order: $e');
      }
    }
    return false; // No active order found
  }

  void _confirmPayment() async {
    // Check for active orders before proceeding
    bool hasActiveOrder = await _checkForActiveOrder();

    // Check if the worker is active
    bool isWorkerActive = await checkWorkerActive(widget.workerName);

    if (hasActiveOrder) {
      // If there's an active order, show the error message
      setState(() {
        _errorMessage =
            "Can't make order because another order is running right now";
      });
    } else if (isWorkerActive) {
      // If the worker is busy, show the error message
      setState(() {
        _errorMessage = "This worker is busy right now";
      });
    } else {
      // No active order and the worker is not busy, proceed with normal payment actions
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        int cost = Random().nextInt(701) + 100;

        List<String> electricalOptions = [
          "Air Conditioner",
          "Refrigerator",
          "Dishwasher",
          "Microwave",
          "Gas Heater",
          "Electric Heater"
        ];
        List<String> mechanicalOptions = [
          "Motor",
          "Battery",
          "Electro Mechanics",
          "Gearbox",
          "Clutch"
        ];
        List<String> furnitureOptions = [
          "Sofa",
          "Recliner",
          "Table",
          "Coffee Corner",
          "Bed"
        ];

        String fixing;
        switch (widget.category) {
          case 'electrical':
            fixing = (electricalOptions..shuffle()).first;
            break;
          case 'mechanical':
            fixing = (mechanicalOptions..shuffle()).first;
            break;
          case 'furniture':
            fixing = (furnitureOptions..shuffle()).first;
            break;
          default:
            fixing = 'Unknown';
        }

        Map<String, dynamic> paymentData = {
          'email': currentUser.email,
          'cost': cost,
          'category': widget.category,
          'timestamp': Timestamp.now(),
          'paymentMethod': _selectedPaymentMethod ?? 'Unknown',
        };

        try {
          await FirebaseFirestore.instance
              .collection('paymentHistory')
              .doc(currentUser.email)
              .collection('payments')
              .add(paymentData);
          print('Payment data saved successfully.');
        } catch (e) {
          print('Error saving payment data: $e');
        }

        try {
          await FirebaseFirestore.instance
              .collection('paymentHistory')
              .doc()
              .set({
            'category': widget.category,
            'cost': cost.toString(),
            'date': DateFormat('d/M/y').format(DateTime.now()),
            'email': currentUser.email!,
            'fixing': fixing,
            'state': 'Active', // Set the state to 'Active'
            'time': DateFormat('H:m:s').format(DateTime.now()),
            'worker': widget.workerName,
          });
          print('Additional payment data saved successfully.');
        } catch (e) {
          print('Error saving additional payment data: $e');
        }

        String getSubstringFromSpace(String str) {
          int spaceIndex = str.indexOf(' ');
          if (spaceIndex != -1) {
            return str.substring(spaceIndex + 1);
          } else {
            return '';
          }
        }

        String getSubstringUntilSpace(String str) {
          int spaceIndex = str.indexOf(' ');
          if (spaceIndex != -1) {
            return str.substring(0, spaceIndex);
          } else {
            return str;
          }
        }

        // Navigate to TrackingPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackingPage(
              firstName: getSubstringUntilSpace(widget.workerName),
              lastName: getSubstringFromSpace(widget.workerName),
              phoneNumber: widget.workerPhoneNumber,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double padding = width * 0.02;
    final double imageHeight = height * 0.2;
    final double fontSizeHeader = width * 0.06;
    final double fontSizeSubHeader = width * 0.05;
    final double fontSizeBody = width * 0.04;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the layout adjusts when keyboard opens
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
        // Makes the screen scrollable when the keyboard appears
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: height * 0.001, bottom: height * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/map.jpg'),
                  ),
                ),
                width: double.infinity,
                height: imageHeight,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.02),
                child: Text(
                  'Add your address',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: fontSizeHeader,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                widget.deliveryInfo ?? 'The worker is 50 mins away from you',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: fontSizeBody,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: height * 0.01),
              GestureDetector(
                onTap: _showAddressBottomSheet,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: height * 0.03, top: height * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 233, 237, 240),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(padding),
                    title: Text(
                      'Delivery Information',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSizeSubHeader,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName ?? 'Loading...',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: fontSizeBody,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _userAddress ?? 'Default Address',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: fontSizeBody,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 0, bottom: 20), // Adjust top and bottom padding
                child: SizedBox(
                  height: 35, // Adjust the total height of the container
                  child: Text(
                    'Payment Methods',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: fontSizeHeader,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'Credit';
                        _isCreditDetailsVisible = true;
                      });
                      _showCreditCardBottomSheet();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _selectedPaymentMethod == 'Credit'
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment(-1, 0),
                          end: Alignment(1, 0),
                          colors: [Color(0xFFD3E5ED), Color(0xFFB7ACCD)],
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10)
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(padding),
                        title: Text(
                          'Credit Payment',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSizeSubHeader,
                            color: Colors.black,
                          ),
                        ),
                        leading: Icon(Icons.credit_card),
                        trailing: _selectedPaymentMethod == 'Credit'
                            ? Icon(Icons.check_circle, color: Colors.blue)
                            : null,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'Cash';
                        _isCreditDetailsVisible = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: height * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _selectedPaymentMethod == 'Cash'
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment(-1, 0),
                          end: Alignment(1, 0),
                          colors: [Color(0xFFD3E5ED), Color(0xFFB7ACCD)],
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10)
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(padding),
                        title: Text(
                          'Cash Payment',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSizeSubHeader,
                            color: Colors.black,
                          ),
                        ),
                        leading: Icon(Icons.money),
                        trailing: _selectedPaymentMethod == 'Cash'
                            ? Icon(Icons.check_circle, color: Colors.blue)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.01),

              // TextField with Image as Prefix Icon
              TextField(
                controller: _voucherController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Image.asset(
                      'assets/images/coupons.jpg',
                      width: 24, // Adjust the width as needed
                      height: 24, // Adjust the height as needed
                    ),
                  ),
                  labelText: 'Enter your voucher',
                  labelStyle: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),

              // Error message if order is running
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              ElevatedButton(
                onPressed: _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(width, height * 0.07),
                ),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSizeHeader,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
