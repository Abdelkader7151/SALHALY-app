import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'HomeScreen.dart';
import 'UserService.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class TrackingPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const TrackingPage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  String _getTimeRange() {
    final now = DateTime.now();
    final startTime = now.add(Duration(hours: 2));
    final endTime = startTime.add(Duration(minutes: 25));

    final dateFormat = DateFormat('h:mma');
    return '${dateFormat.format(startTime)}-${dateFormat.format(endTime)}';
  }

  Future<void> _cancelOrder() async {
    try {
      UserService userService = UserService();
      await userService
          .cancelActivePaymentsByName('${widget.firstName} ${widget.lastName}');

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Order Cancelled Successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Failed to cancel order: $e'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      print('Failed to cancel order: $e');
    }
  }

  // Method to handle phone call
  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Could not launch phone app.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Method to show the call confirmation dialog
  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make a Call'),
          content: Text('Do you want to call ${widget.phoneNumber}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _makePhoneCall(); // Make the phone call
              },
              child: Text('Call'),
            ),
          ],
        );
      },
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Add your functionality here
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF5C6ABD),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 20,
            child: Container(
              width: 385,
              height: 220,
              child: Image.asset(
                'assets/gif/salahly.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFD3E5ED), Color(0xFFB7ACCD)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Arrival',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD3E5ED),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x29787880),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Color(0xFFD62DBB),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _getTimeRange(),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        height: 1.4,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.firstName} is on his way',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/workers/${widget.firstName}${widget.lastName}.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showCallDialog(); // Show the call dialog
                          },
                          child: SizedBox(
                            width: 60,
                            height: 40,
                            child: Image.asset(
                              'assets/images/phone.png',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Remove the TextButton that was previously here
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                          child: Text(
                            'Return to Home Page',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color.fromARGB(255, 24, 2, 11),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: TextButton(
                            onPressed: () {
                              _cancelOrder();
                            },
                            child: Text(
                              'Cancel Order',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
