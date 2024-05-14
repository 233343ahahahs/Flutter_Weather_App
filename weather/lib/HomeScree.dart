import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/SplashScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController locationController = TextEditingController();
  String location = '';
  String temperature = '';
  String weatherText = '';

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  _loadSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      location = prefs.getString('location') ?? '';
    });
    _getWeather();
  }

  _saveLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location', location);
  }

  _getWeather() async {
    String apiKey = '8220ead4c47c411782a62746241405';
    String apiUrl;

    if (location.isEmpty) {
      apiUrl =
          'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=auto:ip';
    } else {
      apiUrl =
          'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$location';
    }

    http.Response response = await http.get(Uri.parse(apiUrl));
    Map<String, dynamic> weatherData = jsonDecode(response.body);

    setState(() {
      temperature = weatherData['current']['temp_c'].toString();
      weatherText = weatherData['current']['condition']['text'];
    });
  }

  _handleSaveOrUpdate() {
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location cannot be empty!')),
      );
    } else {
      _saveLocation();
      _getWeather();
    }
  }

  _openHelpScreen() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Help Screen')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => SplashScreen())));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
              ),
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _handleSaveOrUpdate,
              child: Text(location.isEmpty ? 'Save' : 'Update'),
            ),
            SizedBox(height: 20.0),
            temperature.isEmpty
                ? SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Temperature: $temperature°C',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        'Weather: $weatherText',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
