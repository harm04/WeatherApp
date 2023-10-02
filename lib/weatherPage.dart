import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/additionalinformation.dart';
import 'package:weather_app/daycards.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  String cityname = 'Dahanu';
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    getCurrentWeather();
                  });
                },
                icon: const Icon(Icons.refresh)),
          )
        ],
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Weather App",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          final data = snapshot.data!;
          final currentweather = data['list'][0];
          final currentTemp = currentweather['main']['temp'] - 273;
          final currentsky = currentweather['weather'][0]['main'];
          final currenthumdity = currentweather['main']['humidity'];
          final currentpressure = currentweather['main']['pressure'];
          final currentwindspeed = currentweather['wind']['speed'];

          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: const Color(0xFF464343),
                      ),
                      width: double.infinity,
                      height: 230,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('$cityname'),
                            Padding(
                              padding: const EdgeInsets.only(top: 05, bottom: 10),
                              child: Text(
                                currentTemp.toStringAsFixed(1) + '°C',
                                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Icon(
                                currentsky == 'Clouds' || currentsky == 'Rain' ? Icons.cloud : Icons.sunny,
                                size: 90,
                              ),
                            ),
                            Text(
                              data['list'][0]['weather'][0]['description'],
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 15),
                    child: Text(
                      "Weather Forecast",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 30),
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            final time = DateTime.parse(data['list'][index + 1]['dt_txt']);
                            final date = DateTime.parse(data['list'][index + 1]['dt_txt']);
                            return DayCards(
                              time: DateFormat.j().format(time),
                              date: DateFormat.yMMMd().format(date),
                              icon: data['list'][index + 1]['weather'][0]['main'] == 'Clouds' || data['list'][index + 1]['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny,
                              temperature: data['list'][index + 1]['main']['temp'] - 273,
                            );
                          }),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 15),
                    child: Center(
                      child: Text(
                        "Additional Information",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AdditionalInformation(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currenthumdity.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentpressure.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentwindspeed.toString(),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
