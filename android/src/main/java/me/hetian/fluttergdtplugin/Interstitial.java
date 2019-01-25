package me.hetian.fluttergdtplugin;

import android.app.Activity;
import android.util.Log;

import com.qq.e.ads.cfg.MultiProcessFlag;
import com.qq.e.ads.interstitial.AbstractInterstitialADListener;
import com.qq.e.ads.interstitial.InterstitialAD;
import com.qq.e.comm.util.AdError;
import com.qq.e.comm.util.GDTLogger;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class Interstitial {
    private final String appid;
    private final String placementId;
    private final Activity mActivity;
    private final String tag;

    public Interstitial(String appid, String placementId, String tag, Activity activity) {
        this.appid = appid;
        this.placementId = placementId;
        this.mActivity = activity;
        this.tag = tag;
    }

    public void show() {
        MultiProcessFlag.setMultiProcess(true);
        final InterstitialAD iad = new InterstitialAD(mActivity, appid, placementId);
        iad.setADListener(new AbstractInterstitialADListener() {

            @Override
            public void onADReceive() {
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialSuccessToLoadAd", ret);
                iad.show();
            }

            @Override
            public void onNoAD(AdError error) {
                Log.i("GDT_AD", String.format("LoadInterstitialAd Fail, error code: %d, error msg: %s", error.getErrorCode(), error.getErrorMsg()));
                HashMap<String, String> err = new HashMap<String, String>();
                err.put("code", String.valueOf(error.getErrorCode()));
                err.put("msg", error.getErrorMsg());
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("error", err);
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialFailToLoadAd", ret);
            }

            @Override
            public void onADOpened() {
                GDTLogger.i("ON InterstitialAD Opened");
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialSuccessToLoadAd", ret);
            }

            @Override
            public void onADExposure() {
                GDTLogger.i("ON InterstitialAD Exposure");
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialWillPresentScreen", ret);
            }

            @Override
            public void onADClicked() {
                GDTLogger.i("ON InterstitialAD Clicked");
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialClicked", ret);
            }

            @Override
            public void onADLeftApplication() {
                GDTLogger.i("ON InterstitialAD LeftApplication");
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialApplicationWillEnterBackground", ret);
            }

            @Override
            public void onADClosed() {
                GDTLogger.i("ON InterstitialAD Closed");
                HashMap<String, Object> ret = new HashMap<String, Object>();
                ret.put("tag", tag);
                FlutterGdtPlugin.channel.invokeMethod("interstitialDidDismissScreen", ret);
            }
        });
        //请求插屏广告，每次重新请求都可以调用此方法。
        iad.loadAD();
    }
}

