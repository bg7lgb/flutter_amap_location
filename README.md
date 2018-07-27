# flutter_amap_location

A Flutter plugin for AMap location.

## 使用方法

1. 引入flutter_amap_location包

pubspec.yaml文件中dependencies：下加入  

```
flutter_amap_location:
```
然后在终端下执行
```
flutter packages get 
```

完成后，再引入包
```dart
import 'package:flutter_amap_location/flutter_amap_location.dart';
```


引入包以后，只需要在您的flutter程序中增加两个函数，用来处理接收到的数据和发生的错误。

[有个文章](https://juejin.im/post/5b58123951882563522b5e7c)可以先看看，回头我再把readme补充完善。

2. 注意事项
- andriod下，要在AndroidManifest.xml增加定位权限
```java
    <!--用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
    <!--用于访问GPS定位-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
    <!--用于获取运营商信息，用于支持提供运营商信息相关的接口-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
    <!--用于访问wifi网络信息，wifi信息会用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission>
    <!--用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
    <!--用于访问网络，网络定位需要上网-->
    <uses-permission android:name="android.permission.INTERNET"></uses-permission>
    <!--用于读取手机当前的状态-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE"></uses-permission>
    <!--用于写入缓存数据到扩展存储卡-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
    <!--用于申请调用A-GPS模块-->
    <uses-permission android:name="android.permission.ACCESS_LOCATION_EXTRA_COMMANDS"></uses-permission>
    <!--用于申请获取蓝牙信息进行室内定位-->
    <uses-permission android:name="android.permission.BLUETOOTH"></uses-permission>
```
- 增加一个定位service和设置高德定位的apikey
```
   <service android:name="com.amap.api.location.APSService"></service>

   <meta-data android:name="com.amap.api.v2.apikey" android:value="你在高德后台获取的apikey">
   </meta-data>
```

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).