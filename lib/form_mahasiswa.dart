import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FormMahasiswa(),
    );
  }
}

class FormMahasiswa extends StatefulWidget {
  const FormMahasiswa({super.key});

  @override
  _FormMahasiswaState createState() => _FormMahasiswaState();
}

class _FormMahasiswaState extends State<FormMahasiswa> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _jenisKelamin;
  String? _tahunMasuk;
  String? _agama;
  String? _jurusan;
  String? _semester;

  final List<String> _tahunMasukList =
      List.generate(24, (index) => (2000 + index).toString());
  final List<String> _agamaList = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha'
  ];
  final List<String> _jurusanList = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Sains Data'
  ];
  final List<String> _semesterList = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://caesarjsitumorang.000webhostapp.com/mobileApp/simpan_mahasiswa.php');
      final response = await http.post(url, body: {
        'npm': _npmController.text,
        'nama_mahasiswa': _namaController.text,
        'tempat_lahir': _tempatLahirController.text,
        'tanggal_lahir': _dateController.text,
        'jenis_kelamin': _jenisKelamin ?? '',
        'tahun_masuk': _tahunMasuk ?? '',
        'agama': _agama ?? '',
        'jurusan': _jurusan ?? '',
        'semester': _semester ?? '',
      });

      if (response.statusCode == 200 && response.body.contains('Data mahasiswa berhasil disimpan')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data berhasil disimpan'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat menyimpan data'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Data Mahasiswa'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _npmController,
              decoration: InputDecoration(labelText: 'NPM'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter NPM';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Mahasiswa'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                   return 'Mohon Masukkan Nama Mahasiswa';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _tempatLahirController,
              decoration: InputDecoration(labelText: 'Tempat Lahir'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Mohon Masukkan Tempat Lahir';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon Masukkan Tanggal Lahir';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _jenisKelamin,
              decoration: InputDecoration(labelText: 'Jenis Kelamin'),
              items: [
                'Laki-laki',
                'Perempuan',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _jenisKelamin = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Mohon Pilih Jenis Kelamin';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _tahunMasuk,
              decoration: InputDecoration(labelText: 'Tahun Masuk'),
              items: _tahunMasukList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.date_range),
                      SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tahunMasuk = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Mohon Pilih Tahun Masuk';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _agama,
              decoration: InputDecoration(labelText: 'Agama'),
              items: _agamaList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.star),
                      SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _agama = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Mohon Pilih Agama';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _jurusan,
              decoration: InputDecoration(labelText: 'Jurusan'),
              items: _jurusanList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.school),
                      SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _jurusan = value;
                });
              },
              validator: (value) {
                if (value == null) {
                 return 'Mohon Pilih Jurusan';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _semester,
              decoration: InputDecoration(labelText: 'Semester'),
              items: _semesterList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.layers),
                      SizedBox(width: 10),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _semester = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Mohon Pilih Semester';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    child: const Text('Batal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
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