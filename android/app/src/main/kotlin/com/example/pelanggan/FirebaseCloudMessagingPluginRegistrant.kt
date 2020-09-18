package com.pribumisoftware.gojek

import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
class FirebaseCloudMessagingPluginRegistrant {
  companion object {
    fun registerWith(registry: PluginRegistry) {
      if (alreadyRegisteredWith(registry)) {
        return;
      }
      //FirebaseMessagingPlugin.registerWith(registry.registrarFor("com.pribumisoftware.gojek.FirebaseMessagingPlugin"))
      //FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.pribumisoftware.gojek.FlutterLocalNotificationsPlugin"));
       FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
      FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));

   
    }

    fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
      val key = FirebaseCloudMessagingPluginRegistrant::class.java.name
      if (registry.hasPlugin(key)) {
        return true
      }
      registry.registrarFor(key)
      return false
    }
  }
}