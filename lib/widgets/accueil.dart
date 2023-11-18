import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}


class Results extends StatelessWidget {
  final List<String> values;

  Results(this.values);

  Widget _buildCircle(String value, BuildContext context, Color color) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width/100*10/(values.length/2)),
      width: MediaQuery.of(context).size.width/100*80/(values.length/2),
      height: MediaQuery.of(context).size.width/100*80/(values.length/2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Diviser la liste en deux sous-listes pour deux lignes
    var halfLength = (values.length / 2).ceil();
    var firstRowValues = values.sublist(0, halfLength);
    var secondRowValues = values.sublist(halfLength);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: firstRowValues.map((value) => _buildCircle(value,
                                                                context,
                                                                Colors.orange)).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: secondRowValues.map((value) => _buildCircle(value,
                                                                context,
                                                                Colors.orange)).toList(),
        ),
      ],
    );
  }

}

class _AccueilState extends State<Accueil> {
  List<String> values = [];
  String multiplicator = "";
  String periodInDay = "";
  String date = "";
  String day = "";
  String month = "";
  String year = "";

  @override
  void initState() {
    super.initState();
    scrapPage();
  }

  void scrapPage() async {
    var response = await http.get(Uri.parse('https://www.fdj.fr/jeux-de-tirage/keno/resultats'));
    final document = parser.parse(response.body);
    var elements = document.getElementsByClassName("result-full__list-item");

    List<String> newValues = [];
    for (var element in elements) {
      newValues.add(element.text.trim());
    }

    elements = document.getElementsByClassName("result-full__option-multi");
    String newMultiplicator = elements.isNotEmpty ? elements.first.text.trim() : "";

    elements = document.getElementsByClassName("result-full__drawing-time");
    String newPeriodInDay = elements.isNotEmpty ? elements.first.text.trim() : "";
    newPeriodInDay = newPeriodInDay.split(" ")[2];
    
    elements = document.getElementsByClassName("fdj Title");
    String newDate = elements.isNotEmpty ? elements.first.text.trim() : "";

    setState(() {
      values = newValues;
      multiplicator = newMultiplicator;
      periodInDay = newPeriodInDay;
      day = newDate.split(" ")[3];
      month = newDate.split(" ")[4];
      year = newDate.split(" ")[5];
      date = day + " " + month + " " + year;
    });
  }

  Widget _Multiplicator(BuildContext context, String multiplicator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Multiplicateur :",
      style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide/30)),
        Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.shortestSide / 100 * 10 / (values.length / 2)),
          width: MediaQuery.of(context).size.shortestSide / 100 * 80 / (values.length / 2),
          height: MediaQuery.of(context).size.shortestSide / 100 * 80 / (values.length / 2),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            multiplicator,
            style: TextStyle(color: Colors.white,
                fontSize: MediaQuery.of(context).size.shortestSide/30),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          children: [
            Padding(padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height/5,
                top: MediaQuery.of(context).size.height/8),
            child: Text(
              'Bienvenue sur Keliano!',
              style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide/20),
            )
            )
            ,
            Text('Résultat du ' + date,
                style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide/30)),
            Text('Tirage du ' + periodInDay,
                style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide/30)),
            _Multiplicator(context, multiplicator),
            Results(values),
          ],
        ),
      ),
    );
  }
}
