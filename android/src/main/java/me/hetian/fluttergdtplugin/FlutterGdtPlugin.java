package me.hetian.fluttergdtplugin;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import com.qq.e.ads.cfg.MultiProcessFlag;

import java.util.ArrayList;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterView;
import me.hetian.fluttergdtplugin.Factory.GDTBannerFactory;
import me.hetian.fluttergdtplugin.Factory.GDTNativeExpress;

/** FlutterGdtPlugin */
public class FlutterGdtPlugin implements MethodCallHandler {
  public static MethodChannel channel;
  public static String appid;
  Registrar registrar;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    FlutterGdtPlugin.channel = new MethodChannel(registrar.messenger(), "plugins.hetian.me/gdt_plugins");
    FlutterGdtPlugin.channel.setMethodCallHandler(new FlutterGdtPlugin(registrar));

    registrar.platformViewRegistry().registerViewFactory("plugins.hetian.me/gdtview_banner", new GDTBannerFactory(registrar.messenger(), registrar.activity()));
    registrar.platformViewRegistry().registerViewFactory("plugins.hetian.me/gdtview_native", new GDTNativeExpress(registrar.messenger(), registrar.activity()));
  }

  FlutterGdtPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("init")) {
      init(call, result);
    } else if (call.method.equals("interstitial")) {
      interstitial(call, result);
    } else if (call.method.equals("closeInterstitial")) {
      result.success("success");
    } else if (call.method.equals("shlash")) {
      shlash(call, result);
    } else if (call.method.equals("closeSplash")) {
      result.success("success");
    }else {
      result.notImplemented();
    }
  }

  private void init(MethodCall call, Result result) {
    if (call.hasArgument("appid") == true) {
      MultiProcessFlag.setMultiProcess(true);
      FlutterGdtPlugin.appid = (String)call.argument("appid");
      Log.i("Int", "init: " +  FlutterGdtPlugin.appid);
      if (Build.VERSION.SDK_INT >= 23) {
        checkAndRequestPermission();
      }
      result.success("");
      return ;
    }
    result.error("100", "请设置appid", "");
  }

  private void interstitial(MethodCall call, Result result) {
    if (call.hasArgument("placementId") == false) {
      result.error("100", "placementId 必须设置", "");
      return ;
    }
    final String placementId = call.argument("placementId");
    final String tag = call.argument("tag");
    new Interstitial(FlutterGdtPlugin.appid, placementId, tag, registrar.activity()).show();
  }

  private void shlash(MethodCall call, Result result) {
    if (call.hasArgument("placementId") == false) {
      result.error("100", "placementId 必须设置", "");
      return ;
    }
    final String placementId = call.argument("placementId");
    final String tag = call.argument("tag");
    new Shlash(FlutterGdtPlugin.appid, placementId, tag, registrar.activity()).show();
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
  private void checkAndRequestPermission() {
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

    if (lackedPermission.size() != 0) {
      // 请求所缺少的权限，在onRequestPermissionsResult中再看是否获得权限，如果获得权限就可以调用SDK，否则不要调用SDK。
      String[] requestPermissions = new String[lackedPermission.size()];

      lackedPermission.toArray(requestPermissions);
      registrar.activity().requestPermissions(requestPermissions, 1024);
      PluginRegistry.RequestPermissionsResultListener onRequestPermissionsResult = new PluginRegistry.RequestPermissionsResultListener() {
        @Override
        public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] grantResults) {
          if (requestCode == 1024 && !hasAllPermissionsGranted(grantResults)) {
            Toast.makeText(registrar.activity(), "应用缺少必要的权限！为了您的最大收益，请点击\"权限\"，打开所需要的权限。", Toast.LENGTH_LONG).show();
            // 如果用户没有授权，那么应该说明意图，引导用户去设置里面授权。
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.parse("package:" + registrar.activity().getPackageName()));
            registrar.activity().startActivity(intent);
            return true;
          }
          return false;
        }
      };
      registrar.addRequestPermissionsResultListener(onRequestPermissionsResult);
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
