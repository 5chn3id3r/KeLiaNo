import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class DataScrapper {
  final String url = 'https://www.reducmiz.com/resultat_fdj.php?jeu=keno&nb=50';

  Future<ScrapedData> scrapeData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        List<Element> tables = document.querySelectorAll('.table.table-condensed.table-striped');

        List<String> dates = [];
        List<List<String>> tirages = []; // Modifié pour une liste de listes
        List<String> multiplicateurs = [];
        List<String> jokers = [];

        for (var table in tables) {
          var rows = table.querySelectorAll('tr');
          // Date du tirage
          dates.add(rows[0].querySelector('b')?.text ?? 'Date inconnue');

          // Tirage
          String tirageRaw = rows[1].querySelector('font')?.text ?? 'Tirage inconnu';
          List<String> tirageSplit = tirageRaw.split(' ');
          tirages.add(tirageSplit);

          // Multiplicateur
          multiplicateurs.add(rows[2].querySelector('td:last-child')?.text ?? 'Multiplicateur inconnu');

          // Numéro JOKER+
          jokers.add(rows[3].querySelector('td:last-child')?.text ?? 'JOKER+ inconnu');
        }

        return ScrapedData(dates, tirages, multiplicateurs, jokers);
      } else {
        throw Exception('Erreur de chargement des données depuis $url');
      }
    } catch (e) {
      throw Exception('Erreur lors du scraping des données: $e');
    }
  }
}

class ScrapedData {
  final List<String> dates;
  final List<List<String>> tirages; // Type modifié pour correspondre à DataScrapper
  final List<String> multiplicateurs;
  final List<String> jokers;

  ScrapedData(this.dates, this.tirages, this.multiplicateurs, this.jokers);
}
