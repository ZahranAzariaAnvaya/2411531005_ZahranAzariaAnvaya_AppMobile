import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 1. WIDGET UTAMA

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardScreen(),
    );
  }
}

// 2. HALAMAN UTAMA (SCAFFOLD) - DIPERBARUI

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 2: Layouting'),
        backgroundColor: Colors.blue,
      ),

      // Agar halaman dapat digulir jika isinya panjang
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingWidget(),
              SizedBox(height: 20),
              BalanceCardWidget(),
              SizedBox(height: 20),

              // Widget baru Modul 2
              ActionButtonsWidget(),
              SizedBox(height: 20),
              RecentTransactionsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. STATELESS WIDGET (SAPAAN PENGGUNA)

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Ikon profil
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 30, color: Colors.white),
        ),

        SizedBox(width: 12),

        // Teks sapaan
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, Zahran!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Selamat Datang Kembali!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

// 4. STATEFUL WIDGET (KARTU SALDO DENGAN TOGGLE)

class BalanceCardWidget extends StatefulWidget {
  const BalanceCardWidget({super.key});

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  bool _isBalanceVisible = true;

  // Fungsi untuk menampilkan atau menyembunyikan saldo
  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      // Hasil tugas Modul 1
      color: Colors.teal,

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas kartu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saldo Utama',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                // Tombol mata
                IconButton(
                  icon: Icon(
                    _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleBalanceVisibility,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Nominal saldo
            Text(
              _isBalanceVisible ? 'Rp 5.000.000' : 'Rp *********',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Hasil tugas Modul 1
            const SizedBox(height: 12),
            const Text(
              'No. Rekening: 1234-5678',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. WIDGET TOMBOL AKSI (ROW) - MODUL 2

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Row menyusun tombol secara horizontal
    return Row(
      // Membagi jarak antar tombol secara rata
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.arrow_downward, 'Pemasukan', Colors.green),
        _buildActionButton(Icons.arrow_upward, 'Pengeluaran', Colors.red),
        _buildActionButton(Icons.swap_horiz, 'Transfer', Colors.blue),
      ],
    );
  }

  // Fungsi pembantu untuk membuat desain tombol
  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        // Container pembungkus ikon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),

        const SizedBox(height: 8),

        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

// 6. WIDGET DAFTAR TRANSAKSI (COLUMN DAN LISTTILE)

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi Terakhir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        // Card pembungkus daftar transaksi
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Transaksi 1
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.fastfood, color: Colors.white),
                ),
                title: Text('Makan Siang'),
                subtitle: Text('13 Sep 2026'),

                // Pengeluaran berwarna merah
                trailing: Text(
                  '- Rp 50.000',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Transaksi 2
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.attach_money, color: Colors.white),
                ),
                title: Text('Gaji Bulanan'),
                subtitle: Text('01 Sep 2026'),

                // Pemasukan berwarna hijau
                trailing: Text(
                  '+ Rp 5.000.000',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Transaksi 3
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.directions_car, color: Colors.white),
                ),
                title: Text('Isi Bensin'),
                subtitle: Text('10 Sep 2026'),
                trailing: Text(
                  '- Rp 150.000',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Tugas 2: Transaksi fiktif baru pertama
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
                title: Text('Belanja Bulanan'),
                subtitle: Text('14 Sep 2026'),
                trailing: Text(
                  '- Rp 350.000',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Tugas 2: Transaksi fiktif baru kedua
              const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.work, color: Colors.white),
                ),
                title: Text('Bonus Freelance'),
                subtitle: Text('15 Sep 2026'),
                trailing: Text(
                  '+ Rp 750.000',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
