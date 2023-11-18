import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'Bienvenue sur l\'application Keno!',
          style: TextStyle(fontSize: 24),
        ),
      );
  }
}
