import 'dart:io';

void main() {

  print('\n-----------------------------');
  print('|   BMI (Body Mass Index)   |');
  print('-----------------------------');

  stdout.write('Masukkan Nama         : ');
  String nama = stdin.readLineSync()!;

  stdout.write('Masukkan Berat Badan  : '); //kg
  double berat = double.parse(stdin.readLineSync()!);

  stdout.write('Masukkan Tinggi Badan : '); //cm
  double tinggi = double.parse(stdin.readLineSync()!);

  print('-----------------------------');

  //konversi cm ke m
  double tinggiM = tinggi / 100;

  //hitung BMI: berat (kg) / tinggi (m)^2
  double bmi = berat / (tinggiM * tinggiM);

  String kategori;

  if (bmi < 18.5) {
    kategori = 'Berat Badan Kurang (Underweight)';
  } else if (bmi >= 18.5 && bmi < 25.0) {
    kategori = 'Normal (Ideal)';
  } else if (bmi >= 25.0 && bmi < 30.0) {
    kategori = 'Kelebihan Berat Badan (Overweight)';
  } else {
    kategori = 'Obesitas';
  }

  print('\n-----------------------------');
  print('|   HASIL KALKULATOR BMI    |');
  print('-----------------------------');
  print('Nama         : $nama');
  print('Berat Badan  : $berat kg');
  print('Tinggi Badan : $tinggi cm');
  print('BMI          : ${bmi.toStringAsFixed(2)}');
  print('Kategori     : $kategori');
  print('-----------------------------');
}