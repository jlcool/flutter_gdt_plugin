package me.hetian.fluttergdtplugin.views;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Point;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import com.qq.e.ads.banner.ADSize;
import com.qq.e.ads.banner.AbstractBannerADListener;
import com.qq.e.ads.banner.BannerView;
import com.qq.e.ads.banner2.UnifiedBannerADListener;
import com.qq.e.ads.banner2.UnifiedBannerView;
import com.qq.e.ads.cfg.MultiProcessFlag;
import com.qq.e.comm.util.AdError;
import com.qq.e.comm.util.GDTLogger;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;
import me.hetian.fluttergdtplugin.FlutterGdtPlugin;

public class GDTBannerView implements PlatformView, UnifiedBannerADListener {
    PluginRegistry.Registrar mRegistrar;
    UnifiedBannerView bv;
    Context mContext;
    int viewID;
    Map<String, Object> params;
    MethodChannel methodChannel;
    String posId;
    Activity mActivity;
    FrameLayout layout;
    static String TAG = "GDTBannerView";

    public GDTBannerView(Context context, PluginRegistry.Registrar registrar, int id, Map<String, Object> args){
        this.mContext = context;
        this.mActivity = registrar.activity();
        this.mRegistrar = registrar;
        this.viewID = id;
        this.params = args;
        methodChannel = new MethodChannel(registrar.messenger(), "plugins.hetian.me/gdtview_banner/" + id);
        Log.i(TAG, "GDTBannerView: " + "plugins.hetian.me/gdtview_banner/" + id);
        layout = new FrameLayout(mContext);
        layout.setLayoutParams(getUnifiedBannerLayoutParams());

        getBanner().loadAD();
    }

    private UnifiedBannerView getBanner() {
        String posId = (String) params.get("posId");
        if( this.bv != null && this.posId.equals(posId)) {
            return this.bv;
        }
        this.posId = posId;
        if (this.bv != null) {
            this.bv.destroy();
            this.bv = null;
        }
        this.bv = new UnifiedBannerView(mActivity, FlutterGdtPlugin.appid, posId, this);
        return this.bv;
    }

    @Override
    public View getView() {
        return layout;
    }

    private FrameLayout.LayoutParams getUnifiedBannerLayoutParams() {
        Point screenSize = new Point();
        mActivity.getWindowManager().getDefaultDisplay().getSize(screenSize);
        return new FrameLayout.LayoutParams(screenSize.x,  Math.round(screenSize.x / 6.4F));
    }

    @Override
    public void dispose() {
        Log.i("", "----> banner dispose");
        if (bv != null) {
            bv.destroy();
            bv = null;
        }

        if (layout != null) {
            layout.removeAllViews();
            layout = null;
        }
    }

    // UnifiedBannerADListener

    @Override
    public void onNoAD(AdError adError) {
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("code", adError.getErrorCode());
        rets.put("msg", adError.getErrorMsg());
        methodChannel.invokeMethod("onNoAD", rets);
    }

    @Override
    public void onADReceive() {
        layout.removeAllViews();
        bv.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                DisplayMetrics displayMetrics = Resources.getSystem().getDisplayMetrics();
                layout.measure(View.MeasureSpec.makeMeasureSpec(displayMetrics.widthPixels,
                        View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(0,
                                View.MeasureSpec.UNSPECIFIED));

                final int targetWidth = layout.getMeasuredWidth();
                final int targetHeight = layout.getMeasuredHeight();
                HashMap<String, Object> rets = new HashMap<>();

                rets.put("width", targetWidth);
                rets.put("height", targetHeight);
                methodChannel.invokeMethod("onADExposure", rets);
            }
        });
        layout.addView(bv);
        methodChannel.invokeMethod("onADReceive", "");
    }

    @Override
    public void onADExposure() {
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("width", bv.getWidth());
        rets.put("height", bv.getHeight());
        methodChannel.invokeMethod("onADExposure", rets);
    }

    @Override
    public void onADClosed() {
        methodChannel.invokeMethod("onADClosed", "");
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
    public void onADOpenOverlay() {
        methodChannel.invokeMethod("onADOpenOverlay", "");
    }

    @Override
    public void onADCloseOverlay() {
        methodChannel.invokeMethod("onADCloseOverlay", "");
    }
}
