import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../database/session.dart';
import '../models/transaction_model.dart';
import '../utils/formatters.dart';

/// Argumen yang dikirim lewat Navigator.pushNamed('/add', arguments: ...)
class AddTransactionArgs {
  final bool isIncome;
  final String? category;

  const AddTransactionArgs({this.isIncome = false, this.category});
}

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  static const List<String> _categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Transfer',
    'Gaji',
    'Lainnya',
  ];

  String _selectedCategory = 'Makanan';
  bool _isIncome = false;
  DateTime? _selectedDate;
  bool _saving = false;
  bool _argsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsLoaded) return;
    _argsLoaded = true;

    // Membaca argumen dari Named Route jika ada
    final raw = ModalRoute.of(context)?.settings.arguments;
    final args = raw is AddTransactionArgs ? raw : const AddTransactionArgs();

    _isIncome = args.isIncome;
    _selectedCategory =
        (args.category != null && _categories.contains(args.category))
        ? args.category!
        : (_isIncome ? 'Gaji' : 'Makanan');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  /// Input tanggal dengan showDatePicker + validasi
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatDateInput(picked);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await DbHelper.instance.insertTransaction(
      TransactionModel(
        userId: Session.user!.id,
        title: _titleController.text.trim(),
        amount: int.parse(_amountController.text.trim()),
        isIncome: _isIncome,
        category: _selectedCategory,
        date: _selectedDate!,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaksi Berhasil Disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
    // NAVIGASI POP: kembali ke Dashboard
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catat Transaksi")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Transaksi",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Judul transaksi tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nominal wajib diisi";
                  }
                  final n = int.tryParse(value.trim());
                  if (n == null) return "Harus berupa angka bulat yang valid";
                  if (n <= 0) return "Nominal harus lebih dari 0";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                value: _isIncome,
                decoration: const InputDecoration(
                  labelText: "Jenis",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.swap_vert),
                ),
                items: const [
                  DropdownMenuItem(value: false, child: Text('Pengeluaran')),
                  DropdownMenuItem(value: true, child: Text('Pemasukan')),
                ],
                onChanged: (val) => setState(() => _isIncome = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories
                    .map(
                      (c) => DropdownMenuItem<String>(value: c, child: Text(c)),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() => _selectedCategory = newValue!);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  labelText: "Tanggal Transaksi (DD/MM/YYYY)",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || _selectedDate == null) {
                    return "Tanggal wajib diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: const Text(
                  "Simpan Transaksi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
