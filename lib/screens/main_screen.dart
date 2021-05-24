import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/widgets/divider.dart';

class MainScreen extends StatefulWidget {
  static const screenID = 'main';

  @override
  _State createState() => _State();
}

class _State extends State<MainScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newController;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Position currentPosition;
  double bottomPaddingofMap = 0;

  var geolocator = Geolocator();
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latlngPosition, zoom: 14);
    newController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text('Main Screen'),
        ),
        drawer: Container(
          color: Colors.white,
          width: 255.0,
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Image.asset("images/user_icon.png",
                            height: 65.0, width: 65.0),
                        SizedBox(
                          width: 16.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Profile Name',
                                style: TextStyle(
                                    fontFamily: "Brand-Bold", fontSize: 16.0)),
                            SizedBox(height: 6.0),
                            Text('Visit Profile'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                LineDivider(),
                SizedBox(
                  height: 12.0,
                ),
                ListTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      'History',
                      style: TextStyle(fontSize: 15.0),
                    )),
                ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                      'Visit Profile',
                      style: TextStyle(fontSize: 15.0),
                    )),
                ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(
                      'About',
                      style: TextStyle(fontSize: 15.0),
                    ))
              ],
            ),
          ),
        ),
        body: Stack(children: [
          GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingofMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                newController = controller;
                locatePosition();
                setState(() {
                  bottomPaddingofMap = 300.0;
                });
              }),
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                globalKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7)),
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        'Hi, there !',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        'Where to?',
                        style:
                            TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blueGrey,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Search Drop off '),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Home Address'),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text('Add Home Address'),
                              ]),
                          SizedBox(
                            height: 16.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      LineDivider(),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Work Address'),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text('Add work Address'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ]));
  }
}
