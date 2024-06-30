import 'package:flutter/material.dart';
import 'package:mobileapp/SplashScreen.dart';
import 'package:mobileapp/form_dosen.dart';
import 'package:mobileapp/form_mahasiswa.dart';
import 'package:mobileapp/form_matakuliah.dart';
import 'package:mobileapp/form_nilai.dart';
import 'package:mobileapp/login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Menu',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(), // Start with SplashScreen
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard '),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _buildGridCards(context),
              ),
            ),
            const SizedBox(height: 16.0),  // Additional spacing between items and logout button
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGridCards(BuildContext context) {
    List<String> titles = ['Data Mahasiswa', 'Data Mata Kuliah', 'Data Dosen', 'Data Nilai'];
    List<IconData> icons = [Icons.school, Icons.book, Icons.person, Icons.grade];

    return List.generate(titles.length, (index) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {
            _navigateToForm(context, titles[index]);
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blue.shade800,
                  child: Icon(icons[index], size: 24.0, color: Colors.white),
                  radius: 24.0,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    titles[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToLogin(context); // Navigate to login on logout tap
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.exit_to_app, size: 20.0, color: Colors.white),
              const SizedBox(width: 12.0),
              Text(
                'Keluar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, String title) {
    switch (title) {
      case 'Data Mahasiswa':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormMahasiswa()),
        );
        break;
      case 'Data Mata Kuliah':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CourseDataForm()),
        );
        break;
      case 'Data Dosen':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DosenDataEntry()),
        );
        break;
      case 'Data Nilai':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormNilaiMahasiswa()),
        );
        break;
      default:
        break;
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
