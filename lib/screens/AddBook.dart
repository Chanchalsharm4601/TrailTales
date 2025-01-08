import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the input fields
  TextEditingController BookTitleController = TextEditingController();
  TextEditingController AuthorController = TextEditingController();
  TextEditingController SerialNoController = TextEditingController();

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to submit the book form to Firestore
  void _submitBookForm() async {
    if (_formKey.currentState!.validate()) {
      // Try to add a new book to the Firestore collection
      try {
        await _firestore.collection('books').add({
          'Title': BookTitleController.text.isEmpty ? "Flutter for Beginners" : BookTitleController.text,
          'Author': AuthorController.text.isEmpty ? "John Doe" : AuthorController.text,
          'SerialNo': int.tryParse(SerialNoController.text) ?? 2,
          'Available': false, // Default to false
          'IssueDate': null, // Default to null
          'ReturnDate': null, // Default to null
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Book Added Successfully!'),
        ));

        // Clear the text fields after submission
        BookTitleController.clear();
        AuthorController.clear();
        SerialNoController.clear();
      } catch (e) {
        // Show error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add book: $e'),
        ));
      }
    } else {
      // Show a message if form validation fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'), // Title of the app bar
        backgroundColor: Colors.blueAccent, // App bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding for the form fields
        child: Form(
          key: _formKey, // Assign the form key for validation
          child: Column(
            children: <Widget>[
              // Book Title Input Field
              TextFormField(
                controller: BookTitleController,
                decoration: InputDecoration(
                  labelText: 'Book Title', // Label for the field
                  labelStyle: TextStyle(fontWeight: FontWeight.bold), // Style for the label
                  border: OutlineInputBorder(), // Border style for the input field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book title'; // Error message if input is empty
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Space between fields

              // Author Input Field
              TextFormField(
                controller: AuthorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author'; // Error message if input is empty
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Serial Number Input Field
              TextFormField(
                controller: SerialNoController,
                decoration: InputDecoration(
                  labelText: 'Serial No',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the serial number'; // Error message if input is empty
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit Button to add the book
              ElevatedButton(
                onPressed: _submitBookForm, // Calls the function to submit the form
                child: Text('Add Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Button color
                  padding: EdgeInsets.symmetric(vertical: 14), // Padding for button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
