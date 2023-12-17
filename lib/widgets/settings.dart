import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isFrequency100 = false; // true pour 50 jours, false pour 100 jours
  bool isFrequencyAscending = true;
  bool isLastDrawAscending = false;

  @override
  Widget build(BuildContext context) {
    int frequencyDays = isFrequency100 ? 100 : 50;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            Text(
              "Qu'est-ce que la fréquence ?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            SizedBox(height: 10),
            Text(
              'La fréquence est le nombre de fois que le numéro est sorti dans les $frequencyDays derniers tirages.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche pour les éléments du Card
                children: [
                  SwitchListTile(
                    title: Text('Durée pour la Fréquence'),
                    subtitle: Text(frequencyDays == 50 ? '50 tirages' : '100 tirages'),
                    value: isFrequency100,
                    onChanged: (bool value) {
                      setState(() {
                        isFrequency100 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Ordre de tri pour Fréquence'),
                    subtitle: Text(isFrequencyAscending ? 'Croissant' : 'Décroissant'),
                    value: isFrequencyAscending,
                    onChanged: (bool value) {
                      setState(() {
                        isFrequencyAscending = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Ordre de tri pour Dernier Tirage'),
                    subtitle: Text(isLastDrawAscending ? 'Croissant' : 'Décroissant'),
                    value: isLastDrawAscending,
                    onChanged: (bool value) {
                      setState(() {
                        isLastDrawAscending = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
