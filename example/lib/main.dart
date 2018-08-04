import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_amap_location/flutter_amap_location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _address = "未知位置";
  double _longitude = 0.0;
  double _latitude  = 0.0;

  @override
  void initState() {
    super.initState();

    FlutterAmapLocation.listenLocation(_onLocationEvent, _onLocationError);
  }

  Future<void> getLocationOnce() async {
    String address;
    try {
      FlutterAmapLocation.setOnceLocation(true);
      await FlutterAmapLocation.startLocation();
    } on PlatformException catch (e) {
      address = "Failed to get address: '${e.message}'";
    }

    setState(() {
      _address = address;
    });
  }

  Future<void> getLocation() async {
    String address;
    try {
      FlutterAmapLocation.setOnceLocation(false);
      FlutterAmapLocation.setOnceLocationLatest(false);
      await FlutterAmapLocation.startLocation();
    } on PlatformException catch (e) {
      address = "Failed to get address: '${e.message}'";
    }

    setState(() {
      _address = address;
    });
  }

  Future<void> stopLocation() async {
    try {
      await FlutterAmapLocation.stopLocation();
    } on PlatformException catch (e) {
       print( "Failed to stop location: '${e.message}'");
    }
  }

  void _onLocationEvent(Object event) {
    Map<String, Object> loc = Map.castFrom(event);
    print (loc['address']);

    setState(() {
      _longitude = loc['longitude'];
      _latitude = loc['latitude'];
      _address = loc['address'];
    });
  }

  void _onLocationError(Object event) {
    print(event);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),

        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(onPressed: getLocationOnce,
                    child: new Text("定位一次"),),
                  new RaisedButton(onPressed: getLocation,
                    child: new Text("连续定位"),),
                  new RaisedButton(onPressed: stopLocation,
                    child: new Text("停止定位"),),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                new Text("经度：$_longitude"),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("纬度：$_latitude"),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(child: new Text("地址：$_address"),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
