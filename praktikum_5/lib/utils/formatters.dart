const List<String> _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// 5000000 -> "5.000.000"
String formatNumber(int value) {
  final s = value.abs().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// 5000000 -> "Rp 5.000.000" (negatif -> "- Rp ...")
String formatRupiah(int value) =>
    '${value < 0 ? '- ' : ''}Rp ${formatNumber(value)}';

/// Transaksi: "+ Rp 5.000.000" / "- Rp 50.000"
String formatSigned(int amount, bool isIncome) =>
    '${isIncome ? '+' : '-'} Rp ${formatNumber(amount)}';

/// DateTime -> "13 Sep 2026"
String formatDate(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

/// DateTime -> "13/09/2026" (untuk kolom input tanggal, format DD/MM/YYYY)
String formatDateInput(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
