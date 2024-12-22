import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserService.dart'; // Import the UserService class
import 'Tracking.dart'; // Import the TrackingPage class

class PaymentHistory extends StatefulWidget {
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService =
      UserService(); // Create an instance of UserService

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';

  Future<List<Map<String, dynamic>>> retrievePaymentHistory() async {
    List<Map<String, dynamic>> paymentHistory = [];

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        QuerySnapshot paymentHistorySnapshot = await _firestore
            .collection('paymentHistory')
            .where('email', isEqualTo: user.email)
            .get();

        for (var doc in paymentHistorySnapshot.docs) {
          paymentHistory.add(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Error retrieving payment history: $e");
    }

    return paymentHistory;
  }

  Future<void> fetchActivePaymentDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      Map<String, String> paymentDetails =
          await _userService.getActivePaymentDetailsByEmail(user.email!);

      setState(() {
        String fullName = paymentDetails['name'] ?? '';
        List<String> nameParts = fullName.split(' ');
        firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        phoneNumber = paymentDetails['phoneNumber'] ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchActivePaymentDetails(); // Load payment details on init
  }

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
          'Payment History',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Add your functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Payment History List Section
            FutureBuilder<List<Map<String, dynamic>>>(
              future: retrievePaymentHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No payment history found'));
                }

                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> paymentData = snapshot.data![index];
                    String state = paymentData['state'] ?? 'Unknown';

                    Color getStateColor() {
                      if (state == 'Active') {
                        return Colors.green;
                      } else if (state == 'Cancelled') {
                        return Colors.red;
                      } else {
                        return Colors.black;
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        if (state == 'Active') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackingPage(
                                firstName: firstName,
                                lastName: lastName,
                                phoneNumber: phoneNumber,
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category: ${paymentData['category'] ?? 'Unknown'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 193, 101, 209),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Ordered on: ${paymentData['date'] ?? 'Unknown'} at ${paymentData['time'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                if (state != 'Active' &&
                                    state != 'Cancelled') ...[
                                  SizedBox(height: 8),
                                  Text(
                                    'Cost: ${paymentData['cost'] ?? 'Unknown'}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                                SizedBox(height: 8),
                                Text(
                                  'Fixing: ${paymentData['fixing'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Worker: ${paymentData['worker'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'State: $state',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: getStateColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
