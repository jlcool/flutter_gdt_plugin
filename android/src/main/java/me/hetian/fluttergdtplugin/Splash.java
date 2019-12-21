package me.hetian.fluttergdtplugin;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.qq.e.ads.splash.SplashAD;
import com.qq.e.ads.splash.SplashADListener;
import com.qq.e.comm.util.AdError;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.android.FlutterSurfaceView;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Splash implements SplashADListener{
    PluginRegistry.Registrar mRegistrar;
    MethodChannel methodChannel;
    String posId;
    private static Splash _Splash;
    private SplashAD splashAD;
    private RelativeLayout layout;
    private Activity mActivity;
    private TextView skipView;
    private ImageView splashHolder;
    private ImageView splashLogo;
    private static final String SKIP_TEXT = "点击跳过 %d";


    static Splash getInstance(PluginRegistry.Registrar registrar) {
        if (_Splash == null) {
            _Splash = new Splash(registrar);
        }
        return _Splash;
    }

    Splash(PluginRegistry.Registrar registrar) {
        this.mRegistrar = registrar;
        this.mActivity = registrar.activity();
        layout = (RelativeLayout) LayoutInflater.from(mActivity).inflate(R.layout.activity_splash, null);
    }

    public void show(Map<String, Object> args, MethodChannel.Result result) {
        String uuid = UUID.randomUUID().toString().replaceAll("-","");
        String channelName = "plugins.hetian.me/gdt_plugins/shlash/" + uuid;
        methodChannel = new MethodChannel(mRegistrar.messenger(), channelName);
        HashMap<String, String> rets = new HashMap<>();
        rets.put("channel_name", channelName);
        result.success(rets);
        mActivity.addContentView(layout, new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        posId = (String) args.get("posId");
        int fetchDelay = 3000;
        ViewGroup splashContainer = (ViewGroup) layout.findViewById(R.id.splash_container);
        skipView = (TextView) layout.findViewById(R.id.skip_view);
        splashHolder = (ImageView) layout.findViewById(R.id.splash_holder);
        splashLogo = (ImageView) layout.findViewById(R.id.app_logo);

        if ((Boolean) args.get("has_footer")) {
            AssetManager assetManager = mRegistrar.context().getAssets();
            String key = mRegistrar.lookupKeyForAsset((String) args.get("logo_name"));
            try {
                splashLogo.setVisibility(View.VISIBLE);
                splashLogo.setImageBitmap(BitmapFactory.decodeStream(assetManager.open(key)));
            } catch (IOException e) {
                e.printStackTrace();
                splashLogo.setVisibility(View.GONE);
            }

        } else {
            splashLogo.setVisibility(View.GONE);
        }

        fetchSplashAD(mActivity, splashContainer, skipView, FlutterGdtPlugin.appid, posId, this, fetchDelay);
    }

    /**
     * 拉取开屏广告，开屏广告的构造方法有3种，详细说明请参考开发者文档。
     *
     * @param activity        展示广告的activity
     * @param adContainer     展示广告的大容器
     * @param skipContainer   自，S定义的跳过按钮：传入该view给SDK后DK会自动给它绑定点击跳过事件。SkipView的样式可以由开发者自由定制，其尺寸限制请参考activity_splash.xml或者接入文档中的说明。
     * @param appId           应用ID
     * @param posId           广告位ID
     * @param adListener      广告状态监听器
     * @param fetchDelay      拉取广告的超时时长：取值范围[3000, 5000]，设为0表示使用广点通SDK默认的超时时长。
     */
    private void fetchSplashAD(Activity activity, ViewGroup adContainer, View skipContainer,
                               String appId, String posId, SplashADListener adListener, int fetchDelay) {
        splashAD = new SplashAD(activity, skipContainer, appId, posId, adListener, fetchDelay);
        splashAD.fetchAndShowIn(adContainer);
    }

    // SplashADListener

    @Override
    public void onADDismissed() {
        methodChannel.invokeMethod("onADDismissed", "");
        if (layout != null) {
            ViewGroup vg = (ViewGroup) layout.getParent();
            vg.removeView(layout);
            layout = null;
            splashAD = null;
        }
        _Splash = null;
    }

    @Override
    public void onNoAD(AdError adError) {
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("code", adError.getErrorCode());
        rets.put("msg", adError.getErrorMsg());
        methodChannel.invokeMethod("onNoAD", rets);
        if (layout != null) {
            ViewGroup vg = (ViewGroup) layout.getParent();
            vg.removeView(layout);
            layout = null;
            splashAD = null;
        }
        _Splash = null;
    }

    @Override
    public void onADPresent() {
        methodChannel.invokeMethod("onADPresent", "");
    }

    @Override
    public void onADClicked() {
        methodChannel.invokeMethod("onADClicked", "");
    }

    @SuppressLint("DefaultLocale")
    @Override
    public void onADTick(long millisUntilFinished) {
        int l = Math.round(millisUntilFinished / 1000f);
        skipView.setText(String.format(SKIP_TEXT, l));
        HashMap<String, Object> rets = new HashMap<>();
        rets.put("millisUntilFinished", l);
        methodChannel.invokeMethod("onADTick", rets);
    }

    @Override
    public void onADExposure() {
        methodChannel.invokeMethod("onADExposure", "");
    }
}
