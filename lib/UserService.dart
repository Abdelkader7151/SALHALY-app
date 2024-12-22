import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserDataByEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email is empty.');
      }

      QuerySnapshot userSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception('No user found with this email.');
      }

      return userSnapshot.docs.first;
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<void> cancelActivePaymentsByName(String name) async {
    try {
      if (name.isEmpty) {
        throw Exception('Name is empty.');
      }

      QuerySnapshot paymentSnapshot = await _firestore
          .collection('paymentHistory')
          .where('worker', isEqualTo: name)
          .where('state', isEqualTo: 'Active')
          .get();

      if (paymentSnapshot.docs.isEmpty) {
        throw Exception('No active payments found for this name.');
      }

      for (DocumentSnapshot doc in paymentSnapshot.docs) {
        await _firestore
            .collection('paymentHistory')
            .doc(doc.id)
            .update({'state': 'Cancelled'});
      }
    } catch (e) {
      print('Error updating payment state: $e');
      throw Exception('Error updating payment state: $e');
    }
  }

  Future<Map<String, String>> getActivePaymentDetailsByEmail(
      String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email is empty.');
      }

      QuerySnapshot paymentSnapshot = await _firestore
          .collection('paymentHistory')
          .where('email', isEqualTo: email)
          .where('state', isEqualTo: 'Active')
          .get();

      if (paymentSnapshot.docs.isEmpty) {
        throw Exception('No active payments found for this email.');
      }

      var doc = paymentSnapshot.docs.first;
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String workerName = data['worker'] ?? 'Unknown';
        List<String> nameParts = workerName.split(' ');

        if (nameParts.length < 2) {
          throw Exception('Invalid worker name format.');
        }

        String firstName = nameParts.first;
        String lastName = nameParts.last;

        QuerySnapshot workerSnapshot = await _firestore
            .collection('Workers')
            .where('firstName', isEqualTo: firstName)
            .where('lastName', isEqualTo: lastName)
            .get();

        if (workerSnapshot.docs.isEmpty) {
          throw Exception('No worker found for the given name.');
        }

        var workerDoc = workerSnapshot.docs.first;
        Map<String, dynamic>? workerData =
            workerDoc.data() as Map<String, dynamic>?;
        String phoneNumber = workerData?['mobileNumber'] ?? 'Unknown';

        return {'name': workerName, 'phoneNumber': phoneNumber};
      } else {
        throw Exception('Document data is null');
      }
    } catch (e) {
      print('Error fetching active payment details: $e');
      return {'name': 'Unknown', 'phoneNumber': 'Unknown'};
    }
  }

  Future<List<Map<String, dynamic>>> getActivePaymentsForUser(
      String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email is empty.');
      }

      QuerySnapshot paymentSnapshot = await _firestore
          .collection('paymentHistory')
          .where('email', isEqualTo: email)
          .where('state', isEqualTo: 'Active')
          .get();

      if (paymentSnapshot.docs.isEmpty) {
        return [];
      }

      return paymentSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching payment history: $e');
      throw Exception('Error fetching payment history.');
    }
  }

  // New function: Mark worker payments as "Past"
  Future<void> markWorkerPaymentsAsPastByName(String name) async {
    try {
      if (name.isEmpty) {
        throw Exception('Name is empty.');
      }

      // Get payments where state is Active and worker matches the name
      QuerySnapshot paymentSnapshot = await _firestore
          .collection('paymentHistory')
          .where('worker', isEqualTo: name)
          .where('state', isEqualTo: 'Active')
          .get();

      if (paymentSnapshot.docs.isEmpty) {
        throw Exception('No active payments found for this worker.');
      }

      // Update each active payment state to 'Past'
      for (DocumentSnapshot doc in paymentSnapshot.docs) {
        await _firestore
            .collection('paymentHistory')
            .doc(doc.id)
            .update({'state': 'Past'});
      }
    } catch (e) {
      print('Error updating payment state to past: $e');
      throw Exception('Error updating payment state to past.');
    }
  }
}
