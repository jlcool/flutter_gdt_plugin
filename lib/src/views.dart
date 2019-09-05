import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gdt_plugin/src/flutterGdtPlugin.dart';
import 'package:flutter_gdt_plugin/src/listeners.dart';

class GDTBannerView extends StatefulWidget {
	final String posId;
	final BannerListener listener;

	GDTBannerView ({Key key, @required this.posId, this.listener})
					: assert(posId != null, "必须设置广告ID"),
						super(key: key);

	_GDTBannerViewState createState () => _GDTBannerViewState();
}

class _GDTBannerViewState extends State<GDTBannerView> {
	Size _size;
	BannerListener _listener;

	@override
	void initState () {
		super.initState();
		_size = Size.fromHeight(60);
	}

	@override
	Widget build (BuildContext context) {
		if (_size.height == 0 || !FlutterGdtPlugin.isInit) {
			return SizedBox();
		}
		if (Platform.isAndroid) {
			return SizedBox(
				height: _size.height,
				child: AndroidView(
					viewType: "plugins.hetian.me/gdtview_banner",
					creationParams: {"posId": widget.posId},
					creationParamsCodec: const StandardMessageCodec(),
					onPlatformViewCreated: _onPlatformViewCreated,
					gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
						new Factory<OneSequenceGestureRecognizer>(
														() => new TapGestureRecognizer()),
					].toSet(),
				),
			);
		} else if (Platform.isIOS) {
			return SizedBox(
				height: _size.height,
				child: UiKitView(
					viewType: "plugins.hetian.me/gdtview_banner",
					creationParams: {"posId": widget.posId},
					creationParamsCodec: const StandardMessageCodec(),
					onPlatformViewCreated: _onPlatformViewCreated,
					gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
						new Factory<OneSequenceGestureRecognizer>(
														() => new TapGestureRecognizer()),
					].toSet(),
				),
			);
		}
		return SizedBox();
	}

	void _onPlatformViewCreated (int viewID) {
		if (widget.listener != null) {
			_listener = widget.listener;
		} else {
			_listener = new BannerListener(context);
		}
		_listener.bindViewID(viewID);
		_listener.getADExposureStream.listen((size) {
			setState(() {
				_size = size;
			});
		});
		_listener.getNoADStream.listen((_) {
			hideView();
		});
		_listener.getADClosedStream.listen((_) {
			hideView();
		});
	}

	void hideView () {
		setState(() {
			_size = Size.zero;
		});
	}
}


class GDTNativeExpressView extends StatefulWidget {
	final String posId;
	final NativeExpressListener listener;

	GDTNativeExpressView ({Key key, @required this.posId, this.listener})
					: assert(posId != null, "必须设置广告ID"),
						super(key: key);

	_GDTNativeExpressViewState createState () => _GDTNativeExpressViewState();
}

class _GDTNativeExpressViewState extends State<GDTNativeExpressView> {
	Size _size;
	NativeExpressListener _listener;

	@override
	void initState () {
		super.initState();
		_size = Size.fromHeight(100);
	}

	@override
	Widget build (BuildContext context) {
		if (_size.height == 0 || !FlutterGdtPlugin.isInit) {
			return SizedBox();
		}
		if (Platform.isAndroid) {
			return Container(
				height: _size.height,
				child: AndroidView(
					viewType: "plugins.hetian.me/gdtview_native",
					creationParams: {"posId": widget.posId},
					creationParamsCodec: const StandardMessageCodec(),
					onPlatformViewCreated: _onPlatformViewCreated,
					gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
						new Factory<OneSequenceGestureRecognizer>(
														() => new TapGestureRecognizer()),
					].toSet(),
				),
			);
		} else if (Platform.isIOS) {
			return SizedBox(
				height: _size.height,
				child: UiKitView(
					viewType: "plugins.hetian.me/gdtview_native",
					creationParams: {"posId": widget.posId},
					creationParamsCodec: const StandardMessageCodec(),
					onPlatformViewCreated: _onPlatformViewCreated,
					gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
						new Factory<OneSequenceGestureRecognizer>(
														() => new TapGestureRecognizer()),
					].toSet(),
				),
			);
		}
		return SizedBox();
	}

	void _onPlatformViewCreated (int viewID) {
		if (widget.listener != null) {
			_listener = widget.listener;
		} else {
			_listener = new NativeExpressListener(context);
		}
		_listener.bindViewID(viewID);
		_listener.getADExposureStream.listen((size) {
			setState(() {
				_size = size;
			});
		});
		_listener.getRenderFailStream.listen((_) {
			hideView();
		});
		_listener.getNoADStream.listen((_) {
			hideView();
		});
		_listener.getADClosedStream.listen((_) {
			hideView();
		});
	}

	void hideView () {
		setState(() {
			_size = Size.zero;
		});
	}
}