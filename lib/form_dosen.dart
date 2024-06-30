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
      home: DosenDataEntry(),
    );
  }
}

class DosenDataEntry extends StatefulWidget {
  const DosenDataEntry({super.key});

  @override
  _DosenDataEntryState createState() => _DosenDataEntryState();
}

class _DosenDataEntryState extends State<DosenDataEntry> {
  final _formKey = GlobalKey<FormState>();
  String nidn = '';
  String nama = '';
  String tempatLahir = '';
  String tanggalLahir = '';
  String noTelepon = '';
  String email = '';
  String agama = '';

  Future<void> _submitData() async {
    final url = Uri.parse('https://caesarjsitumorang.000webhostapp.com/mobileApp/simpan_dosen.php');
    try {
      final response = await http.post(
        url,
        body: {
          'nidn': nidn,
          'nama': nama,
          'tempat_lahir': tempatLahir,
          'tanggal_lahir': tanggalLahir,
          'no_telepon': noTelepon,
          'email': email,
          'agama': agama,
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
        title: const Text('Input Data Dosen'),
        backgroundColor: Colors.green,  // Ubah warna app bar menjadi hijau
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'NIDN',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan NIDN';
                  }
                  return null;
                },
                onSaved: (value) {
                  nidn = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama';
                  }
                  return null;
                },
                onSaved: (value) {
                  nama = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tempat Lahir',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Tempat Lahir';
                  }
                  return null;
                },
                onSaved: (value) {
                  tempatLahir = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Tanggal Lahir';
                  }
                  return null;
                },
                onSaved: (value) {
                  tanggalLahir = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan No Telepon';
                  }
                  return null;
                },
                onSaved: (value) {
                  noTelepon = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Agama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Agama';
                  }
                  return null;
                },
                onSaved: (value) {
                  agama = value!;
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
