import 'package:flutter/material.dart';
import 'data_scrapper.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistics> {
  late Future<ScrapedData> scrapedDataFuture;
  String selectedSort = 'Fréquence';

  @override
  void initState() {
    super.initState();
    scrapedDataFuture = DataScrapper().scrapeData();
  }
  final List<String> sortOptions = ['Fréquence', 'Dernier tirage', 'Numéro'];
  List<KenoNumber> calculateStatistics(ScrapedData data) {
    Map<int, KenoNumber> stats = {};

    for (int i = 0; i < data.tirages.length; i++) {
      for (String numero in data.tirages[i]) {
        int num = int.parse(numero);
        if (!stats.containsKey(num)) {
          stats[num] = KenoNumber(number: num, frequency: 0, lastDrawIndex: i);
        }
        stats[num]!.frequency++;
        if (stats[num]!.lastDrawIndex > i) {
          stats[num]!.lastDrawIndex = i;
        }
      }
    }

    return stats.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques Keno'),
      ),
      body: FutureBuilder<ScrapedData>(
        future: scrapedDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            ScrapedData data = snapshot.data!;
            List<KenoNumber> numbers = calculateStatistics(data);

            if (selectedSort == 'Fréquence') {
              numbers.sort((a, b) => a.frequency.compareTo(b.frequency));
            } else if (selectedSort == 'Dernier tirage') {
              numbers.sort((a, b) => b.lastDrawIndex.compareTo(a.lastDrawIndex));
            } else if (selectedSort == 'Numéro') {
              numbers.sort((a, b) => a.number.compareTo(b.number));
            }

            return Column(
              children: [
                // Remplacez la Row par un DropdownButton
                DropdownButton<String>(
                  value: selectedSort,
                  items: sortOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                      if (selectedSort == 'Fréquence') {
                        numbers.sort((a, b) => a.frequency.compareTo(b.frequency));
                      } else if (selectedSort == 'Dernier tirage') {
                        numbers.sort((a, b) => b.lastDrawIndex.compareTo(a.lastDrawIndex));
                      } else if (selectedSort == 'Numéro') {
                        numbers.sort((a, b) => a.number.compareTo(b.number));
                      }
                    });
                  },
                ),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Deux éléments par ligne
                      childAspectRatio: 1 / 1.2, // Ajustez pour plus d'espace vertical par carte
                    ),
                    itemCount: numbers.length,
                    itemBuilder: (context, index) {
                      KenoNumber kenoNumber = numbers[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildBoule(kenoNumber.number.toString(), 50.0), // Taille de la boule
                              SizedBox(height: 8), // Espace entre les éléments
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: 16), // Augmenter la taille du texte
                                  children: [
                                    TextSpan(
                                      text: 'Fréquence\n',
                                      style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                    ),
                                    TextSpan(
                                      text: '${kenoNumber.frequency} fois\n',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8), // Espace entre les éléments
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black, fontSize: 16), // Augmenter la taille du texte
                                  children: [
                                    TextSpan(
                                      text: 'Dernier Tirage\n',
                                      style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                    ),
                                    TextSpan(
                                      text: 'Il y a ${(kenoNumber.lastDrawIndex / 2).toStringAsFixed(1)} jours',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                ),
              ],
            );
          } else {
            return Center(child: Text('Aucune donnée disponible'));
          }
        },
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
        padding: EdgeInsets.only(left: numero.length > 1 ? 0.0 : 0.0),
        child: Text(
          numero,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class KenoNumber {
  int number;
  int frequency; // Fréquence de tirage
  int lastDrawIndex; // Indice du dernier tirage

  KenoNumber({required this.number, required this.frequency, required this.lastDrawIndex});
}


