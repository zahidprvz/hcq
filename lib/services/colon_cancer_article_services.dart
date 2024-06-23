import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class ColonCancerArticleService {
  static const String apiUrl =
      'https://wsearch.nlm.nih.gov/ws/query?db=healthTopics&term=colon+cancer';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.body);
      // print(document.toXmlString(pretty: true)); // Debug the XML response

      final items = document.findAllElements('document');
      return items.map((item) => Article.fromXml(item)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}

class Article {
  final String title;
  final String url;
  final String organization;
  final String fullSummary;

  Article({
    required this.title,
    required this.url,
    required this.organization,
    required this.fullSummary,
  });

  factory Article.fromXml(XmlElement xml) {
    return Article(
      title: xml
          .findElements('content')
          .firstWhere((element) => element.getAttribute('name') == 'title')
          .innerText,
      url: xml.getAttribute('url') ?? '',
      organization: xml
          .findElements('content')
          .firstWhere(
              (element) => element.getAttribute('name') == 'organizationName')
          .innerText,
      fullSummary: xml
          .findElements('content')
          .firstWhere(
              (element) => element.getAttribute('name') == 'FullSummary')
          .innerText,
    );
  }
}
