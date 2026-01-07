import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil & Programlar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Kullanıcı profili ve program seçimi buraya gelecek.'),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: Text('Kilo Vermek İçin Program')),
            ElevatedButton(onPressed: () {}, child: Text('Kilo Almak İçin Program')),
            ElevatedButton(onPressed: () {}, child: Text('Aktif Spor Programı')),
          ],
        ),
      ),
    );
  }
}
