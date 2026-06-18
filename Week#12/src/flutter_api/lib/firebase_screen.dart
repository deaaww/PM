import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseScreen extends StatefulWidget {
  final Function(String, String) onCitySelected;
  final String defaultLocationKey;
  final String defaultCityName;

  const FirebaseScreen({
    super.key, 
    required this.onCitySelected,
    required this.defaultLocationKey,
    required this.defaultCityName,
  });

  @override
  State<FirebaseScreen> createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  final String firebaseUrl = "https://flutter-api-app-951e9-default-rtdb.asia-southeast1.firebasedatabase.app"; 
  final String apiKey = "zpka_a13e2e492f654b98b712084623832ae6_89c3e275"; 

  List<Map<String, dynamic>> cities = [];
  late Map<String, dynamic> defaultLocation;
  
  bool isLoading = true;
  bool isAdding = false;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    defaultLocation = {
      'id': 'default',
      'text': 'Lokasi Anda (${widget.defaultCityName})',
      'locationKey': widget.defaultLocationKey,
      'temp': '--',
      'weatherText': 'Mengambil data...',
      'isDefault': true,
    };
    fetchCities();
  }

  Future<void> fetchCities() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("$firebaseUrl/notes.json"); 
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body != "null") {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Map<String, dynamic>> loadedCities = [];
        data.forEach((key, value) {
          loadedCities.add({
            'id': key,
            'text': value['text'] ?? "Unknown",
            'locationKey': value['locationKey'] ?? "202235",
            'temp': "--",
            'weatherText': "Mengambil data...",
            'isDefault': false,
          });
        });
        setState(() {
          cities = loadedCities;
          isLoading = false;
        });
        
        _fetchTemperatures();
      } else {
        setState(() {
          cities = [];
          isLoading = false;
        });
        _fetchTemperatures(); // Tetap fetch suhu untuk default location
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _fetchTemperatures(); // Tetap fetch suhu untuk default location
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error memuat kota: $error")));
    }
  }

  Future<void> _fetchTemperatures() async {
    // Ambil suhu lokasi pengguna lebih dulu
    _fetchSingleTemp(defaultLocation, (updated) {
      if (mounted) setState(() { defaultLocation = updated; });
    });

    for (int i = 0; i < cities.length; i++) {
      if (!mounted) return;
      _fetchSingleTemp(cities[i], (updated) {
        if (mounted) setState(() { cities[i] = updated; });
      });
    }
  }

  Future<void> _fetchSingleTemp(Map<String, dynamic> city, Function(Map<String, dynamic>) onUpdate) async {
    final locKey = city['locationKey'];
    final url = Uri.parse("https://dataservice.accuweather.com/currentconditions/v1/$locKey?apikey=$apiKey&language=id-ID");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final cData = json.decode(res.body);
        if (cData.isNotEmpty) {
          city['temp'] = "${cData[0]['Temperature']['Metric']['Value'].round()}°";
          city['weatherText'] = cData[0]['WeatherText'] ?? "";
          onUpdate(city);
        }
      }
    } catch (e) {}
  }

  Future<void> addCity(String query) async {
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama kota tidak boleh kosong!")));
      return;
    }
    setState(() {
      isAdding = true;
    });

    // 1. Cari Location Key di AccuWeather
    final searchUrl = Uri.parse("https://dataservice.accuweather.com/locations/v1/cities/search?apikey=$apiKey&q=${query.trim()}&language=id-ID");
    try {
      final searchRes = await http.get(searchUrl);
      if (searchRes.statusCode == 200) {
        final searchData = json.decode(searchRes.body) as List<dynamic>;
        if (searchData.isNotEmpty) {
          final locKey = searchData[0]['Key'];
          final localizedName = searchData[0]['LocalizedName'];

          // 2. Simpan ke Firebase
          final fbUrl = Uri.parse("$firebaseUrl/notes.json");
          final res = await http.post(
            fbUrl,
            body: json.encode({
              'text': localizedName,
              'locationKey': locKey,
              'timestamp': DateTime.now().toIso8601String(),
            }),
          );

          if (res.statusCode == 200) {
            _cityController.clear();
            await fetchCities();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kota tidak ditemukan di server AccuWeather.")));
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
    }

    setState(() {
      isAdding = false;
    });
  }

  Future<void> deleteCity(String id) async {
    final url = Uri.parse("$firebaseUrl/notes/$id.json");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        fetchCities();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error menghapus kota: $error")));
    }
  }

  List<Color> _getDynamicBackground() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 18) {
      return [const Color(0xFF2193b0), const Color(0xFF6dd5ed)]; // Siang
    } else {
      return [const Color(0xFF0F2027), const Color(0xFF203A43)]; // Malam
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getDynamicBackground(),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
        child: Column(
          children: [
          // Header / Info
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Kelola kota",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Colors.white54, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Masukkan lokasi",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (val) {
                        if (!isAdding) addCity(val);
                      },
                    ),
                  ),
                  if (isAdding)
                    const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2)),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white54),
                      onPressed: () => addCity(_cityController.text),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // List Kota
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white54))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: cities.length + 1, // +1 for default location
                    itemBuilder: (context, index) {
                      final city = index == 0 ? defaultLocation : cities[index - 1];
                      final isDefault = city['isDefault'] == true;

                      return GestureDetector(
                        onTap: () {
                          widget.onCitySelected(city['locationKey'], city['text'].toString().replaceAll("Lokasi Anda (", "").replaceAll(")", ""));
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                          decoration: BoxDecoration(
                            gradient: isDefault 
                                ? const LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)]) 
                                : const LinearGradient(colors: [Color(0xFF283048), Color(0xFF859398)]),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: isDefault ? Colors.white38 : Colors.white24, width: 1.5),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4))],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        city['text'],
                                        style: TextStyle(
                                          fontSize: isDefault ? 18 : 20,
                                          fontWeight: isDefault ? FontWeight.bold : FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(isDefault ? Icons.my_location : Icons.location_on, color: Colors.white, size: 14),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    city['weatherText'] ?? "Memuat...",
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    city['temp'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  if (!isDefault) ...[
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () => deleteCity(city['id']),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white70, size: 16),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      )),
    );
  }
}
