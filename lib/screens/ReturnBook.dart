import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../PayFine.dart';

class ReturnBookScreen extends StatefulWidget {
  @override
  _ReturnBookScreenState createState() => _ReturnBookScreenState();
}

class _ReturnBookScreenState extends State<ReturnBookScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController serialNoController = TextEditingController();
  TextEditingController issueDateController = TextEditingController();
  DateTime issueDate = DateTime.now();
  DateTime returnDate = DateTime.now();
  String? bookName;
  String? authorName;
  String? serialNo;
  double fine = 0.0;
  int lateDays = 0;

  // Fetch book details based on the book name
  Future<void> _generateDetails() async {
    if (bookName != null && bookName!.isNotEmpty) {
      try {
        var bookSnapshot = await FirebaseFirestore.instance
            .collection('books')
            .where('Title', isEqualTo: bookName)
            .get();

        if (bookSnapshot.docs.isNotEmpty) {
          var bookDoc = bookSnapshot.docs.first;
          String fetchedAuthorName = bookDoc['Author'];
          String fetchedSerialNo = bookDoc['SerialNo'].toString();
          Timestamp issueDateTimestamp = bookDoc['IssueDate'];

          DateTime fetchedIssueDate = issueDateTimestamp.toDate();
          returnDate = DateTime.now();

          _calculateFine(fetchedIssueDate);

          setState(() {
            authorName = fetchedAuthorName;
            serialNo = fetchedSerialNo;
            issueDate = fetchedIssueDate;
            authorNameController.text = authorName!;
            serialNoController.text = serialNo!;
            issueDateController.text = DateFormat('yyyy-MM-dd').format(fetchedIssueDate);
          });
        } else {
          _showError('Book not found!');
        }
      } catch (e) {
        _showError('Error fetching book details: ${e.toString()}');
      }
    } else {
      _showError('Please enter a book name.');
    }
  }

  // Calculate fine based on late days
  void _calculateFine(DateTime fetchedIssueDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(fetchedIssueDate);
    fine = difference.isNegative ? 0.0 : difference.inDays * 2;
    lateDays = difference.isNegative ? 0 : difference.inDays;
  }

  // Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Show success message
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Validate and submit the form
  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        var bookSnapshot = await FirebaseFirestore.instance
            .collection('books')
            .where('Title', isEqualTo: bookName)
            .get();

        if (bookSnapshot.docs.isNotEmpty) {
          var bookDoc = bookSnapshot.docs.first;

          if (fine > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PayFinePage(
                  fine: fine,
                  lateDays: lateDays,
                  bookName: bookName!,
                  documentId: bookDoc.id,
                ),
              ),
            );
          } else {
            _showSuccess('Book Returned Successfully!');
          }
        } else {
          _showError('Book not found!');
        }
      } catch (e) {
        _showError('Error returning book. Please try again.');
      }
    } else {
      _showError('Please fill all mandatory fields!');
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
              Image.asset(
                "asset/background.jpg",
                fit: BoxFit.cover,
                height: screenHeight,
                width: screenWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Return Book",
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
                            onPressed: _generateDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Generate Author & Serial No',
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
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: serialNoController,
                            decoration: InputDecoration(
                              labelText: 'Serial No of the Book',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: issueDateController,
                            decoration: InputDecoration(
                              labelText: 'Issue Date',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Return Date',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            initialValue: DateFormat('yyyy-MM-dd').format(returnDate),
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          if (fine > 0)
                            Text(
                              'Fine: ₹${fine.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 10),
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
