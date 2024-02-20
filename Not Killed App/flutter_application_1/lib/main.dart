import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String text = 'Hello World!';

  @override
  initState() {
    super.initState();
    initializeLocation();
  }

  Future<void> initializeLocation() async {
    try {
      final dio = Dio();
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            text = "No location service";
          });
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            text = "No permission";
          });
          return;
        }
      }
      await location.enableBackgroundMode(enable: true);
      await location.changeNotificationOptions(
        title: 'Geolocation',
        subtitle: 'Geolocation detection',
      );
      setState(() {
        text = "Starting listener";
      });
      location.onLocationChanged.listen((LocationData currentLocation) async {
        print("${currentLocation.latitude} --- ${currentLocation.longitude}");
        var result = await dio.get(
            "http://192.168.10.12:3000?latitude=${currentLocation.latitude}&longitude=${currentLocation.longitude}&date=${DateTime.now().toIso8601String()}");
        setState(() {
          text = result.data;
        });
      });
    } on PlatformException catch (err) {
      initializeLocation();
    } catch (e) {
      setState(() {
        text = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
