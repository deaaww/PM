// main.dart
void main(){
  List<Map<String, dynamic>> riwayat = [];
  
  // Simulasi beberapa input
  print("Perhitungan BMI")
  hitungBMI(170, 65, riwayat);
  hitungBMI(165, 75, riwayat);
  hitungBMI(180, 85, riwayat);
  
  // Tampilkan riwayat menggunakan perulangan 
  tampilkanRiwayat(riwayat);
}

void hitungBMI(double tinggiCm, double beratKg, List<Map<String, dynamic>> riwayat) {
  
  // Konversi tinggi dari cm ke m
  double tinggiM = tinggiCm / 100;
  
  // Hitung BMI
  double bmi = beratKg / (tinggiM * tinggiM);
  
  // Tentukan kategori menggunakan percabangan
  String kategori;
  if (bmi < 18.5) {
    kategori = "Kurus";
  } else if (bmi < 25) {
    kategori = "Normal";
  } else if (bmi < 30) {
    kategori = "Gemuk";
  } else { 
    kategori = "Obesitas";
  }
    
  // Simpan hasil ke riwayat
  riwayat.add({
    'tinggi': tinggiCm,
    'berat': beratKg,
    'bmi': bmi.toStringAsFixed(2),
    'kategori': kategori
  });

  print("Data berhasil ditambahkan: $tinggiCm cm, $beratKg kg -> $kategori");
}