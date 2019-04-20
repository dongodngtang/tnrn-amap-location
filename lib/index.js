import { NativeModules, NativeEventEmitter, Platform } from "react-native";
const { AMapGeolocation } = NativeModules;
const eventEmitter = new NativeEventEmitter(AMapGeolocation);

export default {
  init: key => AMapGeolocation.init(Platform.select(key)),
  setOptions: options => AMapGeolocation.setOptions(options),
  startSingle: () => AMapGeolocation.startSingle(),
  start: () => AMapGeolocation.start(),
  stop: () => AMapGeolocation.stop(),
  getLastLocation: () => AMapGeolocation.getLastLocation(),
  addListener: listener => eventEmitter.addListener("AMapGeolocation", listener),
  removeListener: () => eventEmitter.removeAllListeners("AMapGeolocation"),
};