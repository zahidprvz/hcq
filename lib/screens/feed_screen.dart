import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: width > webScreenSize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              title: Image.asset(
                'assets/HCQ.png',
                height: 50.0,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 0,
                ),
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}