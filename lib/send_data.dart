import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SendView extends StatefulWidget {
  SendView({Key? key, required this.token, required this.data})
      : super(key: key);

  final String data;
  final String token;

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  String latLong = "";
  bool success = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.data,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                success ? "Yoklama gecerli" : "Yoklama gecersiz",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await send();
                  },
                  child: const Text('Yokla', style: TextStyle(fontSize: 20)),
                ),
              ),
            ]),
      ),
    );
  }

  Future<void> send() async {
    var result = await _determinePosition();
    print(result);
    String lat = result.latitude.toString();
    String long = result.longitude.toString();

    Dio dio = Dio();
    //authorization token
    var response = await dio.post(
        'https://oguzhantursun.com/qr_yoklama/public/api/user/lesson_information',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
        data: {
          'latitude': lat,
          'longtitude': long,
          'lesson': widget.data,
        });

    if (response.statusCode == 200) {
      print(response.data);
      success = response.data['success'];
    } else {
      print(response.statusCode);
    }
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
