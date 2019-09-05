import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:typed_data';

class FlutterGdtPlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.hetian.me/gdt_plugins');

  static bool isInit = false;

  // 初始化广告
  static Future<dynamic> init(String appid) async {
    final ret = _channel.invokeMethod<String>("init", {"appid": appid});
    isInit = true;
    return ret;
  }

  // 展示插屏广告
  static Future<dynamic> showInterstitial(String id) {
    assert(isInit, "必须先执行 FlutterGdtPlugin.init 初始化广告");
    assert(id?.isNotEmpty ?? false, "必须设置广告ID");
    return _channel
        .invokeMethod("interstitial", {"posId": id});
  }

  // 展示开屏广告
  static Future<dynamic> showSplash(String id, bool hasFooter, String logo) {
    assert(isInit, "必须先执行 FlutterGdtPlugin.init 初始化广告");
    assert(id?.isNotEmpty ?? false, "必须设置广告ID");
    return _channel.invokeMethod("splash", {"posId": id, "has_footer": hasFooter, "logo_name": logo});
  }

  static Future requestPermission() async {
    return _channel.invokeMethod("requestPermission");
  }
}
