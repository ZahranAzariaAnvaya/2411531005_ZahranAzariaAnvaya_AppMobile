import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Kalkulator Kabataku')),
        body: const Kalkulator(),
      ),
    );
  }
}

class Kalkulator extends StatefulWidget {
  const Kalkulator({super.key});

  @override
  State<Kalkulator> createState() => _KalkulatorState();
}

class _KalkulatorState extends State<Kalkulator> {
  final _angkaPertamaController = TextEditingController();
  final _angkaKeduaController = TextEditingController();

  String _hasil = 'Belum ada perhitungan';

  @override
  void dispose() {
    _angkaPertamaController.dispose();
    _angkaKeduaController.dispose();
    super.dispose();
  }

  void _hitung(String operasi) {
    final angkaPertama = double.tryParse(
      _angkaPertamaController.text.trim().replaceAll(',', '.'),
    );

    final angkaKedua = double.tryParse(
      _angkaKeduaController.text.trim().replaceAll(',', '.'),
    );

    if (angkaPertama == null || angkaKedua == null) {
      setState(() {
        _hasil = 'Masukkan dua angka yang valid';
      });
      return;
    }

    if (operasi == '/' && angkaKedua == 0) {
      setState(() {
        _hasil = 'Tidak dapat membagi dengan nol';
      });
      return;
    }

    double hasilHitung;

    switch (operasi) {
      case '+':
        hasilHitung = angkaPertama + angkaKedua;
        break;
      case '-':
        hasilHitung = angkaPertama - angkaKedua;
        break;
      case '*':
        hasilHitung = angkaPertama * angkaKedua;
        break;
      case '/':
        hasilHitung = angkaPertama / angkaKedua;
        break;
      default:
        return;
    }

    setState(() {
      _hasil = '$angkaPertama $operasi $angkaKedua = $hasilHitung';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _angkaPertamaController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Angka pertama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _angkaKeduaController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Angka kedua',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  _hitung('*');
                },
                child: const Text('Kali'),
              ),
              ElevatedButton(
                onPressed: () {
                  _hitung('/');
                },
                child: const Text('Bagi'),
              ),
              ElevatedButton(
                onPressed: () {
                  _hitung('+');
                },
                child: const Text('Tambah'),
              ),
              ElevatedButton(
                onPressed: () {
                  _hitung('-');
                },
                child: const Text('Kurang'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Hasil: $_hasil', style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
