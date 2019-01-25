package me.hetian.fluttergdtplugin;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.qq.e.ads.cfg.MultiProcessFlag;
import com.qq.e.ads.interstitial.AbstractInterstitialADListener;
import com.qq.e.ads.interstitial.InterstitialAD;
import com.qq.e.comm.util.AdError;

import io.flutter.plugin.common.MethodChannel;

public class Shlash {
    private final String appid;
    private final String placementId;
    private final String tag;
    private final Activity mActivity;

    public Shlash(String appid, String placementId, String tag, Activity activity) {
        this.appid = appid;
        this.placementId = placementId;
        this.mActivity = activity;
        this.tag = tag;
    }

    public void show() {
        MultiProcessFlag.setMultiProcess(true);
        Intent intent = new Intent(mActivity, SplashActivity.class);
        intent.putExtra("appid", appid);
        intent.putExtra("pos_id", placementId);
        intent.putExtra("tag", tag);
        mActivity.startActivity(intent);
        mActivity.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}
