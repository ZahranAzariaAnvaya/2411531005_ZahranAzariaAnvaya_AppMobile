import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../database/session.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/category_icon.dart';
import '../utils/formatters.dart';
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionModel> _transactions = [];
  bool _loading = true;
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DbHelper.instance.getTransactions(Session.user!.id);
    if (!mounted) return;
    setState(() {
      _transactions = data;
      _loading = false;
    });
  }

  // Dropdown
  List<String> get _categories {
    final list = _transactions.map((t) => t.category).toSet().toList()..sort();
    return ['Semua', ...list];
  }

  // Transaksi setelah difilter berdasarkan kategori terpilih
  List<TransactionModel> get _filtered => _selectedCategory == 'Semua'
      ? _transactions
      : _transactions.where((t) => t.category == _selectedCategory).toList();

  int get _totalIncome =>
      _filtered.where((t) => t.isIncome).fold(0, (sum, t) => sum + t.amount);

  int get _totalExpense =>
      _filtered.where((t) => !t.isIncome).fold(0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : _transactions.isEmpty
          ? const Center(child: Text('Belum ada transaksi'))
          : Column(
              children: [
                // Filter kategori (dropdown)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Filter Kategori',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedCategory = newValue!);
                    },
                  ),
                ),
                // Ringkasan (mengikuti filter)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummary(
                          'Pemasukan',
                          _totalIncome,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSummary(
                          'Pengeluaran',
                          _totalExpense,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                // Daftar transaksi
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text('Tidak ada transaksi di kategori ini'),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) =>
                              _buildTile(context, filtered[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummary(String label, int amount, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              formatRupiah(amount),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, TransactionModel t) {
    final color = t.isIncome ? Colors.green : Colors.red;
    final amountText = formatSigned(t.amount, t.isIncome);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: t.isIncome ? Colors.green : Colors.redAccent,
        child: Icon(iconForCategory(t.category), color: Colors.white),
      ),
      title: Text(t.title),
      subtitle: Text('${t.category} • ${formatDate(t.date)}'),
      trailing: Text(
        amountText,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionDetailScreen(
              title: t.title,
              amount: amountText,
              isIncome: t.isIncome,
              category: t.category,
              date: formatDate(t.date),
            ),
          ),
        );
      },
    );
  }
}
