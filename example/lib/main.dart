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
    FlutterGdtPlugin.init("1105344611");
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
              Container(
                height: 120,
                alignment: Alignment.center,
                color: Colors.redAccent,
                child: FlutterGDTBannerView(
                  placementId: "4090812164690039",
                  interval: 30,
                  isAnimation: true,
                  showClose: false,
                  isGpsOn: false,
                  size: 0,
                ),
              ),
              Container(
                height: 320,
                color: Colors.blue,
                child: FlutterGDTNativeView(
                  placementId: "5030722621265924",
                  width: 418,
                  height: 380,
                  videoAutoPlayOnWWAN: true,
                  videoMuted: true,
                  onCreate: (c) {},
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FlutterGdtPlugin.showInterstitial(
                        "2030814134092814", "sdsds");
                  },
                  child: Text("打开插屏")),
              FlatButton(
                  onPressed: FlutterGdtPlugin.closeInterstitial,
                  child: Text("关闭插屏")),
              FlatButton(
                  onPressed: () {
                    FlutterGdtPlugin.showSplash("9040714184494018", "dddd");
                  },
                  child: Text("开屏广告")),
            ],
          ),
        ),
      ),
    );
  }
}
