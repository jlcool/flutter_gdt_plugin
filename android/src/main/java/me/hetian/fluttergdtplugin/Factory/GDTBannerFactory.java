package me.hetian.fluttergdtplugin.Factory;

import android.app.Activity;
import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import me.hetian.fluttergdtplugin.views.GDTBannerView;

public class GDTBannerFactory extends PlatformViewFactory {
    BinaryMessenger messenger;
    Activity activity;
    public GDTBannerFactory(BinaryMessenger messenger, Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.activity = activity;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new GDTBannerView(context, activity, messenger, id, params);
    }
}
