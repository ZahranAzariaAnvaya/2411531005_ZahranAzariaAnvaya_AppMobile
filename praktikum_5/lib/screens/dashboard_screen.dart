import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../database/session.dart';
import '../models/transaction_model.dart';
import '../utils/app_colors.dart';
import '../utils/category_icon.dart';
import '../utils/formatters.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _user = Session.user!;
  List<TransactionModel> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DbHelper.instance.getTransactions(_user.id);
    if (!mounted) return;
    setState(() {
      _transactions = data;
      _loading = false;
    });
  }

  int get _balance => _transactions.fold(
    0,
    (sum, t) => sum + (t.isIncome ? t.amount : -t.amount),
  );

  /// Membuka form lewat Named Route '/add', lalu muat ulang jika ada yang disimpan.
  Future<void> _openAddForm({bool isIncome = false, String? category}) async {
    final saved = await Navigator.pushNamed(
      context,
      '/add',
      arguments: AddTransactionArgs(isIncome: isIncome, category: category),
    );
    if (saved == true && mounted) _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Keuangan')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Memanggil Rute yang sudah didaftarkan di main.dart
          _openAddForm();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : RefreshIndicator(
              onRefresh: _loadTransactions,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GreetingWidget(name: _user.name, email: _user.email),
                    const SizedBox(height: 20),
                    BalanceCardWidget(balance: _balance),
                    const SizedBox(height: 20),
                    ActionButtonsWidget(
                      onIncome: () =>
                          _openAddForm(isIncome: true, category: 'Gaji'),
                      onExpense: () => _openAddForm(),
                    ),
                    const SizedBox(height: 20),
                    RecentTransactionsWidget(transactions: _transactions),
                  ],
                ),
              ),
            ),
    );
  }
}

// Sapaan
class GreetingWidget extends StatelessWidget {
  final String name;
  final String email;

  const GreetingWidget({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: kPrimary,
          child: Icon(Icons.person, size: 30, color: kOnPrimary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Kartu Saldo
class BalanceCardWidget extends StatefulWidget {
  final int balance;

  const BalanceCardWidget({super.key, required this.balance});

  @override
  State<BalanceCardWidget> createState() => _BalanceCardWidgetState();
}

class _BalanceCardWidgetState extends State<BalanceCardWidget> {
  bool _isBalanceVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: kPrimary,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saldo Utama',
                    style: TextStyle(fontSize: 16, color: kOnPrimarySoft),
                  ),
                  IconButton(
                    icon: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: kOnPrimary,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _isBalanceVisible
                    ? formatRupiah(widget.balance)
                    : 'Rp *********',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kOnPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'No. Rekening: 1234-5678',
                style: TextStyle(fontSize: 14, color: kOnPrimarySoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tombol Aksi
class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onIncome;
  final VoidCallback onExpense;

  const ActionButtonsWidget({
    super.key,
    required this.onIncome,
    required this.onExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          Icons.arrow_downward,
          'Pemasukan',
          Colors.green,
          onIncome,
        ),
        _buildActionButton(
          Icons.arrow_upward,
          'Pengeluaran',
          Colors.red,
          onExpense,
        ),
        _buildActionButton(Icons.swap_horiz, 'Transfer', Colors.blue, null),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(51), // ~20% opacity
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// Transaksi Terakhir
class RecentTransactionsWidget extends StatelessWidget {
  final List<TransactionModel> transactions;

  const RecentTransactionsWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final recent = transactions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaksi Terakhir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Belum ada transaksi. Tekan tombol + untuk menambah.',
                ),
              ),
            ),
          )
        else
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (int i = 0; i < recent.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _buildTile(context, recent[i]),
                ],
              ],
            ),
          ),
      ],
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
      subtitle: Text(formatDate(t.date)),
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
