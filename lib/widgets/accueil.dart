import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void makeRequest() async{
  var response = await http.get(Uri.parse('https://www.fdj.fr/jeux-de-tirage/keno/resultats'));
  //If the http request is successful the statusCode will be 200
  if(response.statusCode == 200){
    String htmlToParse = response.body;
    print(htmlToParse);
  }
}

void getValues() async{
  var response = await http.get(Uri.parse('https://www.fdj.fr/jeux-de-tirage/keno/resultats'));
  final document = parser.parse(response.body);
  final elements = document.getElementsByClassName("result-full__list-item");
  print(elements);
}

class Accueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Text(
              'Bienvenue sur l\'application Keno!',
              style: TextStyle(fontSize: 24),
            ),
            TextButton(onPressed: getValues, child: Text("OUI"))
          ],
        )
      );
  }
}
