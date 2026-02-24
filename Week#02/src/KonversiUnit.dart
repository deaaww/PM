import 'dart:io';

void main() {
  //map faktor konversi ke unit dasar
  const Map<String, double> konversiPanjang = {
    'KM': 1000.0,
    'M': 1.0,
    'CM': 0.01,
    'MM': 0.001,
    'INCH': 0.0254,
  };

  const Map<String, double> konversiMassa = {
    'KG': 1000.0,
    'HG': 100.0,
    'G': 1.0,
    'MG': 0.001,
    'LBS': 453.592,
  };

  const Map<String, double> konversiVolume = {
    'M3': 1000.0,
    'L': 1.0,
    'DL': 0.1,
    'CL': 0.01,
    'ML': 0.001,
  };

  print('\n----------------------------------');
  print('|          KONVERSI UNIT         |');
  print('----------------------------------');
  print('Pilih Kategori Konversi:');
  print('1. Panjang');
  print('2. Massa');
  print('3. Volume');
  print('4. Suhu');
  
  stdout.write('\nMasukkan Pilihan (1-4): ');
  String? kategori = stdin.readLineSync();

  print('-------------------------------------');

  switch (kategori) {
    case '1':
      prosesKonversiGeneric("PANJANG", konversiPanjang);
      break;
    case '2':
      prosesKonversiGeneric("MASSA", konversiMassa, allowNegative: false);
      break;
    case '3':
      prosesKonversiGeneric("VOLUME", konversiVolume, allowNegative: false);
      break;
    case '4':
      prosesKonversiSuhu();
      break;
    default:
      print('Pilihan tidak valid!');
  }
}

//fungsi generic untuk panjang, massa, dan volume
void prosesKonversiGeneric(String nama, Map<String, double> unitMap, {bool allowNegative = true}) {
  print('Unit yang tersedia: ${unitMap.keys.join(', ')}');
  
  stdout.write('Pilih Unit Asal   : ');
  String asal = stdin.readLineSync()!.toUpperCase();
  
  stdout.write('Masukkan Nilai    : ');
  double nilai = double.parse(stdin.readLineSync()!);

  if (!allowNegative && nilai < 0) {
    print('\n[ERROR] Nilai $nama tidak boleh negatif!');
    return;
  }

  print('-------------------------------------');

  if (unitMap.containsKey(asal)) {
    double nilaiDasar = nilai * unitMap[asal]!;
   
    print('\nHASIL KONVERSI $nama');
    print('Input: $nilai $asal');
    
    unitMap.forEach((unit, faktor) {
      if (unit != asal) {
        double hasil = nilaiDasar / faktor;
        print('$unit : ${hasil.toStringAsFixed(4)}');
      }
    });
    print('-------------------------------------');
  } else {
    print('Unit tidak ditemukan!');
  }
}

//fungsi untuk suhu
void prosesKonversiSuhu() {
  print('Unit: CELSIUS, FAHRENHEIT, KELVIN, REAMUR');
  stdout.write('Pilih Unit Asal (C/F/K/R): ');
  String asal = stdin.readLineSync()!.toUpperCase();
  
  stdout.write('Masukkan Nilai Suhu: ');
  double n = double.parse(stdin.readLineSync()!);

  double c; //Celsius sebagai unit dasar
  
  if (asal == 'C') c = n;
  else if (asal == 'F') c = (n - 32) * 5 / 9;
  else if (asal == 'K') c = n - 273.15;
  else if (asal == 'R') c = n * 5 / 4;
  else {
    print('Unit tidak valid!');
    return;
  }

  print('\n-------------------------------------');
  print('|      HASIL KONVERSI SUHU          |');
  print('-------------------------------------');
  print('Celsius    : ${c.toStringAsFixed(2)} °C');
  print('Fahrenheit : ${(c * 9 / 5 + 32).toStringAsFixed(2)} °F');
  print('Kelvin     : ${(c + 273.15).toStringAsFixed(2)} K');
  print('Reamur     : ${(c * 4 / 5).toStringAsFixed(2)} °R');
  print('-------------------------------------');
}