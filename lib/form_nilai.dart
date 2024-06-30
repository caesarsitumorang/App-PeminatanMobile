import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormNilaiMahasiswa extends StatefulWidget {
  const FormNilaiMahasiswa({Key? key}) : super(key: key);

  @override
  _FormNilaiMahasiswaState createState() => _FormNilaiMahasiswaState();
}

class _FormNilaiMahasiswaState extends State<FormNilaiMahasiswa> {
  final _formKey = GlobalKey<FormState>();
  final _kodeNilaiController = TextEditingController();
  final _jumlahNilaiController = TextEditingController();
  final _nilaiHurufController = TextEditingController();
  String? _selectedMahasiswa;
  String? _selectedDosen;
  String? _selectedMatakuliah;

  List<dynamic> _mahasiswaList = [];
  List<dynamic> _dosenList = [];
  List<dynamic> _matakuliahList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://caesarjsitumorang.000webhostapp.com/mobileApp/simpan_nilai.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _mahasiswaList = data['mahasiswa'];
        _dosenList = data['dosen'];
        _matakuliahList = data['matakuliah'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        (Uri.parse('https://caesarjsitumorang.000webhostapp.com/mobileApp/simpan_nilai.php')),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'kode_nilai': _kodeNilaiController.text,
          'jumlah_nilai': double.parse(_jumlahNilaiController.text),
          'nama_mahasiswa': _selectedMahasiswa,
          'nama_dosen': _selectedDosen,
          'nama_matakuliah': _selectedMatakuliah,
          'nilai_huruf': _nilaiHurufController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan')),
          );
          // Reset form setelah berhasil disimpan
          _formKey.currentState!.reset();
          _kodeNilaiController.clear();
          _jumlahNilaiController.clear();
          _nilaiHurufController.clear();
          setState(() {
            _selectedMahasiswa = null;
            _selectedDosen = null;
            _selectedMatakuliah = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data gagal disimpan: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data: ${response.reasonPhrase}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Nilai Mahasiswa'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMahasiswa,
                items: _mahasiswaList.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['nama'].toString(),
                    child: Text(item['nama']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMahasiswa = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih nama mahasiswa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Nama Dosen',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDosen,
                items: _dosenList.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['nama'].toString(),
                    child: Text(item['nama']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDosen = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih nama dosen';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Nama Matakuliah',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMatakuliah,
                items: _matakuliahList.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['nama_matakuliah'].toString(),
                    child: Text(item['nama_matakuliah']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMatakuliah = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih nama matakuliah';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _kodeNilaiController,
                decoration: const InputDecoration(
                  labelText: 'Kode Nilai',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kode nilai';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _jumlahNilaiController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Nilai',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah nilai';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan nilai yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nilaiHurufController,
                decoration: const InputDecoration(
                  labelText: 'Nilai Huruf',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai huruf';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _kodeNilaiController.clear();
                      _jumlahNilaiController.clear();
                      _nilaiHurufController.clear();
                      setState(() {
                        _selectedMahasiswa = null;
                        _selectedDosen = null;
                        _selectedMatakuliah = null;
                      });
                    },
                    child: const Text('Batal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
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
