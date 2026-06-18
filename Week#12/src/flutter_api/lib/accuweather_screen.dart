import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'firebase_screen.dart';

class AccuWeatherScreen extends StatefulWidget {
  final String locationKey;
  final String cityName;
  final String gpsLocationKey;
  final String gpsCityName;
  final Function(String, String) onCitySelected;

  const AccuWeatherScreen({
    super.key, 
    required this.locationKey, 
    required this.cityName, 
    required this.gpsLocationKey,
    required this.gpsCityName,
    required this.onCitySelected
  });

  @override
  State<AccuWeatherScreen> createState() => _AccuWeatherScreenState();
}

class _AccuWeatherScreenState extends State<AccuWeatherScreen> {
  final String apiKey = "zpka_a13e2e492f654b98b712084623832ae6_89c3e275"; 
  
  bool isLoading = true;
  String errorMessage = "";

  // Data Cuaca Saat Ini
  String temperature = "--";
  String weatherText = "Memuat data...";
  int weatherIcon = 1;
  String realFeel = "--";
  String humidity = "--";
  String windSpeed = "--";
  String uvIndex = "--";
  String pressure = "--";

  // Data Ramalan Cuaca
  List<dynamic> hourlyForecast = [];
  List<dynamic> dailyForecast = [];

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  @override
  void didUpdateWidget(AccuWeatherScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locationKey != widget.locationKey) {
      fetchAllData();
    }
  }

  Future<void> fetchAllData() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    
    final currentUrl = Uri.parse("https://dataservice.accuweather.com/currentconditions/v1/${widget.locationKey}?apikey=$apiKey&language=id-ID&details=true");
    final hourlyUrl = Uri.parse("https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/${widget.locationKey}?apikey=$apiKey&language=id-ID&metric=true");
    final dailyUrl = Uri.parse("https://dataservice.accuweather.com/forecasts/v1/daily/5day/${widget.locationKey}?apikey=$apiKey&language=id-ID&metric=true");

    try {
      final currentRes = await http.get(currentUrl);
      final hourlyRes = await http.get(hourlyUrl);
      final dailyRes = await http.get(dailyUrl);

      if (currentRes.statusCode == 200 && hourlyRes.statusCode == 200 && dailyRes.statusCode == 200) {
        final currentData = json.decode(currentRes.body);
        final hourlyData = json.decode(hourlyRes.body);
        final dailyData = json.decode(dailyRes.body);

        if (currentData.isNotEmpty) {
          final c = currentData[0];
          temperature = "${c['Temperature']['Metric']['Value'].round()}";
          weatherText = c['WeatherText'];
          weatherIcon = c['WeatherIcon'] ?? 1;
          realFeel = "${c['RealFeelTemperature']['Metric']['Value'].round()}°";
          humidity = "${c['RelativeHumidity']}%";
          windSpeed = "${c['Wind']['Speed']['Metric']['Value']} km/j";
          uvIndex = "${c['UVIndex']} (${c['UVIndexText']})";
          pressure = "${c['Pressure']['Metric']['Value']} mb";
        }

        hourlyForecast = hourlyData;
        dailyForecast = dailyData['DailyForecasts'];

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Gagal mengambil data dari server.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Gagal memuat. Pastikan Anda terkoneksi ke internet.\n\nDetail: $e";
      });
    }
  }

  IconData _getWeatherIcon(int iconCode) {
    if (iconCode >= 1 && iconCode <= 5) return Icons.wb_sunny_rounded; 
    if (iconCode >= 6 && iconCode <= 11) return Icons.cloud_rounded; 
    if (iconCode >= 12 && iconCode <= 18) return Icons.water_drop_rounded; 
    if (iconCode >= 19 && iconCode <= 29) return Icons.ac_unit_rounded; 
    if (iconCode >= 30 && iconCode <= 44) return Icons.nights_stay_rounded; 
    return Icons.cloud_queue_rounded;
  }

  List<Color> _getWeatherBackground(int iconCode) {
    bool isNight = (iconCode >= 33 && iconCode <= 44);
    if (isNight) {
      return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)];
    }
    if (iconCode >= 1 && iconCode <= 5) return [const Color(0xFF2193b0), const Color(0xFF6dd5ed)];
    if (iconCode >= 6 && iconCode <= 11) return [const Color(0xFFbdc3c7), const Color(0xFF2c3e50)];
    if (iconCode >= 12 && iconCode <= 18) return [const Color(0xFF1488CC), const Color(0xFF2B32B2)];
    return [const Color(0xFF2193b0), const Color(0xFF6dd5ed)]; 
  }

  String _formatTime(String isoTime) {
    // Ambil string jam langsung dari API, abaikan timezone emulator/perangkat
    if (isoTime.contains('T')) {
      return isoTime.split('T')[1].substring(0, 5);
    }
    return isoTime;
  }

  String _getDayName(String isoTime) {
    final dt = DateTime.parse(isoTime);
    final today = DateTime.now();
    if (dt.day == today.day && dt.month == today.month) return "Hari ini";
    if (dt.day == today.add(const Duration(days: 1)).day) return "Besok";
    
    switch (dt.weekday) {
      case 1: return "Senin";
      case 2: return "Selasa";
      case 3: return "Rabu";
      case 4: return "Kamis";
      case 5: return "Jumat";
      case 6: return "Sabtu";
      case 7: return "Minggu";
      default: return "";
    }
  }

  String _getCurrentDateString() {
    final now = DateTime.now();
    final List<String> months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
    final List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
  }

  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColors = _getWeatherBackground(weatherIcon);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: bgColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
            : RefreshIndicator(
                onRefresh: fetchAllData,
                color: Colors.blueAccent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // 1. Lokasi & Refresh
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FirebaseScreen(
                                        onCitySelected: widget.onCitySelected,
                                        defaultLocationKey: widget.gpsLocationKey,
                                        defaultCityName: widget.gpsCityName,
                                      ),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.white, size: 20),
                                      const SizedBox(width: 6),
                                      Text(widget.cityName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_getCurrentDateString(), style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(width: 28),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // 2. Header Suhu Besar
                          Text(
                            "$temperature°",
                            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w300, color: Colors.white, height: 1.0),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            weatherText,
                            style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("Terasa seperti $realFeel", style: const TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                          const SizedBox(height: 50),
                          
                          // 3. Ramalan 12 Jam (Hourly)
                          if (hourlyForecast.isNotEmpty)
                            _buildGlassCard(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16, bottom: 12),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time, color: Colors.white70, size: 18),
                                        SizedBox(width: 8),
                                        Text("Ramalan 12 jam", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  const Divider(color: Colors.white24, height: 1),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: hourlyForecast.length,
                                      itemBuilder: (context, index) {
                                        final hour = hourlyForecast[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                index == 0 ? "Sekarang" : "${(DateTime.now().hour + index) % 24}".padLeft(2, '0') + ":00", 
                                                style: const TextStyle(color: Colors.white, fontSize: 16)
                                              ),
                                              const SizedBox(height: 8),
                                              Icon(_getWeatherIcon(hour['WeatherIcon']), color: Colors.white, size: 24),
                                              const SizedBox(height: 8),
                                              Text("${hour['Temperature']['Value'].round()}°", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),

                          // 4. Ramalan 5 Hari (Daily)
                          if (dailyForecast.isNotEmpty)
                            _buildGlassCard(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month, color: Colors.white70, size: 18),
                                        SizedBox(width: 8),
                                        Text("Ramalan 5 hari", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  const Divider(color: Colors.white24, height: 1),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: dailyForecast.length,
                                    separatorBuilder: (context, index) => const Divider(color: Colors.white12, height: 1),
                                    itemBuilder: (context, index) {
                                      final day = dailyForecast[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(_getDayName(day['Date']), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Icon(_getWeatherIcon(day['Day']['Icon']), color: Colors.white, size: 22),
                                                  const SizedBox(width: 8),
                                                  Expanded(child: Text(day['Day']['IconPhrase'], style: const TextStyle(color: Colors.white70, fontSize: 14), overflow: TextOverflow.ellipsis)),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                "${day['Temperature']['Maximum']['Value'].round()}° / ${day['Temperature']['Minimum']['Value'].round()}°",
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),

                          // 5. Grid Detail Cuaca (Angin, Kelembapan, UV, Tekanan)
                          Row(
                            children: [
                              Expanded(
                                child: _buildGlassCard(
                                  padding: const EdgeInsets.all(20),
                                  child: _buildDetailItem(Icons.air, "Angin", windSpeed),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildGlassCard(
                                  padding: const EdgeInsets.all(20),
                                  child: _buildDetailItem(Icons.water_drop_outlined, "Kelembapan", humidity),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildGlassCard(
                                  padding: const EdgeInsets.all(20),
                                  child: _buildDetailItem(Icons.wb_sunny_outlined, "Indeks UV", uvIndex),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildGlassCard(
                                  padding: const EdgeInsets.all(20),
                                  child: _buildDetailItem(Icons.speed, "Tekanan", pressure),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          const Text("Data disediakan oleh AccuWeather", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
