import 'package:flutter/material.dart';
import 'package:flutter_gdt_plugin/flutter_gdt_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterGdtPlugin.requestPermission();
    FlutterGdtPlugin.init("1105344611").then((_){
      FlutterGdtPlugin.showSplash("9040714184494018",true, "assets/images/bottom.png");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    FlutterGdtPlugin.showInterstitial(
                        "2030814134092814");
                  },
                  child: Text("打开插屏")),
              FlatButton(
                  onPressed: () {
                    FlutterGdtPlugin.showSplash("8863364436303842593",true, "assets/images/bottom.png");
                  },
                  child: Text("开屏广告")),
            ],
          ),
        ),
      ),
    );
  }
}
