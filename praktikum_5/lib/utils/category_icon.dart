import 'package:flutter/material.dart';

IconData iconForCategory(String category) {
  switch (category) {
    case 'Makanan':
      return Icons.fastfood;
    case 'Transportasi':
      return Icons.directions_car;
    case 'Hiburan':
      return Icons.movie;
    case 'Transfer':
      return Icons.swap_horiz;
    case 'Gaji':
      return Icons.attach_money;
    default:
      return Icons.receipt_long;
  }
}
