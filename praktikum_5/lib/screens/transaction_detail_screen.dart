import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class TransactionDetailScreen extends StatelessWidget {
  // Data diterima lewat constructor (Passing Data)
  final String title;
  final String amount;
  final bool isIncome;
  final String category;
  final String date;

  const TransactionDetailScreen({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: kPrimary[700]),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            const Divider(height: 40, thickness: 2),
            _buildDetailRow('Kategori', category),
            const SizedBox(height: 16),
            _buildDetailRow('Tanggal', date),
            const SizedBox(height: 16),
            _buildDetailRow('Status', 'Berhasil'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
