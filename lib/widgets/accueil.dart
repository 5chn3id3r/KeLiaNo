import 'package:flutter/material.dart';
import 'data_scrapper.dart';

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  Future<ScrapedData>? scrapedDataFuture;

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
          String dateDisplay = snapshot.data!.dates.isNotEmpty
              ? capitalizeFirstLetter(snapshot.data!.dates.first.split(' ').skip(1).join(' '))
              : 'Date non disponible';

          List<List<String>> groupedTirages = groupTirages(snapshot.data!.tirages.first, 4);

          // Ajout pour afficher multiplicateur et joker
          String multiplicateur = snapshot.data!.multiplicateurs.isNotEmpty ? snapshot.data!.multiplicateurs.first : '';
          String joker = snapshot.data!.jokers.isNotEmpty ? snapshot.data!.jokers.first : '';

          return Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0),  // Ajoutez un peu d'espace autour du titre
                  child: Text(
                    'Coucou Mamie, bienvenue sur ton application Keno',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                    child:
                    Image.asset('assets/trefle.png',
                        width: MediaQuery.of(context).size.width * 0.1, // 10% de la largeur de l'écran
                        height: MediaQuery.of(context).size.height * 0.1),
                ),
                Center(
                  child: Text(
                    dateDisplay,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),  // Espace ajouté ici
                ...groupedTirages.map((group) => buildLigne(group, context)).toList(),
                SizedBox(height: 20),  // Espace supplémentaire pour séparer les éléments
                Text('Multiplicateur: $multiplicateur         Joker: $joker',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );

        } else {
          return Center(child: Text('Aucune donnée disponible'));
        }
      },
    );
  }


  // Fonction pour diviser les tirages en groupes de quatre
  List<List<String>> groupTirages(List<String> tirages, int groupSize) {
    List<List<String>> groups = [];
    for (var i = 0; i < tirages.length; i += groupSize) {
      int end = (i + groupSize < tirages.length) ? i + groupSize : tirages.length;
      groups.add(tirages.sublist(i, end));
    }
    return groups;
  }

  Widget buildLigne(List<String> groupe, BuildContext context) {
    double size = MediaQuery.of(context).size.width / 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: groupe.map((numero) => Padding(
        padding: const EdgeInsets.all(2.0), // Léger espace entre les boules
        child: buildBoule(numero, size),
      )).toList(),
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
          colors: [Colors.yellow, Colors.deepOrange], // Dégradé de jaune à orange
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
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
