package me.hetian.fluttergdtplugin.Factory;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import me.hetian.fluttergdtplugin.views.GDTNativeExpressView;

public class GDTNativeExpress extends PlatformViewFactory {
    PluginRegistry.Registrar mRegistrar;
    public GDTNativeExpress(PluginRegistry.Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        this.mRegistrar = registrar;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new GDTNativeExpressView(context, mRegistrar, id, params);
    }
}
