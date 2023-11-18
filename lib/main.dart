import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'widgets/accueil.dart';
import 'widgets/historic.dart';
import 'widgets/statistics.dart';

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
  static List<Widget> _widgetOptions = <Widget>[
    Accueil(),
    Historic(),
    Statistics(),
  ];

  @override
  void initState() {
    super.initState();
    _downloadAndExtractZip();
  }

  Future<void> _downloadAndExtractZip() async {
    final String zipUrl = 'https://media.fdj.fr/static-draws/csv/keno/keno_202010.zip';
    final String zipPath = (await getTemporaryDirectory()).path + '/keno_202010.zip';

    try {
      // Télécharge le fichier zip
      await _downloadFile(zipUrl, zipPath);

      // Extrait le fichier zip
      await _extractZip(zipPath, (await getTemporaryDirectory()).path);
    } catch (e) {
      print('Erreur lors du téléchargement ou de l\'extraction du fichier zip : $e');
    }
  }

  Future<void> _downloadFile(String url, String destinationPath) async {
    final http.Response response = await http.get(Uri.parse(url));
    await File(destinationPath).writeAsBytes(response.bodyBytes);
  }

  Future<void> _extractZip(String zipFilePath, String destinationPath) async {
    final bytes = File(zipFilePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final fileName = '$destinationPath/${file.name}';
      if (file.isFile) {
        final data = file.content as List<int>;
        await File(fileName).writeAsBytes(data, flush: true);
      } else {
        await Directory(fileName).create(recursive: true);
      }
    }
  }

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
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Accueil'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Historique'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Statistiques'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
