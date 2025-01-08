import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trail_tales/UserDetails.dart';
import 'AddMembership.dart';
import 'BookIssueScreen.dart';
import 'ReturnBook.dart';

class LibraryHomeScreen extends StatefulWidget {
  const LibraryHomeScreen({super.key});

  @override
  State<LibraryHomeScreen> createState() => _LibraryHomeScreenState();
}

class _LibraryHomeScreenState extends State<LibraryHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _bookSuggestions = [];
  List<String> _allBooks = [];
  bool _isSearching = false;

  // Firestore reference to the books collection
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchAllBooks(); // Fetch all books when the screen is initialized
  }

  void _fetchAllBooks() async {
    QuerySnapshot snapshot = await _firestore
        .collection('books') // Assuming 'books' is your Firestore collection name
        .get();

    List<String> books = [];
    for (var doc in snapshot.docs) {
      books.add(doc["Title"]); // Assuming each document has a 'Title' field
    }

    setState(() {
      _allBooks = books;
      _bookSuggestions = books; // Initially show all books
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _isSearching = true;
        // Filter books based on query
        _bookSuggestions = _allBooks
            .where((book) =>
            book.toLowerCase().contains(query.toLowerCase())) // Case-insensitive search
            .toList();
      } else {
        _isSearching = false;
        _bookSuggestions = _allBooks; // Reset to show all books if search is empty
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image (covers the whole screen)
          Positioned.fill(
            child: Image.asset(
              'asset/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          SafeArea( // Ensure content is within the safe area of the screen
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 20),
                        // Title Text: TrailTales with a different font
                        Text(
                          "TrailTales",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 90,
                            fontFamily: "NerkoOne",
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Select an option below:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Row of Buttons wrapped in a SingleChildScrollView
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildNavButton(
                                context,
                                label: "Issue Book",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookIssueScreen()),
                                  );
                                },
                              ),
                              _buildNavButton(
                                context,
                                label: "Return Book",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReturnBookScreen()),
                                  );
                                },
                              ),
                              _buildNavButton(
                                context,
                                label: "Add Membership",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddMembershipScreen()),
                                  );
                                },
                              ),
                              _buildNavButton(
                                context,
                                label: "User Management",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Search Section
                        const Text(
                          "Search for Books",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter book name, author, or serial number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search, color: Colors.black),
                          ),
                        ),
                        // Displaying all books in a dropdown or list
                        if (_isSearching || _bookSuggestions.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _bookSuggestions.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        _bookSuggestions[index],
                                        style: TextStyle(
                                          color: Colors.black, // Explicit text color
                                        ),
                                      ),
                                      onTap: () {
                                        print('Tapped on ${_bookSuggestions[index]}');
                                        // Implement behavior for selecting a book
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.7),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
