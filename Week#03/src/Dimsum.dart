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

      if (jumlah == null || jumlah <= 0) {
        print('Input tidak valid! Masukkan angka lebih dari 0.');
      } else if (jumlah > stok) {
        print('Maaf, stok tidak cukup! Tersisa $stok porsi.');
      } else {
        int total = jumlah * hargaPerPorsi;
        stok -= jumlah;

        print('\n-----------------------------------');
        print('|         NOTA PEMBAYARAN         |');
        print('-----------------------------------');
        print('Pesanan  : $jumlah porsi');
        print('Total    : Rp $total');
        print('Sisa Stok: $stok');
        print('-----------------------------------');
      }
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