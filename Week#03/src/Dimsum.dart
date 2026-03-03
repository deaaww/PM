import 'dart:io';

void main() {
  int stok = 15;
  int hargaPerPorsi = 15000;

  print('\n-----------------------------------');
  print('|        KASIR DIMSUM ASOY        |');
  print('-----------------------------------');
  
  print('\nStok saat ini: $stok');

  stdout.write('Masukkan jumlah porsi: ');
  int? jumlah = int.tryParse(stdin.readLineSync() ?? '0');

  int total = (jumlah ?? 0) * hargaPerPorsi;
  stok -= (jumlah ?? 0); 

  print('\n-----------------------------------');
  print('|         NOTA PEMBAYARAN         |');
  print('-----------------------------------');
  print('Pesanan  : $jumlah porsi');
  print('Total    : Rp $total');
  print('Sisa Stok: $stok');
  print('-----------------------------------');
}