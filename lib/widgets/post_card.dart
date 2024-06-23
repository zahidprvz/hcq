import 'package:flutter/material.dart';
import 'package:hcq/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcq/resources/firestore_methods.dart';
import 'package:hcq/screens/comment_screen.dart';
import 'package:hcq/utils/global_variables.dart';
import 'package:hcq/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:hcq/providers/user_provider.dart';
import 'package:hcq/models/user.dart';
import 'package:hcq/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic>? snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    if (widget.snap != null) {
      getComments();
    }
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap!['postId'])
          .collection('comments')
          .get();

      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (e) {
      // print('Error fetching comments: $e');
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final User? user = userProvider.getUser;
    final width = MediaQuery.of(context).size.width;

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.snap == null) {
      return const Center(
        child: Text('Post data is missing'),
      );
    }

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ).copyWith(
              right: 0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.0,
                  backgroundImage: NetworkImage(
                    widget.snap?['profImage'] as String? ?? '',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap?['username'] as String? ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: mobileBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          shrinkWrap: true,
                          children: ['Delete']
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    FirestoreMethods()
                                        .deletePost(widget.snap!['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: mobileBackgroundColor, // Updated color here
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          e,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white, // Text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              FirestoreMethods().likePost(
                widget.snap!['postId'],
                user.uid,
                widget.snap!['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    6.0,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: widget.snap?['postUrl'] != null
                        ? Image.network(
                            widget.snap?['postUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text(
                                  'Failed to load image',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              'No Image Available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLikeAnimating ? 1 : 0,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Like, Comment Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap!['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    FirestoreMethods().likePost(
                      widget.snap!['postId'],
                      user.uid,
                      widget.snap!['likes'],
                    );
                  },
                  icon: widget.snap!['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
                ),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(
              //     Icons.send,
              //     color: Colors.white,
              //   ),
              // ),
              // Expanded(
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: IconButton(
              //       onPressed: () {},
              //       icon: const Icon(
              //         Icons.bookmark_border,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          // Description and Number of comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                  child: Text(
                    '${widget.snap!['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: widget.snap!['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap!['description']}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        snap: widget.snap,
                      ),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                    ),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap!['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
