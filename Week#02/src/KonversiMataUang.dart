import 'dart:io';

void main() {
  const kurs = {
    'IDR': 1.0,
    'USD': 16826.52,
    'EUR': 19829.47,
    'SGD': 13280.21,
  };

  print('\n-------------------------------------');
  print('|        KONVERSI MATA UANG         |');
  print('-------------------------------------');

  print('Pilih mata uang asal:');
  print('1. IDR (Rupiah)');
  print('2. USD (Dolar AS)');
  print('3. EUR (Euro)');
  print('4. SGD (Dolar Singapura)');

  stdout.write('\nMasukkan pilihan (1-4): ');
  String pilihan = stdin.readLineSync()!;
  
  String mataUangAsal = '';

  switch (pilihan) {
    case '1':
      mataUangAsal = 'IDR';
      break;
    case '2':
      mataUangAsal = 'USD';
      break;
    case '3':
      mataUangAsal = 'EUR';
      break;
    case '4':
      mataUangAsal = 'SGD';
      break;
    default:
      mataUangAsal = '';
  }

  if (kurs.containsKey(mataUangAsal)) {
    
    stdout.write('Masukkan nominal uang : ');
    double nominal = double.parse(stdin.readLineSync()!);
  
    //ubah input jadi IDR
    double nilaiIdr = nominal * kurs[mataUangAsal]!;

    //hitung nilai ke mata uang lain
    double keUsd = nilaiIdr / kurs['USD']!;
    double keEur = nilaiIdr / kurs['EUR']!;
    double keSgd = nilaiIdr / kurs['SGD']!;
    double keIdr = nilaiIdr;

    print('\nHASIL KONVERSI DARI $nominal $mataUangAsal');

    if (mataUangAsal != 'IDR') print('IDR : Rp ${keIdr.toStringAsFixed(2)}');
    if (mataUangAsal != 'USD') print('USD : \$ ${keUsd.toStringAsFixed(2)}');
    if (mataUangAsal != 'EUR') print('EUR : € ${keEur.toStringAsFixed(2)}');
    if (mataUangAsal != 'SGD') print('SGD : S\$ ${keSgd.toStringAsFixed(2)}'); 

  } else {
    print('\nPilihan tidak valid!');
  }
}