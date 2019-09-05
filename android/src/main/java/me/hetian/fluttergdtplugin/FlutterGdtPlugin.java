package me.hetian.fluttergdtplugin;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.pm.PackageManager;
import android.os.Build;

import com.qq.e.ads.cfg.MultiProcessFlag;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import me.hetian.fluttergdtplugin.Factory.GDTBannerFactory;
import me.hetian.fluttergdtplugin.Factory.GDTNativeExpress;

/** FlutterGdtPlugin */
public class FlutterGdtPlugin implements MethodCallHandler {
  public static MethodChannel channel;
  public static String appid;
  public static Registrar registrar;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    FlutterGdtPlugin.registrar = registrar;
    FlutterGdtPlugin.channel = new MethodChannel(registrar.messenger(), "plugins.hetian.me/gdt_plugins");
    FlutterGdtPlugin.channel.setMethodCallHandler(new FlutterGdtPlugin());

    registrar.platformViewRegistry().registerViewFactory("plugins.hetian.me/gdtview_banner", new GDTBannerFactory(registrar));
    registrar.platformViewRegistry().registerViewFactory("plugins.hetian.me/gdtview_native", new GDTNativeExpress(registrar));
  }


  @SuppressWarnings("unchecked")
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "init":
        init(call, result);
        break;
      case "requestPermission":
        if (Build.VERSION.SDK_INT >= 23) {
          checkAndRequestPermission(call, result);
        } else {
          result.success("");
        }
        break;
      case "interstitial":
        String uuid = Interstitial.CreateInterstitial((Map<String, Object>)call.arguments);
        HashMap<String, String> rets = new HashMap<>();
        rets.put("channel_name", Interstitial.GetChannelName(uuid));
        result.success(rets);
        break;
      case "splash":
        Splash.getInstance(registrar).show((Map<String, Object>)call.arguments, result);
        break;
      default:
        result.notImplemented();
    }
  }

  private void init(MethodCall call, Result result) {
    if (call.hasArgument("appid")) {
      MultiProcessFlag.setMultiProcess(true);
      FlutterGdtPlugin.appid = (String)call.argument("appid");
      result.success("");
      return ;
    }
    result.error("100", "请设置appid", "");
  }

  /**
   * ----------非常重要----------
   * <p>
   * Android6.0以上的权限适配简单示例：
   * <p>
   * 如果targetSDKVersion >= 23，那么必须要申请到所需要的权限，再调用广点通SDK，否则广点通SDK不会工作。
   * <p>
   * Demo代码里是一个基本的权限申请示例，请开发者根据自己的场景合理地编写这部分代码来实现权限申请。
   * 注意：下面的`checkSelfPermission`和`requestPermissions`方法都是在Android6.0的SDK中增加的API，如果您的App还没有适配到Android6.0以上，则不需要调用这些方法，直接调用广点通SDK即可。
   */
  @TargetApi(Build.VERSION_CODES.M)
  private void checkAndRequestPermission(MethodCall call, final Result result) {
    List<String> lackedPermission = new ArrayList<String>();
    if (!(registrar.activity().checkSelfPermission(Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED)) {
      lackedPermission.add(Manifest.permission.READ_PHONE_STATE);
    }

    if (!(registrar.activity().checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)) {
      lackedPermission.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
    }

    if (!(registrar.activity().checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED)) {
      lackedPermission.add(Manifest.permission.ACCESS_FINE_LOCATION);
    }

    if (lackedPermission.size() > 0) {
      // 请求所缺少的权限，在onRequestPermissionsResult中再看是否获得权限，如果获得权限就可以调用SDK，否则不要调用SDK。
      String[] requestPermissions = new String[lackedPermission.size()];

      lackedPermission.toArray(requestPermissions);
      registrar.activity().requestPermissions(requestPermissions, 1024);
      PluginRegistry.RequestPermissionsResultListener onRequestPermissionsResult = new PluginRegistry.RequestPermissionsResultListener() {
        @Override
        public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] grantResults) {
          if (!hasAllPermissionsGranted(grantResults)) {
            result.error("110", "权限申请失败", null);
            return false;
          }
          result.success("");
          return true;
        }
      };
      registrar.addRequestPermissionsResultListener(onRequestPermissionsResult);
    } else {
      result.success("");
    }
  }

  private boolean hasAllPermissionsGranted(int[] grantResults) {
    for (int grantResult : grantResults) {
      if (grantResult == PackageManager.PERMISSION_DENIED) {
        return false;
      }
    }
    return true;
  }
}
