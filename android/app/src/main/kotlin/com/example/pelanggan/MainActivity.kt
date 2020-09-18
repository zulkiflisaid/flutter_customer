package com.pribumisoftware.gojek
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel

import io.flutter.plugin.common.MethodCall; 
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import androidx.core.content.pm.PackageInfoCompat.getLongVersionCode 
import java.util.HashMap;

class MainActivity: FlutterActivity() {

     val sharedData:HashMap<String,String> = HashMap<String,String>() 

    //private val CHANNEL = "com.startActivity/testChannel"
    /*override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      GeneratedPluginRegistrant.registerWith(flutterEngine); 
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            Log.d("Log", "message"+call.method)
            when (call.method) {
                    "StartSecondActivity" -> {
                        Log.d("TAG", "message"+call.method)
                        result.success(call.method)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            //if (call.method == "StartSecondActivity") {
            //  result.notImplemented()
            //}  
        }
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "plugins.flutter.io/firebase_messaging").setMethodCallHandler {
            call, result ->
            Log.d("Log", "message"+call.method) 
           
        }
   } */

     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);


           MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "package_info").setMethodCallHandler {
            
            call, result ->
              if (call.method == "getAll") { 
                  
                    val pm = applicationContext.packageManager
                    val info = pm.getPackageInfo(applicationContext.packageName, 0)

                    val map = HashMap<String, String>()
                    map["appName"] = info.applicationInfo.loadLabel(pm).toString()
                    map["packageName"] = applicationContext.packageName
                    map["version"] = info.versionName
                   // map["buildNumber"] = getLongVersionCode(info).toString()
                    result.success(map);
                    //sharedData.clear()   
                } else{
                     result.notImplemented()
                }
           } 
           /* 
           var packageBundle = PackageManager.GetApplicationInfo("PackageName"
                , Android.Content.PM.PackageInfoFlags.MetaData).MetaData;
            foreach (var item in packageBundle.KeySet())
            {
                Log.Debug("HHHHHHHHHH ***********", $"{item} : {packageBundle.GetString(item)}");
            } 
            packageBundle.PutString("com.google.android.maps.v2.API_KEY", "My New Key");
                    
            */

    }

      
   
   
}
