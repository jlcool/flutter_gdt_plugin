package me.hetian.fluttergdtplugin.views;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;

import com.qq.e.ads.banner.ADSize;
import com.qq.e.ads.banner.AbstractBannerADListener;
import com.qq.e.ads.banner.BannerView;
import com.qq.e.comm.util.AdError;
import com.qq.e.comm.util.GDTLogger;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import me.hetian.fluttergdtplugin.FlutterGdtPlugin;

public class GDTBannerView implements PlatformView, MethodChannel.MethodCallHandler {

    private final MethodChannel methodChannel;
    private final Context mContext;
    private final Activity mActivity;
    private final Map<String, Object> mParams;
    private BannerView bv;

    @SuppressWarnings("unchecked")
    public GDTBannerView(Context context, Activity activity, BinaryMessenger messenger, int id, Map<String, Object> params) {
        mContext = context;
        mActivity = activity;
        methodChannel = new MethodChannel(messenger, "plugins.hetian.me/gdtview_banner_" + id);
        methodChannel.setMethodCallHandler(this);
        mParams = params;

        bv = new BannerView(mActivity, ADSize.BANNER, FlutterGdtPlugin.appid, (String) mParams.get("placementId"));
        bv.setADListener(new AbstractBannerADListener() {

            @Override
            public void onNoAD(AdError error) {
                Log.i(
                        "AD_DEMO",
                        String.format("Banner onNoAD，eCode = %d, eMsg = %s", error.getErrorCode(),
                                error.getErrorMsg()));
                HashMap<String, String> ret = new HashMap<String, String>();
                ret.put("code", String.valueOf(error.getErrorCode()));
                ret.put("msg", error.getErrorMsg());
                methodChannel.invokeMethod("bannerViewFailToReceived", ret);
            }

            @Override
            public void onADReceiv() {
                Log.i("AD_DEMO", "ONBannerReceive");
                methodChannel.invokeMethod("bannerViewDidReceived", "");
            }
            @Override
            public void onADExposure() {
                GDTLogger.i("On BannerAD Exposured");
                methodChannel.invokeMethod("bannerViewWillExposure", "");
            }
            @Override
            public void onADClosed() {
                GDTLogger.i("On BannerAD Closed");
                methodChannel.invokeMethod("bannerViewWillClose", "");
            }
            @Override
            public void onADClicked() {
                GDTLogger.i("On BannerAD Clicked");
                methodChannel.invokeMethod("bannerViewClicked", "");
            }
            @Override
            public void onADLeftApplication() {
                GDTLogger.i("On BannerAD AdLeftApplication");
                methodChannel.invokeMethod("bannerViewWillLeaveApplication", "");
            }
            @Override
            public void onADOpenOverlay() {
                GDTLogger.i("On BannerAD AdOpenOverlay");
                methodChannel.invokeMethod("bannerViewWillPresentFullScreenModal", "");
            }
            @Override
            public void onADCloseOverlay() {
                GDTLogger.i("On BannerAD AdCloseOverlay");
                methodChannel.invokeMethod("bannerViewDidPresentFullScreenModal", "");
            }
        });

        bv.loadAD();
    }

    @Override
    public View getView() {
        return bv;
    }

    @Override
    public void dispose() {
        bv = null;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("load")) {
            bv.loadAD();
        }
    }
}
