import 'package:flutter/material.dart';
import 'data_scrapper.dart';

class Historic extends StatefulWidget {
  @override
  _HistoricState createState() => _HistoricState();
}

class _HistoricState extends State<Historic> {
  late Future<ScrapedData> scrapedDataFuture;

  @override
  void initState() {
    super.initState();
    scrapedDataFuture = DataScrapper().scrapeData();
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScrapedData>(
      future: scrapedDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: snapshot.data!.tirages.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<String> tirage = entry.value;
                  String date = snapshot.data!.dates[index];
                  String multiplicateur = snapshot.data!.multiplicateurs[index];
                  String joker = snapshot.data!.jokers[index];

                  return buildTirageSection(date, tirage, multiplicateur, joker, context);
                }).toList(),
              ),
            ),
          );
        } else {
          return Center(child: Text('Aucune donnée disponible'));
        }
      },
    );
  }

  Widget buildTirageSection(String date, List<String> tirage, String multiplicateur, String joker, BuildContext context) {
    int groupSize = (tirage.length / 4).ceil(); // Calculer la taille de chaque groupe

    return Column(
      children: [
        Text(
          capitalizeFirstLetter(date),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        for (int i = 0; i < tirage.length; i += groupSize) // Boucle pour créer quatre lignes
          buildLigne(
              tirage.sublist(i, i + groupSize > tirage.length ? tirage.length : i + groupSize),
              context
          ),
        Text('Multiplicateur: $multiplicateur, Joker: $joker',
    style: TextStyle(fontSize: 20),),
        const SizedBox(height: 15),
        Image.asset('assets/trefle.png',
        width: MediaQuery.of(context).size.width * 0.1, // 50% de la largeur de l'écran
        height: MediaQuery.of(context).size.height * 0.1),

        const SizedBox(height: 15),
      ],
    );
  }


// Utilisez votre fonction `buildLigne` existante ici


  List<List<String>> groupTirages(List<List<String>> allTirages, int groupSize) {
    List<List<String>> groups = [];
    for (var tirages in allTirages) {
      for (int i = 0; i < tirages.length; i += groupSize) {
        int end = (i + groupSize < tirages.length) ? i + groupSize : tirages.length;
        groups.add(tirages.sublist(i, end));
      }
    }
    return groups;
  }

  Widget buildLigne(List<String> groupe, BuildContext context) {
    double size = MediaQuery.of(context).size.width / 10;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupe.map((numero) => Padding(
          padding: const EdgeInsets.all(2.0),
          child: buildBoule(numero, size),
        )).toList(),
      ),
    );
  }

  Widget buildBoule(String numero, double size) {
    double fontSize = size / 3;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.yellow, Colors.deepOrange],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(right: numero.length > 1 ? 4.0 : 0.0),
        child: Text(
          numero,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
