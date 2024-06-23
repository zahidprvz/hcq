import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hcq/services/colon_cancer_article_services.dart';
import 'package:html/parser.dart' show parse;

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(context, article.url); // Pass context here
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                _parseHtmlString(article.title),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text color
                ),
              ),
              subtitle: Text(
                article.organization,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Black text color
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                _parseHtmlString(article.fullSummary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      final encodedUrl = Uri.encodeFull(url); // Encode the URL
      await launch(encodedUrl); // Directly attempt to launch
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Could not launch URL: $url'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString); // Correctly parse the HTML string
    return document.body?.text ?? '';
  }
}
