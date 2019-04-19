
#import <React/RCTEventEmitter.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface RCTLocationModule : RCTEventEmitter <RCTBridgeModule, AMapLocationManagerDelegate>
@end

@implementation RCTLocationModule {
    AMapLocationManager *_manager;
}

RCT_EXPORT_MODULE(AMapGeolocation)

RCT_EXPORT_METHOD(setOptions:(NSDictionary *)options) {
    if (options[@"distanceFilter"]) {
        _manager.distanceFilter = [options[@"distanceFilter"] doubleValue];
    }
    if (options[@"reGeocode"]) {
        _manager.locatingWithReGeocode = [options[@"reGeocode"] boolValue];
    }
    if (options[@"background"]) {
        _manager.allowsBackgroundLocationUpdates = [options[@"background"] boolValue];
    }
}

RCT_REMAP_METHOD(init, key:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [AMapServices sharedServices].apiKey = key;
    if (!_manager) {
        _manager = [AMapLocationManager new];
        
        //设置期望定位精度
        [_manager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        
        //设置不允许系统暂停定位
        [_manager setPausesLocationUpdatesAutomatically:NO];
        
        //设置定位超时时间
        [_manager setLocationTimeout:10];
        
        //设置逆地理超时时间
        [_manager setReGeocodeTimeout:10];
        resolve(nil);
    } else {
        resolve(nil);
    }
}

RCT_EXPORT_METHOD(start) {
    [_manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [self didUpdateLocation:location reGeocode:regeocode error:error];
    }];
}

RCT_EXPORT_METHOD(stop) {
    [_manager stopUpdatingLocation];
}

RCT_EXPORT_METHOD(cleanUp){
    // 停止定位
    [_manager stopUpdatingLocation];
    [_manager setDelegate:nil];
    _manager = nil;
}

RCT_REMAP_METHOD(getLastLocation, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    id json = [NSUserDefaults.standardUserDefaults objectForKey:RCTLocationModule.storeKey];
    [self sendEventWithName:@"AMapGeolocation" body: json];
}

- (id)json:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    if (reGeocode && reGeocode.formattedAddress.length) {
        return @{
                 @"accuracy": @(location.horizontalAccuracy),
                 @"latitude": @(location.coordinate.latitude),
                 @"longitude": @(location.coordinate.longitude),
                 @"altitude": @(location.altitude),
                 @"speed": @(location.speed),
                 @"direction": @(location.course),
                 @"timestamp": @(location.timestamp.timeIntervalSince1970 * 1000),
                 @"address": reGeocode.formattedAddress?reGeocode.formattedAddress:@"",
                 @"poiName": reGeocode.POIName?reGeocode.POIName:@"",
                 @"country": reGeocode.country?reGeocode.country:@"",
                 @"province": reGeocode.province?reGeocode.province:@"",
                 @"city": reGeocode.city?reGeocode.city:@"",
                 @"cityCode": reGeocode.citycode?reGeocode.citycode:@"",
                 @"district": reGeocode.district?reGeocode.district:@"",
                 @"street": reGeocode.street?reGeocode.street:@"",
                 @"streetNumber": reGeocode.number?reGeocode.number:@"",
                 @"adCode": reGeocode.adcode?reGeocode.adcode:@"",
                 };
    } else {
        return @{
                 @"accuracy": @(location.horizontalAccuracy),
                 @"latitude": @(location.coordinate.latitude),
                 @"longitude": @(location.coordinate.longitude),
                 @"altitude": @(location.altitude),
                 @"speed": @(location.speed),
                 @"direction": @(location.course),
                 @"timestamp": @(location.timestamp.timeIntervalSince1970 * 1000),
                 };
    }
}

- (void)didUpdateLocation:(CLLocation *)location
                reGeocode:(AMapLocationReGeocode *)reGeocode
                    error:(NSError *)error {
    if (error) {
        if (error.code == AMapLocationErrorLocateFailed) {
            [self sendEventWithName:@"AMapGeolocation" body: @"error"];
            return;
        }
    }
    
    if (reGeocode) {
        id json = [self json:location reGeocode:reGeocode];
        [self sendEventWithName:@"AMapGeolocation" body: json];
        [NSUserDefaults.standardUserDefaults setObject:json forKey:RCTLocationModule.storeKey];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    else {
        [self sendEventWithName:@"AMapGeolocation" body: @"none"];
    }
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"AMapGeolocation"];
}

+ (NSString *)storeKey {
    return @"AMapGeolocation";
}

@end
