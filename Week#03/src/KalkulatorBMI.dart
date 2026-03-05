// main.dart
void main(){
  List<Map<String, dynamic>> riwayat = [];
  
  // Simulasi beberapa input
  print("\nPerhitungan BMI");
  hitungBMI(170, 65, riwayat);
  hitungBMI(165, 75, riwayat);
  hitungBMI(180, 85, riwayat);
  
  // Tampilkan riwayat menggunakan perulangan 
  tampilkanRiwayat(riwayat);
}

void hitungBMI(double tinggiCm, double beratKg, List<Map<String, dynamic>> riwayat) {
  
  // Validasi input
  if (tinggiCm <= 0 || beratKg <= 0) {
    print("Error: Tinggi Badan atau Berat Badang harus lebih dari 0!");
    return;
  }

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

void tampilkanRiwayat(List<Map<String, dynamic>> riwayat) {
  print("\nRiwayat Perhitungan BMI");

  if (riwayat.isEmpty) {
    print("Belum ada riwayat.");
    return;
  }

  for (var i = 0; i < riwayat.length; i++) {
    var data = riwayat[i];
    print("${i + 1}. Tinggi: ${data['tinggi']}cm | Berat: ${data['berat']}kg | BMI: ${data['bmi']} | kategori: ${data['kategori']}");
  }
}