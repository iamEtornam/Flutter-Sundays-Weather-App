

import 'package:http/http.dart' as http;
import 'package:weather_app/utils/api_keys.dart';

class WeatherService {
  String _endpoint({double latitude, double longitude}) {
    return 'https://api.openweathermap.org/data/2.5/forecast/daily?lat=$latitude&lon=$longitude&units=metric&cnt=2&appid=$apiKey';
  }

  Future<http.Response> getWeatherService(
      {double latitude, double longitude}) async {
    http.Response _response =
        await http.get(_endpoint(longitude: longitude, latitude: latitude));
    return _response;
  }

}
