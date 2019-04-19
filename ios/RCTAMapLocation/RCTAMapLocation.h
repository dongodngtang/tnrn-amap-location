#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#if __has_include(<React/RCTBridgeModule.h>)

#import <React/RCTBridge.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

#else

#import "RCTBridge.h"
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"

#endif

@interface RCTAMapLocation : RCTEventEmitter <RCTBridgeModule>

@end
