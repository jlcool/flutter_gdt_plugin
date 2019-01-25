package me.hetian.fluttergdtplugin.views;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import com.qq.e.ads.cfg.MultiProcessFlag;
import com.qq.e.ads.cfg.VideoOption;
import com.qq.e.ads.nativ.ADSize;
import com.qq.e.ads.nativ.NativeExpressAD;
import com.qq.e.ads.nativ.NativeExpressADView;
import com.qq.e.ads.nativ.NativeExpressMediaListener;
import com.qq.e.comm.constants.AdPatternType;
import com.qq.e.comm.pi.AdData;
import com.qq.e.comm.util.AdError;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import me.hetian.fluttergdtplugin.FlutterGdtPlugin;


public class GDTNativeExpressView implements PlatformView, MethodChannel.MethodCallHandler, NativeExpressAD.NativeExpressADListener {
    private final MethodChannel methodChannel;
    private final Context mContext;
    private final Activity mActivity;
    private final Map<String, Object> mParams;
    private NativeExpressAD nativeExpressAD;
    private final FrameLayout _view;
    private NativeExpressADView nativeExpressADView;

    @SuppressWarnings("unchecked")
    public GDTNativeExpressView(Context context, Activity activity, BinaryMessenger messenger, int id, Map<String, Object> params) {
        mContext = context;
        mActivity = activity;
        methodChannel = new MethodChannel(messenger, "plugins.hetian.me/gdtview_native_" + id);
        methodChannel.setMethodCallHandler(this);
        mParams = params;
        _view = new FrameLayout(mActivity);

        MultiProcessFlag.setMultiProcess(true);
        nativeExpressAD = new NativeExpressAD(mActivity, getMyADSize(params), FlutterGdtPlugin.appid, (String) mParams.get("placementId"), this); // 传入Activity
        // 注意：如果您在联盟平台上新建原生模板广告位时，选择了支持视频，那么可以进行个性化设置（可选）
        nativeExpressAD.setVideoOption(new VideoOption.Builder()
                .setAutoPlayPolicy(VideoOption.AutoPlayPolicy.WIFI) // WIFI 环境下可以自动播放视频
                .setAutoPlayMuted(true) // 自动播放时为静音
                .build()); //
        nativeExpressAD.loadAD(1);
    }
    @Override
    public View getView() {
        return _view;
    }

    @Override
    public void dispose() {
        nativeExpressADView = null;
        nativeExpressAD = null;
    }


    private ADSize getMyADSize(Map<String, Object> params) {
        Log.i("getMyADSize", "getMyADSize: " + params.get("width"));

        Double width = Double.valueOf((double) params.get("width"));
        Double height = Double.valueOf((double) params.get("width"));
        int w = width == -1 ? ADSize.FULL_WIDTH : width.intValue();
        int h = height == -1 ? ADSize.AUTO_HEIGHT : height.intValue();
        return new ADSize(w, h);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

    }

    @Override
    public void onADLoaded(List<NativeExpressADView> adList) {
        Log.i("onADLoaded", "onADLoaded: " + adList.size());
        // 释放前一个 NativeExpressADView 的资源
        if (nativeExpressADView != null) {
            nativeExpressADView.destroy();
        }
        // 3.返回数据后，SDK 会返回可以用于展示 NativeExpressADView 列表
        nativeExpressADView = adList.get(0);
        if (nativeExpressADView.getBoundData().getAdPatternType() == AdPatternType.NATIVE_VIDEO) {
            nativeExpressADView.setMediaListener(mediaListener);
        }
        nativeExpressADView.render();
        if (_view.getChildCount() > 0) {
            _view.removeAllViews();
        }

        // 需要保证 View 被绘制的时候是可见的，否则将无法产生曝光和收益。
        _view.addView(nativeExpressADView);
    }

    @Override
    public void onRenderFail(NativeExpressADView nativeExpressADView) {
        Log.i("GDTNativeExpressView", "onRenderFail: ");
    }

    @Override
    public void onRenderSuccess(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onRenderSuccess: ");
    }

    @Override
    public void onADExposure(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onADExposure: ");
    }

    @Override
    public void onADClicked(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onADClicked: ");
    }

    @Override
    public void onADClosed(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onADClosed: ");
    }

    @Override
    public void onADLeftApplication(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onADLeftApplication: ");
    }

    @Override
    public void onADOpenOverlay(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onADOpenOverlay: ");
    }

    @Override
    public void onADCloseOverlay(NativeExpressADView nativeExpressADView) {

        Log.i("GDTNativeExpressView", "onADCloseOverlay: ");
    }

    @Override
    public void onNoAD(AdError error) {

        Log.i("GDTNativeExpressView", String.format("LoadInterstitialAd Fail, error code: %d, error msg: %s", error.getErrorCode(), error.getErrorMsg()));
    }

    /**
     * 获取播放器实例
     *
     * 仅当视频回调{@link NativeExpressMediaListener#onVideoInit(NativeExpressADView)}调用后才会有返回值
     *
     * @param videoPlayer
     * @return
     */
    private String getVideoInfo(AdData.VideoPlayer videoPlayer) {
        if (videoPlayer != null) {
            StringBuilder videoBuilder = new StringBuilder();
            videoBuilder.append("{state:").append(videoPlayer.getVideoState()).append(",")
                    .append("duration:").append(videoPlayer.getDuration()).append(",")
                    .append("position:").append(videoPlayer.getCurrentPosition()).append("}");
            return videoBuilder.toString();
        }
        return null;
    }

    private NativeExpressMediaListener mediaListener = new NativeExpressMediaListener() {
        @Override
        public void onVideoInit(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoInit: "
                    + getVideoInfo(nativeExpressADView.getBoundData().getProperty(AdData.VideoPlayer.class)));
        }

        @Override
        public void onVideoLoading(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoLoading");
        }

        @Override
        public void onVideoReady(NativeExpressADView nativeExpressADView, long l) {
            Log.i("GDTNativeExpressView", "onVideoReady");
        }

        @Override
        public void onVideoStart(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoStart: "
                    + getVideoInfo(nativeExpressADView.getBoundData().getProperty(AdData.VideoPlayer.class)));
        }

        @Override
        public void onVideoPause(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoPause: "
                    + getVideoInfo(nativeExpressADView.getBoundData().getProperty(AdData.VideoPlayer.class)));
        }

        @Override
        public void onVideoComplete(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoComplete: "
                    + getVideoInfo(nativeExpressADView.getBoundData().getProperty(AdData.VideoPlayer.class)));
        }

        @Override
        public void onVideoError(NativeExpressADView nativeExpressADView, AdError adError) {
            Log.i("GDTNativeExpressView", "onVideoError");
        }

        @Override
        public void onVideoPageOpen(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoPageOpen");
        }

        @Override
        public void onVideoPageClose(NativeExpressADView nativeExpressADView) {
            Log.i("GDTNativeExpressView", "onVideoPageClose");
        }
    };
}
