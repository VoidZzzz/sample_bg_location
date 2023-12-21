import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sample_bg_location_app/modules/c_home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: GetBuilder<HomeController>(
            builder: (controller) {
              return controller.currentLocation == const LatLng(0, 0)
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : Stack(
                      children: [mapPanel(), navigateButton(context)],
                    );
            }),
      ),
    );
  }

  Widget mapPanel() {
    return FlutterMap(
      mapController: homeController.mapController,
      options: MapOptions(
          initialCenter: homeController.currentLocation, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        GetBuilder<HomeController>(
            builder: (controller) {
              return MarkerLayer(
                markers: [
                  Marker(
                    point: controller.currentLocation,
                    child: ClipOval(
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              );
            }),
      ],
    );
  }

  Widget navigateButton(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: MediaQuery.of(context).padding.bottom,
      child: GestureDetector(
        onTap: () {
          homeController.onTapNavigateButton();
        },
        child: ClipOval(
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(20),
            child: const Icon(Icons.navigation),
          ),
        ),
      ),
    );
  }
}
