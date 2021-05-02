import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  final Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  WeatherModel _weatherModel;

  getWeatherData({LocationData locationData}) async {
    if (locationData != null)
      await _weatherService
          .getWeatherService(
              latitude: locationData.latitude,
              longitude: locationData.longitude)
          .then((response) {
        Map body = jsonDecode(response.body);
        debugPrint('$body');
        if (response.statusCode == 200) {
          _weatherModel = WeatherModel.fromJson(body);
        } else {
          _weatherModel = null;
        }
      }).catchError((onError) {
        _weatherModel = null;
      }).timeout(Duration(seconds: 60), onTimeout: () {
        _weatherModel = null;
      });
    setState(() {});
  }

//we are asking for permission
  askPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();
    getWeatherData(locationData: _locationData);
  }

  @override
  void initState() {
    askPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
      body: FutureBuilder<WeatherModel>(
          future: Future.value(_weatherModel),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(child: Text('No weather data available'));
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.data == null) {
                  return Center(child: Text('No weather data available'));
                }
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Text(
                              '${snapshot.data.list[0].weather[0].main}',
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            '${snapshot.data.city.name},${snapshot.data.city.country}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                            image: NetworkImage(
                                'http://openweathermap.org/img/wn/${snapshot.data.list[0].weather[0].icon}@4x.png'),
                          ),
                          Text('${snapshot.data.list[0].temp.day}°',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 21)),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next day',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Image(
                            image: NetworkImage(
                                'http://openweathermap.org/img/wn/${snapshot.data.list[1].weather[0].icon}@2x.png'),
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '${snapshot.data.list[1].temp.day}°',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                );
            }
          }),
    );
  }
}
