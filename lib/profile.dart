import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomeScreen.dart';
import 'main.dart';
import 'QrCodePage.dart';
import 'PaymentHistory.dart';
import 'PromoCodes.dart';
import 'AboutPage.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  Map<String, dynamic>? userData;
  int orderCount = 0;

  @override
  void initState() {
    super.initState();
    _getUser();
    _getOrderStats();
  }

  void _getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      user = currentUser;
    });

    if (user != null) {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: user?.email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      } else {
        print('No user data found for this email.');
        // Optionally show a message to the user or handle the case where no user is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user data found for this email.')),
        );
      }
    }
  }

  void _getOrderStats() async {
    if (user != null) {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('paymentHistory')
          .where('email', isEqualTo: user!.email)
          .get();

      // Check if the snapshot has any documents
      if (orderSnapshot.docs.isNotEmpty) {
        setState(() {
          orderCount = orderSnapshot.docs.length;
        });
      } else {
        print('No orders found for this user.');
        // Optionally show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No orders found for this user.')),
        );
        setState(() {
          orderCount =
              0; // Explicitly set the orderCount to 0 if no orders are found
        });
      }
    }
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyWidget(), // Navigate to MyWidget() on logout
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
  }

  void _saveProfile(String firstName, String lastName, String region,
      String mobileNumber) async {
    try {
      // Update the Firestore document using the user's UID
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .update({
        'firstName': firstName,
        'lastName': lastName,
        'region': region,
        'mobileNumber': mobileNumber,
      });

      // Show a confirmation message after successful update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      // Optionally close the dialog if the update is successful
      Navigator.of(context).pop();
    } catch (e) {
      // Catch any errors and display them
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  void _openEditProfileDialog() {
    String firstName = userData?['firstName'] ?? '';
    String lastName = userData?['lastName'] ?? '';
    String region = userData?['region'] ?? '';
    String mobileNumber = userData?['mobileNumber'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    firstName = value;
                  },
                  decoration: InputDecoration(labelText: 'First Name'),
                  controller: TextEditingController(text: firstName),
                ),
                TextField(
                  onChanged: (value) {
                    lastName = value;
                  },
                  decoration: InputDecoration(labelText: 'Last Name'),
                  controller: TextEditingController(text: lastName),
                ),
                TextField(
                  onChanged: (value) {
                    region = value;
                  },
                  decoration: InputDecoration(labelText: 'Region'),
                  controller: TextEditingController(text: region),
                ),
                TextField(
                  onChanged: (value) {
                    mobileNumber = value;
                  },
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  controller: TextEditingController(text: mobileNumber),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                // Call the method to save the profile data when confirmed
                _saveProfile(firstName, lastName, region, mobileNumber);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchSupportURL() async {
    const url = 'https://support.google.com/?hl=en-GB';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // Make the whole page scrollable
              child: Column(
                children: [
                  // First Part: Curved Header with Gradient Background and AppBar
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipPath(
                        clipper: CurveClipper(),
                        child: Container(
                          width: double.infinity,
                          height: screenHeight * 0.34, // Responsive height
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFD3E5ED), Color(0x61B7ACCD)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              leading: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.05,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              },
                              child: Image.asset(
                                'assets/images/logo.jpg',
                                width: screenWidth * 0.25,
                                height: screenHeight * 0.1,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'User Profile',
                              style: TextStyle(
                                fontSize: screenHeight * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Profile Photo Container
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.001),
                    child: CircleAvatar(
                      radius: screenWidth * 0.19, // Responsive radius
                      backgroundImage: AssetImage(
                          'assets/users/${userData?['photo'] ?? 'profilenormal'}.jpg'),
                    ),
                  ),
                  // Second Part: User Information and Statistics Container
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.0001),
                    child: Column(
                      children: [
                        Text(
                          '${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? ''}',
                          style: TextStyle(
                            fontSize: screenHeight * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF242760),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.003),
                        Text(
                          '${userData?['mobileNumber'] ?? ''}',
                          style: TextStyle(
                            fontSize: screenHeight * 0.02,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Colors.purple),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              '${userData?['region'] ?? ''}',
                              style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                                '$orderCount', 'Orders', screenHeight),
                            _buildStatItem(
                              '${orderCount > 1 ? orderCount - 1 : 1}',
                              'Following',
                              screenHeight,
                            ),
                            _buildStatItem(
                              '${orderCount > 1 ? orderCount - 1 : 1}',
                              'Ratings',
                              screenHeight,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton('QR Code', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QrCodePage()),
                              );
                            }, screenHeight, screenWidth),
                            _buildButton('Past orders', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentHistory()),
                              );
                            }, screenHeight, screenWidth),
                          ],
                        ),
                        // Third Part: Account Settings and Support
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildAccountOption(Icons.person, 'Edit profile',
                                  _openEditProfileDialog),
                              _buildAccountOption(
                                  Icons.notifications, 'Notifications', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              }),
                              _buildAccountOption(Icons.lock, 'Privacy', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutPage()),
                                );
                              }),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Support & About',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildAccountOption(
                                  Icons.subscriptions, 'My Subscription', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PromoCodePage()),
                                );
                              }),
                              _buildAccountOption(Icons.help, 'Help & Support',
                                  _launchSupportURL),
                              _buildAccountOption(
                                  Icons.policy, 'Terms and Policies', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutPage()),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Log out Button at the very bottom of the screen
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: _buildButton(
                        'Log out', _confirmSignOut, screenHeight, screenWidth),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String number, String label, double screenHeight) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Changed to black for visibility
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountOption(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(label),
      onTap: onTap,
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, double screenHeight,
      double screenWidth) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.014,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.016),
      ),
    );
  }
}

// Custom Clipper for Curved Path
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);

    double curveCenterX = size.width * 0.5;
    double curveWidth = size.width * 0.6;
    double curveHeight = 200;

    path.lineTo(curveCenterX - curveWidth / 2, size.height);

    path.quadraticBezierTo(
      curveCenterX,
      size.height - curveHeight,
      curveCenterX + curveWidth / 2,
      size.height,
    );

    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
