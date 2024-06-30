import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CourseDataForm(),
    );
  }
}

class CourseDataForm extends StatefulWidget {
  const CourseDataForm({super.key});

  @override
  _CourseDataFormState createState() => _CourseDataFormState();
}

class _CourseDataFormState extends State<CourseDataForm> {
  final _formKey = GlobalKey<FormState>();
  String courseCode = '';
  String courseName = '';
  int courseCredits = 0;

  Future<void> _submitData() async {
    final url = Uri.parse('https://caesarjsitumorang.000webhostapp.com/mobileApp/simpan_matakuliah.php');
    try {
      final response = await http.post(
        url,
        body: {
          'kode_matakuliah': courseCode,
          'nama_matakuliah': courseName,
          'jumlah_sks': courseCredits.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Tersimpan')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: ${response.reasonPhrase}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Data Mata Kuliah'),
        backgroundColor: Colors.green,  // Ubah warna app bar menjadi hijau
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Kode Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kode mata kuliah';
                  }
                  return null;
                },
                onSaved: (value) {
                  courseCode = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama mata kuliah';
                  }
                  return null;
                },
                onSaved: (value) {
                  courseName = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Jumlah SKS',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.score),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah SKS';
                  }
                  return null;
                },
                onSaved: (value) {
                  courseCredits = int.parse(value!);
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Simpan'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _submitData();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),  // Ubah warna tombol "Kirim" menjadi hijau
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text('Batal'),
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),  // Ubah warna tombol "Batal" menjadi cyan
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
