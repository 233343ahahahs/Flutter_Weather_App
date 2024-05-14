import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/HomeScree.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            'https://img.freepik.com/premium-vector/sun-cloud-with-rain-weather-cartoon-vector_864013-1015.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'We show weather for you',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _navigateToHome,
                  child: Text('Skip'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
