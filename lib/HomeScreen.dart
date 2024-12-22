import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'CategoryPage.dart';
import 'profile.dart';
import 'workersList.dart';
import 'PaymentHistory.dart';
import 'AboutPage.dart';
import 'PromoCodes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserService.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                height: screenHeight * 0.06, // Responsive height for logo
              ),
              SizedBox(width: screenWidth * 0.04), // Responsive spacing
              Text(
                'SALAHLY',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  _showNotificationsMenu(context);
                },
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
              ),
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        drawer: _buildSideMenu(screenWidth, screenHeight, context),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFFD3E5ED), // Lighter shade
                Color(0x61B7ACCD), // Darker shade with 38% opacity
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: [
                    Image.asset('assets/images/photo1.jpg'),
                    Image.asset('assets/images/photo2.jpg'),
                    Image.asset('assets/images/photo3.jpg'),
                    Image.asset('assets/images/photo4.jpg'),
                    Image.asset('assets/images/photo5.jpg'),
                    Image.asset('assets/images/photo6.jpg'),
                  ],
                  options: CarouselOptions(
                    height:
                        screenHeight * 0.4, // Responsive height for Carousel
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: screenWidth / screenHeight,
                    viewportFraction: 0.99,
                  ),
                ),
                SizedBox(height: screenHeight * 0.001), // Responsive spacing
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04), // Responsive padding
                  child: const Text(
                    'Quick Access',
                    style: TextStyle(
                      fontSize: 24, // Adjust font size if necessary
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAccessItem('AC', 'assets/images/ac.jpg', context,
                        'WorkerListPage1'),
                    _buildQuickAccessItem(
                        'Furniture',
                        'assets/images/furniture.jpg',
                        context,
                        'WorkerListPage3'),
                    _buildQuickAccessItem('Gas', 'assets/images/gas.jpg',
                        context, 'WorkerListPage1'),
                    _buildQuickAccessItem('Motor', 'assets/images/motor.jpg',
                        context, 'WorkerListPage2'),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04), // Responsive padding
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24, // Adjust font size if necessary
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                _buildCategoryRow(context),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Contact Us: ',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.02), // Spacing between text and icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.envelope,
                                  color: Colors.red),
                              onPressed: _launchEmail,
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.02), // Spacing between icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.facebook,
                                  color: Colors.blue),
                              onPressed: () {
                                _launchURL('https://www.facebook.com');
                              },
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.02), // Spacing between icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.xTwitter,
                                  color: Colors.black),
                              onPressed: () {
                                _launchURL('https://twitter.com');
                              },
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.02), // Spacing between icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.linkedin,
                                  color: Colors.blue),
                              onPressed: () {
                                _launchURL('https://www.linkedin.com');
                              },
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.02), // Spacing between icons
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.instagram,
                                  color: Colors.pink),
                              onPressed: () {
                                _launchURL('https://www.instagram.com');
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.003), // Spacing between icons and text
                        Text(
                          'All terms and conditions apply.',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Responsive spacing
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'Salahly@gmail.com',
      query: 'subject=App Inquiry&body=Hello', // Optional parameters
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

void _navigateToCategoryPage(BuildContext context, int categoryNumber) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => CategoryPage(categoryNumber: categoryNumber),
    ),
  );
}

Widget _buildSideMenu(
    double screenWidth, double screenHeight, BuildContext context) {
  final UserService userService = UserService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  return Drawer(
    child: Container(
      margin: EdgeInsets.only(top: screenHeight * 0.01),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: currentUser != null
                ? userService.getUserDataByEmail(currentUser.email!)
                : Future.error('User not logged in'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(child: Text('Error loading user data')),
                );
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(child: Text('No user data found')),
                );
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final firstName = userData['firstName'] ?? 'User';
              final lastName = userData['lastName'] ?? '';
              final String photo =
                  userData['photo'] ?? 'profilenormal'; // Fallback if no photo

              return DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          screenWidth * 0.001), // Add padding to the sides
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align all items to the left
                    children: [
                      // Circular photo container
                      Container(
                        width: screenWidth * 0.15, // Adjust width as needed
                        height: screenWidth *
                            0.14, // Make it a circle by using the same width and height
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Circular shape for image
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/users/${photo}.jpg', // Dynamic photo
                            ),
                            fit: BoxFit.cover, // Cover the entire circle
                          ),
                        ),
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.004), // Space between photo and name
                      // Name text
                      Text(
                        '$firstName $lastName',
                        style: TextStyle(
                          fontSize: screenWidth * 0.037, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242760),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.0001), // Space between name and region
                      // Region text
                      Text(
                        '${userData['region'] ?? 'region'}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.027, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF242760),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.006), // Space between region and 'Menu'
                      // Menu text
                      Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03, // Responsive font size
                          color: Color(0xFF242760),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.category, size: screenWidth * 0.07),
            title: Text('Categories',
                style: TextStyle(fontSize: screenWidth * 0.05)),
            children: <Widget>[
              ListTile(
                title: Text('Electrical'),
                onTap: () {
                  _navigateToCategoryPage(context, 1);
                },
              ),
              ListTile(
                title: Text('Mechanical'),
                onTap: () {
                  _navigateToCategoryPage(context, 2);
                },
              ),
              ListTile(
                title: Text('Furniture'),
                onTap: () {
                  _navigateToCategoryPage(context, 3);
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.payment, size: screenWidth * 0.07),
            title: Text('Payment History',
                style: TextStyle(fontSize: screenWidth * 0.05)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentHistory(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, size: screenWidth * 0.07),
            title: Text('About Us',
                style: TextStyle(fontSize: screenWidth * 0.05)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer, size: screenWidth * 0.07),
            title: Text('Promo Codes',
                style: TextStyle(fontSize: screenWidth * 0.05)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PromoCodePage(),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildQuickAccessItem(
    String label, String imagePath, BuildContext context, String page) {
  final screenHeight = MediaQuery.of(context).size.height;

  return GestureDetector(
    onTap: () {
      Widget pageToNavigate;

      switch (page) {
        case 'WorkerListPage1':
          pageToNavigate = WorkerListPage(categoryNumber: 1);
          break;
        case 'WorkerListPage2':
          pageToNavigate = WorkerListPage(categoryNumber: 2);
          break;
        case 'WorkerListPage3':
          pageToNavigate = WorkerListPage(categoryNumber: 3);
          break;
        default:
          pageToNavigate = WorkerListPage(categoryNumber: 1);
      }

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => pageToNavigate),
      );
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: screenHeight * 0.05, // Responsive radius for the CircleAvatar
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: screenHeight * 0.12, // Control image width
              height: screenHeight * 0.1, // Control image height
              fit: BoxFit.cover, // Adjusts the image to cover the CircleAvatar
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01), // Responsive spacing
        Text(label),
      ],
    ),
  );
}

Widget _buildCategoryRow(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02), // Responsive padding
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCategoryItem(
            'Mechanical', 'assets/images/mechanical.jpg', context, 2),
        _buildCategoryItem(
            'Electrical', 'assets/images/electrical.jpg', context, 1),
        _buildCategoryItem(
            'Furniture', 'assets/images/furniture2.jpg', context, 3),
      ],
    ),
  );
}

Widget _buildCategoryItem(
    String label, String imagePath, BuildContext context, int categoryNumber) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CategoryPage(categoryNumber: categoryNumber),
        ),
      );
    },
    child: Container(
      width: screenWidth * 0.3, // Responsive width
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 7),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      child: Column(
        children: [
          Image.asset(imagePath,
              height: screenHeight * 0.1,
              width: screenWidth * 0.2), // Responsive size
          SizedBox(height: screenHeight * 0.01), // Responsive spacing
          Text(label),
        ],
      ),
    ),
  );
}

void _showNotificationsMenu(BuildContext context) {
  final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
  final appBarSize = appBarRenderBox.size;

  final String firstName =
      FirebaseAuth.instance.currentUser?.displayName ?? 'User';

  // List of notifications
  final List<String> notifications = [
    '1-Welcome, $firstName. We are delighted to have you on board.',
    '2-Explore our latest update: you can now confirm your payment using a QR code.',
    '3-We have introduced a new section in our car offerings, allowing you to build an exhaust system from scratch.',
    '4-Struggling to find a reliable professional to repair your item? Rest assured, place your order now, and let our experts handle it with utmost precision and care.',
  ];

  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      appBarSize.width - 100,
      appBarSize.height + 50,
      0,
      0,
    ),
    items: notifications.map((notification) {
      return PopupMenuItem<String>(
        value: notification,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
          child: Text(
            notification,
            style:
                TextStyle(color: Colors.purple), // Change text color to purple
          ),
        ),
      );
    }).toList(),
  );
}
