import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PayFinePage extends StatelessWidget {
  final double fine;
  final int lateDays;
  final String bookName;  // To identify the book
  final String documentId;  // The Firestore document ID of the book

  PayFinePage({
    required this.fine,
    required this.lateDays,
    required this.bookName,
    required this.documentId,
  });

  Future<void> _payFine(BuildContext context) async {
    try {
      // Update Firestore: Set availability to false, and issueDate, returnDate to null
      await FirebaseFirestore.instance.collection('books').doc(documentId).update({
        'Available': false,
        'IssueDate': null,
        'ReturnDate': null,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fine paid successfully!')),
      );

      // Return to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error paying fine: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay Fine"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You are late by $lateDays days",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Your fine is: ₹${fine.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _payFine(context),
                child: Text("Pay Fine"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
