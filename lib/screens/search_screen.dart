import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcq/screens/profile_screen.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  Future<QuerySnapshot>? searchResultFuture;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void handleSearch(String query) {
    Future<QuerySnapshot> users = FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultFuture = users;
      isShowUsers = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: handleSearch,
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: searchResultFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  );
                }
                var docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No users found."),
                  );
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var userDoc = docs[index];
                    var photoUrl = userDoc['photoUrl'] ??
                        'default_photo_url'; // Provide a default photo URL if the field is missing

                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: userDoc['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                        title: Text(userDoc['username']),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  );
                }
                var docs = snapshot.data!.docs;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > webScreenSize
                            ? 3
                            : 2, // Adjust the number of columns as needed
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final postUrl = docs[index]['postUrl'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.3), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 3), // Shadow offset
                              ),
                            ],
                          ),
                          child: Image.network(
                            postUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
