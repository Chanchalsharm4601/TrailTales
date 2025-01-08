import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinePayScreen extends StatefulWidget {
  final String bookName;
  final String authorName;
  final String serialNo;
  final DateTime issueDate;
  final DateTime returnDate;

  FinePayScreen({
    required this.bookName,
    required this.authorName,
    required this.serialNo,
    required this.issueDate,
    required this.returnDate,
  });

  @override
  _FinePayScreenState createState() => _FinePayScreenState();
}

class _FinePayScreenState extends State<FinePayScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController remarksController = TextEditingController();
  bool isFinePaid = false;
  double fineAmount = 0.0;
  String? remarks;

  @override
  void initState() {
    super.initState();
    _calculateFine();
  }

  // Function to calculate fine based on return date
  void _calculateFine() {
    final currentDate = DateTime.now();
    if (widget.returnDate.isBefore(currentDate)) {
      // If the book is returned after the return date, calculate fine
      fineAmount = (currentDate.difference(widget.returnDate).inDays) * 10.0; // $10 per day
    } else {
      fineAmount = 0.0;
    }
  }

  // Validate form and proceed with the return book transaction
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      if (fineAmount > 0 && !isFinePaid) {
        // Show error if fine is pending but not paid
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please pay the fine before completing the return!')),
        );
      } else {
        // Handle successful form submission (book return completion)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book Return Successful!')),
        );
        // You can add logic here to update the database and complete the transaction
      }
    } else {
      // Show error for missing details
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
                        "Pay Fine",
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
                          // Book Name (Read-only)
                          TextFormField(
                            initialValue: widget.bookName,
                            decoration: InputDecoration(
                              labelText: 'Name of Book',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          // Author Name (Read-only)
                          TextFormField(
                            initialValue: widget.authorName,
                            decoration: InputDecoration(
                              labelText: 'Name of Author',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          // Serial No (Read-only)
                          TextFormField(
                            initialValue: widget.serialNo,
                            decoration: InputDecoration(
                              labelText: 'Serial No of the Book',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          // Issue Date (Read-only)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Issue Date',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            initialValue: DateFormat('yyyy-MM-dd').format(widget.issueDate),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          // Return Date (Read-only)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Return Date',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            initialValue: DateFormat('yyyy-MM-dd').format(widget.returnDate),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          // Fine Amount (Read-only)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Fine Amount',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            initialValue: fineAmount > 0 ? "\$$fineAmount" : "No Fine",
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          // Fine Paid Checkbox
                          if (fineAmount > 0) ...[
                            Row(
                              children: [
                                Checkbox(
                                  value: isFinePaid,
                                  onChanged: (value) {
                                    setState(() {
                                      isFinePaid = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'Fine Paid',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 10),

                          // Remarks (Optional)
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

                          // Confirm Button
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
