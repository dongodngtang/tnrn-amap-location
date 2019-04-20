# tnrn-amap-location

[![npm](https://img.shields.io/npm/v/tnrn-amap-location.svg)](https://www.npmjs.com/package/tnrn-amap-location)
[![npm](https://img.shields.io/npm/dm/tnrn-amap-location.svg)](https://www.npmjs.com/package/tnrn-amap-location)
[![npm](https://img.shields.io/npm/dt/tnrn-amap-location.svg)](https://www.npmjs.com/package/tnrn-amap-location)
[![npm](https://img.shields.io/npm/l/tnrn-amap-location.svg)](https://github.com/tnrn/tnrn-amap-location/master/LICENSE)

## 使用

1.  [安装](docs/installation.md)

	```
	yarn add tnrn-amap-location
	```
	
2.  获取 Key：
    * [Android](http://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key)
    * [iOS](http://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key)

```javascript
import { PermissionsAndroid } from "react-native"
import { Geolocation } from "tnrn-amap-location"

const granted = await PermissionsAndroid.request(
  PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION
);

if (granted === PermissionsAndroid.RESULTS.GRANTED) {
  await Geolocation.init({
    ios: "9bd6c82e77583020a73ef1af59d0c759",
    android: "043b24fe18785f33c491705ffe5b6935"
  })

  Geolocation.setOptions({
    interval: 8000,
    distanceFilter: 20
  })

  Geolocation.addLocationListener(location => console.log(location))
  Geolocation.start()
}
```

### 最后：

由于 [react-native-amap-geolocation](https://github.com/qiuxiang/react-native-amap-geolocation) 有些在使用上面的问题，因此 fork 了这份代码

[issue：iOS 定位多次回调](https://github.com/qiuxiang/react-native-amap-geolocation/issues/52)
