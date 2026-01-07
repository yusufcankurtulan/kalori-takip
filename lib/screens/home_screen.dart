import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalori Takip'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService.signOut();
            },
            tooltip: 'Çıkış Yap',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
              child: Text('Profil ve Programlar'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CameraScreen()));
              },
              child: Text('Kamera ile Kalori Tahmini'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              child: Text('Günlük Kayıtlarım (yakında)'),
            ),
          ],
        ),
      ),
    );
  }
}
