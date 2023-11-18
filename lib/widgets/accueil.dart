import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class Accueil extends StatelessWidget {
  List<String> values = [];

  Accueil() {
    scrapPage();
  }

  void scrapPage() async {
    var response = await http.get(Uri.parse('https://www.fdj.fr/jeux-de-tirage/keno/resultats'));
    final document = parser.parse(response.body);
    final elements = document.getElementsByClassName("result-full__list-item");
    for (var element in elements) {
      values.add(element.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Bienvenue sur l\'application Keno!',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(  // Ajout d'un widget Expanded
            child: ListView(
              children: values.map((element) => Text(element)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
