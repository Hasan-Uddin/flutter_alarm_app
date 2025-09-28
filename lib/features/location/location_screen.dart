import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/common_widgets/custom_btn.dart';
import 'package:flutter_alarm_app/common_widgets/custom_btn_img.dart';
import 'package:flutter_alarm_app/common_widgets/linear_grad.dart';
import 'package:flutter_alarm_app/constants/dir_path.dart';
import 'package:flutter_alarm_app/features/main/alarm_home.dart';
import 'package:flutter_alarm_app/helpers/services/location_service.dart';
import 'package:flutter_alarm_app/helpers/services/storage_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    //_checkExistingLocationAndProceed();
  }

  Future<void> _checkExistingLocationAndProceed() async {
    final existingLocation = await _storageService.getUserLocation();
    Future.delayed(const Duration(milliseconds: 600), () async {
      await _fetchAndSaveLocation().whenComplete(() {
        if (existingLocation != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AlarmHome()),
          );
        }
      });
    });
  }

  Future<void> _fetchAndSaveLocation() async {
    if (_isFetchingLocation) return;

    setState(() => _isFetchingLocation = true);

    try {
      final address = await _locationService.getAddressFromCurrentLocation();
      if (address != null) {
        await _storageService.saveUserLocation(address);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AlarmHome()),
          );
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      if (mounted) {
        setState(() => _isFetchingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: LinearGrad(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome! Your Smart Travel Alarm",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Stay on schedule and enjoy every moment of your journey.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Use LayoutBuilder to get the available width and calculate the radius.
                      // The radius is half of the available width (constraints.maxWidth).
                      return CircleAvatar(
                        radius: constraints.maxWidth / 2,
                        backgroundImage: const AssetImage(
                          DirPath.onBoarding_img_4,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    CustomBtnImg(
                      text: "Use Current Location",
                      icon: const Icon(Icons.location_on_outlined),
                      marginVer: 10,
                      onPressed: _checkExistingLocationAndProceed,
                    ),
                    CustomBtn(
                      text: "Home",
                      marginVer: 10,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlarmHome(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
