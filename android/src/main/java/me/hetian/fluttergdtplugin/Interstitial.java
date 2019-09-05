package me.hetian.fluttergdtplugin;

import android.util.Log;


import com.qq.e.ads.interstitial2.UnifiedInterstitialAD;
import com.qq.e.ads.interstitial2.UnifiedInterstitialADListener;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class Interstitial implements UnifiedInterstitialADListener, MethodChannel.MethodCallHandler {
    MethodChannel methodChannel;
    Map<String, Object> params;
    UnifiedInterstitialAD iad;
    String posId;
    String uuid;
    private static HashMap<String, Interstitial> _caches;

    static String CreateInterstitial(Map<String, Object> args) {
        String uuid = UUID.randomUUID().toString().replaceAll("-","");
        if (_caches == null) {
            _caches = new HashMap<>();
        }
        _caches.put(uuid, new Interstitial(uuid, args));
        return uuid;
    }

    static Interstitial GetInstance(String uuid) {
        if (_caches == null) {
            return null;
        }
        return _caches.get(uuid);
    }

    static void ClearCaches(String uuid) {
        if (_caches == null) {
            return ;
        } else {
            _caches.remove(uuid);
        }
    }

    static String GetChannelName(String uuid) {
        return "plugins.hetian.me/gdt_plugins/interstitial/" + uuid;
    }

    Interstitial(String uuid, Map<String, Object> args) {
        this.uuid = uuid;
        params = args;
        this.posId = (String) params.get("posId");
        methodChannel = new MethodChannel(FlutterGdtPlugin.registrar.messenger(), GetChannelName(uuid));
        methodChannel.setMethodCallHandler(this);
    }

    private void load(MethodChannel.Result result) {
        if (this.iad == null) {
            iad = new UnifiedInterstitialAD(FlutterGdtPlugin.registrar.activity(), FlutterGdtPlugin.appid, posId, this);
        }
        iad.loadAD();
        result.success(true);
    }

    public void show(MethodChannel.Result result) {
        if (iad == null) {
            result.success(false);
        } else {
            iad.show();
            result.success(true);
        }
    }

    public void close() {
        if (iad != null) {
            iad.close();
        }
    }

    public void destroy(MethodChannel.Result result) {
        iad.destroy();
        ClearCaches(uuid);
        result.success(true);
    }

    // InterstitialADListener

    @Override
    public void onADReceive() {
        methodChannel.invokeMethod("onADReceive", "");
    }

    @Override
    public void onNoAD(AdError adError) {
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("code", adError.getErrorCode());
        rets.put("msg", adError.getErrorMsg());
        methodChannel.invokeMethod("onNoAD", rets);
    }

    @Override
    public void onADOpened() {
        methodChannel.invokeMethod("onADOpened", "");
    }

    @Override
    public void onADExposure() {
        methodChannel.invokeMethod("onADExposure", "");
    }

    @Override
    public void onADClicked() {
        methodChannel.invokeMethod("onADClicked", "");
    }

    @Override
    public void onADLeftApplication() {
        methodChannel.invokeMethod("onADLeftApplication", "");
    }

    @Override
    public void onADClosed() {
        methodChannel.invokeMethod("onADClosed", "");
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "load":
                load(result);
                break;
            case "show":
                show(result);
                break;
            case "close":
                close();
                result.success(true);
                break;
            case "destroy":
                destroy(result);
                break;
        }
    }
}

