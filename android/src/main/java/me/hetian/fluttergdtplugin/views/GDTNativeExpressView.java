package me.hetian.fluttergdtplugin.views;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;

import com.qq.e.ads.banner2.UnifiedBannerView;
import com.qq.e.ads.cfg.MultiProcessFlag;
import com.qq.e.ads.cfg.VideoOption;
import com.qq.e.ads.nativ.ADSize;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.ads.nativ.NativeExpressADView;
import com.qq.e.ads.nativ.NativeExpressMediaListener;
import com.qq.e.comm.constants.AdPatternType;
import com.qq.e.comm.pi.AdData;
import com.qq.e.comm.util.AdError;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;
import me.hetian.fluttergdtplugin.FlutterGdtPlugin;


public class GDTNativeExpressView implements PlatformView, NativeExpressAD.NativeExpressADListener{

    PluginRegistry.Registrar mRegistrar;
    Context mContext;
    int viewID;
    NativeExpressAD expressAD;
    Map<String, Object> params;
    MethodChannel methodChannel;
    Activity mActivity;
    FrameLayout layout;

    public GDTNativeExpressView(Context context, PluginRegistry.Registrar registrar, int id, Map<String, Object> args){
        this.mContext = context;
        this.mActivity = registrar.activity();
        this.mRegistrar = registrar;
        this.viewID = id;
        this.params = args;
        methodChannel = new MethodChannel(registrar.messenger(), "plugins.hetian.me/gdtview_express/" + id);

        layout = new FrameLayout(mContext);
        layout.setLayoutParams(new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT));

        getExpressAD().loadAD(1);
    }

    private NativeExpressAD getExpressAD() {
        String posId = (String) params.get("posId");
        expressAD = new NativeExpressAD(mActivity, new ADSize(ADSize.FULL_WIDTH, ADSize.AUTO_HEIGHT), FlutterGdtPlugin.appid, posId, this);
        return expressAD;
    }

    @Override
    public View getView() {
        return layout;
    }

    @Override
    public void dispose() {
        expressAD = null;
        if (layout != null) {
            layout.removeAllViews();
            layout = null;
        }
        params = null;
    }

    // --> NativeExpressAD.NativeExpressADListener

    @Override
    public void onADLoaded(List<NativeExpressADView> list) {
        if (list.isEmpty()) {
            return ;
        }
        final NativeExpressADView item = list.get(0);
        item.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
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
        layout.removeAllViews();
        layout.addView(item);
        item.render();
        methodChannel.invokeMethod("onADLoaded", "");
    }

    @Override
    public void onRenderFail(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onRenderFail", "");
    }

    @Override
    public void onRenderSuccess(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onRenderSuccess", "");
    }

    @Override
    public void onADExposure(NativeExpressADView nativeExpressADView) {
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("width", nativeExpressADView.getWidth());
        rets.put("height", nativeExpressADView.getHeight());
        methodChannel.invokeMethod("onADExposure", rets);
    }

    @Override
    public void onADClicked(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onADClicked", "");
    }

    @Override
    public void onADClosed(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onADClosed", "");
    }

    @Override
    public void onADLeftApplication(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onADLeftApplication", "");
    }

    @Override
    public void onADOpenOverlay(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onADOpenOverlay", "");
    }

    @Override
    public void onADCloseOverlay(NativeExpressADView nativeExpressADView) {
        methodChannel.invokeMethod("onADCloseOverlay", "");
    }

    @Override
    public void onNoAD(AdError adError) {
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("code", adError.getErrorCode());
        rets.put("msg", adError.getErrorMsg());
        methodChannel.invokeMethod("onNoAD", rets);
    }
}
