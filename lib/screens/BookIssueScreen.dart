import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookIssueScreen extends StatefulWidget {
  @override
  _BookIssueScreenState createState() => _BookIssueScreenState();
}

class _BookIssueScreenState extends State<BookIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  DateTime issueDate = DateTime.now();
  DateTime returnDate = DateTime.now().add(Duration(days: 15));
  String? bookName;
  String? authorName;
  String? remarks;

  // Function to auto-generate author name based on the entered book name
  void _generateAuthor() async {
    if (bookName != null && bookName!.isNotEmpty) {
      try {
        var bookSnapshot = await FirebaseFirestore.instance
            .collection('books')
            .where('Title', isEqualTo: bookName)
            .get();

        if (bookSnapshot.docs.isNotEmpty) {
          var bookDoc = bookSnapshot.docs.first;
          String fetchedAuthorName = bookDoc['Author'];

          setState(() {
            authorName = fetchedAuthorName;
            authorNameController.text = authorName!;
          });
        } else {
          setState(() {
            authorName = 'Author not found';
            authorNameController.text = authorName!;
          });
        }
      } catch (e) {
        setState(() {
          authorName = 'Error fetching author';
          authorNameController.text = authorName!;
        });
      }
    }
  }

  // Function to validate and submit book issue request
  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Fetch book details from Firestore
        var bookSnapshot = await FirebaseFirestore.instance
            .collection('books')
            .where('Title', isEqualTo: bookName)
            .get();

        if (bookSnapshot.docs.isNotEmpty) {
          var bookDoc = bookSnapshot.docs.first;

          // Check if the book is available
          if (bookDoc['Available'] == true) {
            // Update availability and issue date in the database
            await FirebaseFirestore.instance.collection('books').doc(bookDoc.id).update({
              'Available': false,
              'IssueDate': issueDate,
              'ReturnDate': returnDate,
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Book Issued Successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This book is not available right now.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Book not found!')),
          );
        }
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error issuing book. Please try again later.')),
        );
      }
    } else {
      // Form validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all mandatory fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              // Background Image
              Image.asset(
                "asset/background.jpg",
                fit: BoxFit.cover,
                height: screenHeight,
                width: screenWidth,
              ),
              // Content on top of the background image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Issue Book",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontFamily: "NerkoOne",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: bookNameController,
                            decoration: InputDecoration(
                              labelText: 'Name of Book',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            onChanged: (value) {
                              bookName = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the book name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _generateAuthor,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Generate Author',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: authorNameController,
                            decoration: InputDecoration(
                              labelText: 'Name of Author',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Author name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Issue Date',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                            initialValue:
                            DateFormat('yyyy-MM-dd').format(issueDate),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Issue date is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Return Date',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                            initialValue:
                            DateFormat('yyyy-MM-dd').format(returnDate),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: remarksController,
                            decoration: InputDecoration(
                              labelText: 'Remarks (Optional)',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            onChanged: (value) {
                              remarks = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _validateAndSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
