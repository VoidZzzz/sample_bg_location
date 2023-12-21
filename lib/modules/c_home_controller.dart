import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample_bg_location_app/app_functions.dart';

class HomeController extends GetxController {
  String mapUrl = "";
  LatLng currentLocation = const LatLng(0, 0);
  MapController mapController = MapController();
  Location location = Location();

  Future<void> requestLocation() async {
    try {
      await location.requestPermission();
    } catch (e) {
      superPrint(e);
    }
    var status = await Permission.location.status;
    if (status.isGranted || status.isLimited) {
      requestBgLocation();
    } else {
      var result = await Permission.location.request();
      if (result.isGranted || result.isLimited) {
        requestBgLocation();
      } else {
        Get.dialog(
          const AlertDialog(
            content: Text("လိုကေးရှင်း ဖွင့်ပါ"),
          ),
        );
      }
    }
  }

  Future<void> requestBgLocation() async {
    var status = await Permission.locationAlways.status;
    if (status.isGranted || status.isLimited) {
      initLoad();
    } else {
      var result = await Permission.locationAlways.request();
      if (result.isGranted || result.isLimited) {
        initLoad();
      } else {
        Get.dialog(
          const AlertDialog(
            content: Text("လိုကေးရှင်းအမြဲ ဖွင့်ပါ"),
          ),
        );
      }
    }
  }

  void onTapNavigateButton() {
    mapController.move(currentLocation, 15);
  }

  initLoad() async {
    await location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((event) {
      currentLocation = LatLng(event.latitude ?? 0, event.longitude ?? 0);
      update();
      superPrint(currentLocation, title: "location update");
    });
  }

  // 20 : 48 : 31.178

  @override
  void onInit() {
    requestLocation();
    super.onInit();
  }
}
