import 'package:flutter/material.dart';
import 'widgets/accueil.dart';
import 'widgets/historic.dart';
import 'widgets/statistics.dart';
import 'widgets/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Keno';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Liste des widgets pour chaque onglet
  final List<Widget> _widgetOptions = <Widget>[
    Accueil(), // Assurez-vous que ce widget est bien défini
    Historic(), // Assurez-vous que ce widget est bien défini
    Statistics(), // Assurez-vous que ce widget est bien défini
    Settings(),
  ];

  // Méthode pour gérer le changement d'onglet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            _buildDrawerItem('Accueil', 0),
            _buildDrawerItem('Historique', 1),
            _buildDrawerItem('Statistiques', 2),
            _buildDrawerItem('Paramètres', 3),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire chaque item du tiroir
  Widget _buildDrawerItem(String title, int index) {
    return ListTile(
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }
}
