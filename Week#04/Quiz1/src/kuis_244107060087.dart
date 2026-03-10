void main() {
  //identitas
  String nama = "Dea Marselia Rahma";
  String nim = "244107060087";

  //3 digit terakhir NIM (087)
  double nilaiUnikNIM = double.parse(nim.substring(nim.length - 3));

  //list harga barang
  List<double> hargaBarang = [67260.0, 54530.0, 35530.0, 62035.0, 90155.0];
  hargaBarang.add(nilaiUnikNIM); //tambah nilai unik NIM

  //null safety
  String? pesanDiskon;

  //hitung total awal
  double totalAwal = hitungTotal(hargaBarang);

  //logika diskon
  double diskon = 0.0;
  if (totalAwal > 200000) {
    diskon = 0.10;
    pesanDiskon = "Diskon 10% diterapkan";
  } else if (totalAwal >= 100000 && totalAwal <= 200000) {
    diskon = 0.05;
    pesanDiskon = "Diskon 5% diterapkan";
  } else {
    diskon = 0.0;
    pesanDiskon = "Tidak ada diskon";
  }

  //hitung total diskon
  double totalDiskon = totalAwal * diskon;

  //hitung total akhir
  double totalAkhir = totalAwal - totalDiskon;
  
  //output
  print("------------------------------------");
  print("|            Struk Toko            |");
  print("------------------------------------");
  print("Nama         : $nama");
  print("NIM          : $nim");
  print("------------------------------------");
  print("Total Awal   : Rp ${totalAwal.toStringAsFixed(2)}");
  print("Besar Diskon : Rp ${totalDiskon.toStringAsFixed(2)}");
  print("------------------------------------");
  print("Total Akhir  : Rp ${totalAkhir.toStringAsFixed(2)}");
  print("------------------------------------");
  print("Keterangan   : ${pesanDiskon!}");
  print("------------------------------------");
}

//fungsi hitung total belanja
double hitungTotal(List<double> daftarHarga) {
  double total = 0.0;
  for (double harga in daftarHarga) {
    total += harga;
  }
  return total;
}