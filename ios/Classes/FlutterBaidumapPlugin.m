#import "FlutterBaidumapPlugin.h"
#import <flutter_baidumap/flutter_baidumap-Swift.h>

@implementation FlutterBaidumapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBaidumapPlugin registerWithRegistrar:registrar];
}
@end
