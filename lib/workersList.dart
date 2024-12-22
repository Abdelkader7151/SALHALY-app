import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment.dart';

class WorkerListPage extends StatelessWidget {
  final int categoryNumber;

  WorkerListPage({required this.categoryNumber});

  @override
  Widget build(BuildContext context) {
    String category;
    String appBarTitle;

    switch (categoryNumber) {
      case 1:
        category = 'electrical';
        appBarTitle = 'Electrical Workers';
        break;
      case 2:
        category = 'mechanical';
        appBarTitle = 'Mechanical Workers';
        break;
      case 3:
        category = 'furniture';
        appBarTitle = 'Furniture Workers';
        break;
      default:
        category = 'unknown';
        appBarTitle = 'Workers';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Workers')
            .where('category', isEqualTo: category) // Filter by category
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Workers Found'));
          }

          // Data retrieval successful
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String firstName = data['firstName'] ?? 'Unknown';
              String lastName = data['lastName'] ?? 'Unknown';
              String phoneNumber = data['mobileNumber'] ?? 'Not available';
              String imagePath =
                  'assets/workers/${firstName}${lastName}.jpg'; // Dynamic image path

              return Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error,
                            size: 60); // Fallback icon if image not found
                      },
                    ),
                  ),
                  title: Text(
                    '$firstName $lastName',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        data['description'] ?? 'No description available',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Mobile: $phoneNumber',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Category: ${data['category'] ?? 'Uncategorized'}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        (data['rating'] ?? 'N/A').toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Pass the worker's details to the PaymentPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          category: category,
                          workerName: '$firstName $lastName',
                          address: 'Add Your Address',
                          deliveryInfo: 'Worker is 70-80 mins away',
                          workerPhoneNumber:
                              phoneNumber, // Pass phoneNumber here
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
