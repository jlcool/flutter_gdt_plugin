import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'flutterGdtPlugin.dart';

class AdsError extends Error {
	final int code;
	final String msg;

	AdsError ({this.code, this.msg});
}

abstract class GDTCacheObject {
	MethodChannel channel;
	bool hasShow = false;

	// 加载数据
	Future load() async {
		assert(channel != null);
		return channel.invokeMethod("load");
	}

	// 展示数据
	Future show() async {
		assert(channel != null);
		if (hasShow == false) {
			return Null;
		}
		hasShow = false;
		return channel.invokeMethod("show");
	}

	// 关闭有的模块不支持
	Future close() async {
		assert(channel != null);
		return channel.invokeMethod("close");
	}

	// 销毁缓存实例
	Future destroy() async {
		assert(channel != null);
		return channel.invokeMethod("destroy");
	}
}

class InterstitialListener extends GDTCacheObject{
	StreamController<String> _onADReceiveStream = StreamController.broadcast();
	StreamController<AdsError> _onNoADStream = StreamController.broadcast();
	StreamController<String> _onADOpenedStream = StreamController.broadcast();
	StreamController<String> _onADExposureStream = StreamController.broadcast();
	StreamController<String> _onADClickedStream = StreamController.broadcast();
	StreamController<String> _onADLeftApplicationStream = StreamController.broadcast();
	StreamController<String> _onADClosedStream = StreamController.broadcast();

	Stream<String> get getADReceiveStream => _onADReceiveStream.stream;

	Stream<AdsError> get getNoADStream => _onNoADStream.stream;

	Stream<String> get getADOpenedStream => _onADOpenedStream.stream;

	Stream<String> get getADExposureStream => _onADExposureStream.stream;

	Stream<String> get getADClickedStream => _onADClickedStream.stream;

	Stream<String> get getADLeftApplicationStream =>
					_onADLeftApplicationStream.stream;

	Stream<String> get getADClosedStream => _onADClosedStream.stream;

	final BuildContext context;
	final String iosPosId;
	final String androidPosId;

	InterstitialListener ({
													@required this.context,
													this.iosPosId,
													this.androidPosId,
												}) : assert(iosPosId != null || androidPosId != null, "安卓与IOS广告ID必须至少设置一个");

	Future create () async {
		final rets = await FlutterGdtPlugin.showInterstitial(
						Platform.isAndroid ? androidPosId : iosPosId);
		if (rets["channel_name"]?.isNotEmpty ?? false) {
			channel = MethodChannel(rets["channel_name"]);
			channel.setMethodCallHandler(_handleMessages);
		}
	}

	void onADReceive () {
		_onADReceiveStream.add("");
	}

	void onNoAD (int code, String msg) {
		_onNoADStream.add(AdsError(code: code, msg: msg));
	}

	void onADOpened () {
		_onADOpenedStream.add("");
	}

	void onADExposure () {
		_onADExposureStream.add("");
	}

	void onADClicked () {
		_onADClickedStream.add("");
	}

	void onADLeftApplication () {
		_onADLeftApplicationStream.add("");
	}

	void onADClosed () {
		_onADClosedStream.add("");
	}

	Future _handleMessages (MethodCall call) async {
		hasShow = false;
		switch (call.method) {
			case "onADReceive":
				hasShow = true;
				this.onADReceive();
				break;
			case "onNoAD":
				this.onNoAD(call.arguments["code"], call.arguments["msg"]);
				break;
			case "onADOpened":
				this.onADOpened();
				break;
			case "onADExposure":
				this.onADExposure();
				break;
			case "onADClicked":
				this.onADClicked();
				break;
			case "onADLeftApplication":
				this.onADLeftApplication();
				break;
			case "onADClosed":
				this.onADClosed();
				break;
		}
	}
}

class SplashListener {

	StreamController<String> _onADDismissedStream = StreamController.broadcast();
	StreamController<AdsError> _onNoADStream = StreamController.broadcast();
	StreamController<String> _onADPresentStream = StreamController.broadcast();
	StreamController<String> _onADClickedStream = StreamController.broadcast();
	StreamController<int> _onADTickStream = StreamController.broadcast();
	StreamController<String> _onADExposureStream = StreamController.broadcast();

	Stream<String> get getADDismissedStream => _onADDismissedStream.stream;

	Stream<AdsError> get getNoADStream => _onNoADStream.stream;

	Stream<String> get getADPresentStream => _onADPresentStream.stream;

	Stream<String> get getADClickedStream => _onADClickedStream.stream;

	Stream<int> get getADTickStream => _onADTickStream.stream;

	Stream<String> get getADExposureStream => _onADExposureStream.stream;

	final BuildContext context;
	final String iosPosId;
	final String androidPosId;
	final String logo;
	final bool hasFooter;

	MethodChannel _channel;

	SplashListener ({
										this.context,
										this.iosPosId,
										this.androidPosId,
										this.logo
									})
					: assert(iosPosId != null || androidPosId != null, "安卓与IOS广告ID必须至少设置一个"),
						hasFooter = logo?.isNotEmpty ?? false;

	Future show () async {
		final rets = await FlutterGdtPlugin.showSplash(
						Platform.isAndroid ? androidPosId : iosPosId, hasFooter, logo);
		if (rets["channel_name"]?.isNotEmpty ?? false) {
			_channel = MethodChannel(rets["channel_name"]);
			_channel.setMethodCallHandler(_handleMessages);
		}
	}

	void onADDismissed () {
		_onADDismissedStream.add("");
	}

	void onNoAD (int code, String msg) {
		_onNoADStream.add(AdsError(code: code, msg: msg));
	}

	void onADPresent () {
		_onADPresentStream.add("");
	}

	void onADClicked () {
		_onADClickedStream.add("");
	}

	void onADTick (int t) {
		_onADTickStream.add(t);
	}

	void onADExposure () {
		_onADExposureStream.add("");
	}

	Future _handleMessages (MethodCall call) async {
		switch (call.method) {
			case "onADDismissed":
				this.onADDismissed();
				break;
			case "onNoAD":
				this.onNoAD(call.arguments["code"], call.arguments["msg"]);
				break;
			case "onADPresent":
				this.onADPresent();
				break;
			case "onADClicked":
				this.onADClicked();
				break;
			case "onADTick":
				this.onADTick(call.arguments["millisUntilFinished"]);
				break;
			case "onADExposure":
				this.onADExposure();
				break;
		}
	}
}

class BannerListener {
	final StreamController<AdsError> _onNoADStream = StreamController.broadcast();
	final StreamController<String> _onADReceiveStream = StreamController.broadcast();
	final StreamController<Size> _onADExposureStream = StreamController.broadcast();
	final StreamController<String> _onADClosedStream = StreamController.broadcast();
	final StreamController<String> _onADClickedStream = StreamController.broadcast();
	final StreamController<String> _onADLeftApplicationStream = StreamController.broadcast();
	final StreamController<String> _onADOpenOverlayStream = StreamController.broadcast();
	final StreamController<String> _onADCloseOverlayStream = StreamController.broadcast();

	Stream<AdsError> get getNoADStream => _onNoADStream.stream;
	Stream<String> get getADReceiveStream => _onADReceiveStream.stream;
	Stream<Size> get getADExposureStream => _onADExposureStream.stream;
	Stream<String> get getADClosedStream => _onADClosedStream.stream;
	Stream<String> get getADClickedStream => _onADClickedStream.stream;
	Stream<String> get getADLeftApplicationStream => _onADLeftApplicationStream.stream;
	Stream<String> get getADOpenOverlayStream => _onADOpenOverlayStream.stream;
	Stream<String> get getADCloseOverlayStream => _onADCloseOverlayStream.stream;

	int viewID;
	MethodChannel _channel;
	final BuildContext context;

	BannerListener (this.context);

	void bindViewID (int viewID) {
		this.viewID = viewID;
		_channel = MethodChannel("plugins.hetian.me/gdtview_banner/$viewID");
		_channel.setMethodCallHandler(this._handleMessages);
	}

	void onNoAD (int code, String msg) {
		_onNoADStream.add(AdsError(code: code, msg: msg));
	}

	void onADReceive () {
		_onADReceiveStream.add("");
	}

	void onADExposure(double width, double height) {
		final size = Size(width, height);
		_onADExposureStream.add(Platform.isAndroid ? size / MediaQuery.of(context).devicePixelRatio : size);
	}

	void onADClosed() {
		_onADClosedStream.add("");
	}

	void onADClicked() {
		_onADClickedStream.add("");
	}

	void onADLeftApplication() {
		_onADLeftApplicationStream.add("");
	}

	void onADOpenOverlay() {
		_onADOpenOverlayStream.add("");
	}

	void onADCloseOverlay() {
		_onADCloseOverlayStream.add("");
	}

	Future _handleMessages(MethodCall call) {
		switch (call.method) {
			case "onNoAD":
				this.onNoAD(call.arguments["code"], call.arguments["msg"]);
				break;
			case "onADReceive":
				this.onADReceive();
				break;
			case "onADExposure":
				onADExposure(double.tryParse(call.arguments["width"].toString()), double.tryParse(call.arguments["height"].toString()));
				break;
			case "onADClosed":
				this.onADClosed();
				break;
			case "onADClicked":
				this.onADClicked();
				break;
			case "onADLeftApplication":
				this.onADLeftApplication();
				break;
			case "onADOpenOverlay":
				this.onADOpenOverlay();
				break;
			case "onADCloseOverlay":
				this.onADCloseOverlay();
				break;
		}
	}

	void dispose() {
		_onNoADStream?.close();
		_onADReceiveStream?.close();
		_onADExposureStream?.close();
		_onADClosedStream?.close();
		_onADClickedStream?.close();
		_onADLeftApplicationStream?.close();
		_onADOpenOverlayStream?.close();
		_onADCloseOverlayStream?.close();
	}
}

class NativeExpressListener {
	StreamController<AdsError> _onNoADStream = StreamController.broadcast();
	StreamController<String> _onADLoadedStream = StreamController.broadcast();
	StreamController<String> _onRenderFailStream = StreamController.broadcast();
	StreamController<String> _onRenderSuccessStream = StreamController.broadcast();
	StreamController<Size> _onADExposureStream = StreamController.broadcast();
	StreamController<String> _onADClickedStream = StreamController.broadcast();
	StreamController<String> _onADClosedStream = StreamController.broadcast();
	StreamController<String> _onADLeftApplicationStream =
	StreamController.broadcast();
	StreamController<String> _onADOpenOverlayStream =
	StreamController.broadcast();
	StreamController<String> _onADCloseOverlayStream =
	StreamController.broadcast();

	Stream<AdsError> get getNoADStream => _onNoADStream.stream;

	Stream<String> get getADLoadedStream => _onADLoadedStream.stream;

	Stream<String> get getRenderFailStream => _onRenderFailStream.stream;

	Stream<String> get getRenderSuccessStream => _onRenderSuccessStream.stream;

	Stream<Size> get getADExposureStream => _onADExposureStream.stream;

	Stream<String> get getADClickedStream => _onADClickedStream.stream;

	Stream<String> get getADClosedStream => _onADClosedStream.stream;

	Stream<String> get getADLeftApplicationStream =>
					_onADLeftApplicationStream.stream;

	Stream<String> get getADOpenOverlayStream => _onADOpenOverlayStream.stream;

	Stream<String> get getADCloseOverlayStream => _onADCloseOverlayStream.stream;

	int viewID;
	MethodChannel _channel;

	final BuildContext context;

	NativeExpressListener (this.context);

	void bindViewID (int viewID) {
		this.viewID = viewID;
		_channel = MethodChannel("plugins.hetian.me/gdtview_express/$viewID");
		_channel.setMethodCallHandler(_handleMessages);
	}

	void onNoAD (int code, String msg) {
		_onNoADStream.add(AdsError(code: code, msg: msg));
	}

	void onADLoaded () {
		_onADLoadedStream.add("");
	}

	void onRenderFail () {
		_onRenderFailStream.add("");
	}

	void onRenderSuccess () {
		_onRenderSuccessStream.add("");
	}

	void onADExposure (double width, double height) {
		if (height > 10) {
			final size = Size(width, height);
			_onADExposureStream.add(Platform.isAndroid ? size / MediaQuery.of(context).devicePixelRatio : size);
		}
	}

	void onADClicked () {
		_onADClickedStream.add("");
	}

	void onADClosed () {
		_onADClosedStream.add("");
	}

	void onADLeftApplication () {
		_onADLeftApplicationStream.add("");
	}

	void onADOpenOverlay () {
		_onADOpenOverlayStream.add("");
	}

	void onADCloseOverlay () {
		_onADCloseOverlayStream.add("");
	}

	Future _handleMessages (MethodCall call) async {
		switch (call.method) {
			case "onNoAD":
				this.onNoAD(call.arguments["code"], call.arguments["msg"]);
				break;
			case "onADLoaded":
				this.onADLoaded();
				break;
			case "onRenderFail":
				this.onRenderFail();
				break;
			case "onRenderSuccess":
				this.onRenderSuccess();
				break;
			case "onADExposure":
				this.onADExposure(double.tryParse(call.arguments["width"].toString()), double.tryParse(call.arguments["height"].toString()));
				break;
			case "onADClicked":
				this.onADClicked();
				break;
			case "onADClosed":
				this.onADClosed();
				break;
			case "onADLeftApplication":
				this.onADLeftApplication();
				break;
			case "onADOpenOverlay":
				this.onADOpenOverlay();
				break;
			case "onADCloseOverlay":
				this.onADCloseOverlay();
				break;
		}
	}

	void dispose() {
		_onNoADStream?.close();
		_onADLoadedStream?.close();
		_onRenderFailStream?.close();
		_onRenderSuccessStream?.close();
		_onADExposureStream?.close();
		_onADClickedStream?.close();
		_onADClosedStream?.close();
		_onADLeftApplicationStream?.close();
		_onADOpenOverlayStream?.close();
		_onADCloseOverlayStream?.close();
	}
}
