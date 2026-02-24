import 'dart:io';

void main() {
  //harga menu
  const hargaEspresso = 25000;
  const hargaLatte = 35000;
  const hargaCroissant = 30000;
  const hargaToast = 45000;

  print('\n-----------------------------');
  print('|      BIBABU KAFE MENU     |');
  print('-----------------------------');
  print('1. Espresso      : Rp $hargaEspresso');
  print('2. Caramel Latte : Rp $hargaLatte');
  print('3. Croissant     : Rp $hargaCroissant');
  print('4. Avocado Toast : Rp $hargaToast');
  print('-----------------------------');

  //operator null aware
  stdout.write('\nMasukkan Nama Pelanggan : ');
  String? inputNama = stdin.readLineSync();
  String nama = (inputNama == null || inputNama.isEmpty) ? "Pelanggan Tanpa Nama" : inputNama;

  stdout.write('Pilih Nomor Menu (1-5) : ');
  String pilihan = stdin.readLineSync()!;

  String namaPesanan = '';
  int hargaSatuan = 0;

  switch (pilihan) {
    case '1':
      namaPesanan = 'Espresso';
      hargaSatuan = hargaEspresso;
      break;
    case '2':
      namaPesanan = 'Caramel Latte';
      hargaSatuan = hargaLatte;
      break;
    case '3':
      namaPesanan = 'Croissant';
      hargaSatuan = hargaCroissant;
      break;
    case '4':
      namaPesanan = 'Avocado Toast';
      hargaSatuan = hargaToast;
      break;
    default:
      namaPesanan = '';
  }

  if (namaPesanan != '') {
    stdout.write('Masukkan Jumlah Pesanan : ');
    int jumlah = int.parse(stdin.readLineSync()!);

    //operator aritmatika (*)
    num totalBelanja = hargaSatuan * jumlah;

    //operator relasional & logika (&&)
    bool dapatPromo = totalBelanja > 100000 && jumlah >= 3; 

    //operator kondisional (ternary)
    double diskon = dapatPromo ? totalBelanja * 0.1 : 0; 
    
    //operator penugasan (-=)
    num totalAkhir = totalBelanja;
    totalAkhir -= diskon;

    //simulasi increment
    int antrean = 10;
    antrean++; 

    //operator bitwise
    int encryptedCode = 5 ^ 3; 

    //struk
    print('\n-----------------------------');
    print('|      STRUK PEMBAYARAN     |');
    print('-----------------------------');
    print('No. Antrean  : $antrean');
    print('Nama         : $nama');
    print('Pesanan      : $namaPesanan');
    print('Jumlah       : $jumlah item');
    
    //operator type test (is)
    if (totalAkhir is double) {
      print('Total Awal   : Rp $totalBelanja');
    }

    print('Diskon (10%) : Rp ${diskon.toStringAsFixed(0)}');
    print('-----------------------------');
    print('TOTAL BAYAR  : Rp ${totalAkhir.toStringAsFixed(0)}');
    print('-----------------------------');
    print('Promo Log ID : $encryptedCode');
    print('\nTerima kasih!');
    print('-----------------------------');

  } else {
    print('\nPilihan tidak valid!');
  }
}