import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app_update/update_model.dart';

class AzhonAppUpdate {
  static const MethodChannel _channel = MethodChannel('azhon_app_update');
  static const EventChannel _listenerChannel =
      EventChannel('azhon_app_update_listener');
  static StreamSubscription? _listenerStream;

  ///获取应用的versionCode
  static Future<int> get getVersionCode async {
    return await _channel.invokeMethod('getVersionCode');
  }

  ///获取应用的versionName
  static Future<String> get getVersionName async {
    return await _channel.invokeMethod('getVersionName');
  }

  ///更新
  static Future<bool> update(UpdateModel model) async {
    return await _channel.invokeMethod('update', {
      'model': model.toJson(),
    });
  }

  ///安装apk
  static Future<bool> installApk(String apkPath) async{
    return await _channel.invokeMethod("installApk",apkPath);
  }

  ///监听
  static listener(Function callback) {
    if (!Platform.isAndroid) return;
    _listenerStream = _listenerChannel.receiveBroadcastStream().listen((data) {
      Map<String, dynamic> map = jsonDecode(data);
      callback(map);
    });
  }

  ///取消
  static Future<bool> get cancel async {
    return await _channel.invokeMethod('cancel');
  }

  static dispose() {
    _listenerStream?.cancel();
  }
}
