import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hcq/services/colon_cancer_article_services.dart';
import 'package:hcq/utils/colors.dart';
import 'package:hcq/widgets/article_card.dart'; // Import the ArticleCard widget

class ColonCancerArticlesScreen extends StatefulWidget {
  const ColonCancerArticlesScreen({super.key});

  @override
  _ColonCancerArticlesScreenState createState() =>
      _ColonCancerArticlesScreenState();
}

class _ColonCancerArticlesScreenState extends State<ColonCancerArticlesScreen> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = ColonCancerArticleService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text('Colon Cancer Articles'),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return ArticleCard(article: article); // Use ArticleCard here
              },
            );
          }
        },
      ),
    );
  }
}
