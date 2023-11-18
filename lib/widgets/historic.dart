import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class Historic extends StatefulWidget {
  @override
  _HistoricState createState() => _HistoricState();
}

class _HistoricState extends State<Historic> {
  List<List<dynamic>> _csvData = [];

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    try {
      final String csvFilePath = (await getTemporaryDirectory()).path +
          '/yourfile.csv';
      final String csvContent = await File(csvFilePath).readAsString();
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvContent);

      setState(() {
        _csvData = csvTable;
      });
    } catch (e) {
      print('Error loading CSV data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _csvData.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('First line of the CSV file:'),
            Expanded(  // Wrap ListView or similar widgets
              child: ListView.builder(
                itemCount: _csvData.length,
                itemBuilder: (context, index) => Text(_csvData[index].toString()),
              ),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }

}

