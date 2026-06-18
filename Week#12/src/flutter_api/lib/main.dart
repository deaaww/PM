import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'accuweather_screen.dart';
import 'firebase_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Cuaca Terintegrasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  
  static _MainScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<_MainScreenState>()!;
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Posisi asli GPS pengguna (Malang sebagai nilai sementara saat loading)
  String gpsLocationKey = "202235";
  String gpsCityName = "Malang";

  // Kota yang sedang tampil di layar utama
  String locationKey = "202235";
  String cityName = "Mencari Lokasi...";
  bool isGpsLoaded = false;
  
  final String apiKey = "zpka_a13e2e492f654b98b712084623832ae6_89c3e275"; 

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _fallbackToDefault();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _fallbackToDefault();
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _fallbackToDefault();
      return;
    } 

    try {
      Position position = await Geolocator.getCurrentPosition();
      await _fetchCityFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      _fallbackToDefault();
    }
  }

  Future<void> _fetchCityFromCoordinates(double lat, double lng) async {
    final url = Uri.parse("https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=$apiKey&q=$lat,$lng&language=id-ID");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          gpsLocationKey = data['Key'];
          gpsCityName = data['LocalizedName'];
          locationKey = data['Key'];
          cityName = data['LocalizedName'];
          isGpsLoaded = true;
        });
      } else {
        _fallbackToDefault();
      }
    } catch (e) {
      _fallbackToDefault();
    }
  }

  void _fallbackToDefault() {
    setState(() {
      gpsLocationKey = "202235";
      gpsCityName = "Malang";
      locationKey = "202235";
      cityName = "Malang";
      isGpsLoaded = true;
    });
  }

  void setLocation(String key, String name) {
    setState(() {
      locationKey = key;
      cityName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGpsLoaded) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text("Melacak Lokasi Anda...", style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: AccuWeatherScreen(
        locationKey: locationKey, 
        cityName: cityName,
        gpsLocationKey: gpsLocationKey,
        gpsCityName: gpsCityName,
        onCitySelected: setLocation,
      ),
    );
  }
}
