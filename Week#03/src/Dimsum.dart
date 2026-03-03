import 'dart:io';

void main() {
  int stok = 15;
  int hargaPerPorsi = 15000;

  print('\n-----------------------------------');
  print('|        KASIR DIMSUM ASOY        |');
  print('-----------------------------------');
  
  while (true) {
    print('\nStok saat ini: $stok');
    print('\nMenu Utama');
    print('1. Pesan Dimsum');
    print('2. Keluar');
    stdout.write('\nPilih menu: ');
    String? input = stdin.readLineSync();

    if (input == '1') {
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
    } else if (input == '2') {
      print('Terima kasih!');
      print('-----------------------------------');
      break;
    } else {
      print('Pilihan tidak tersedia.');
      print('-----------------------------------');
    }
  }
}