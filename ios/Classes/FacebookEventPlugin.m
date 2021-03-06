#import "FacebookEventPlugin.h"
#if __has_include(<facebook_event/facebook_event-Swift.h>)
#import <facebook_event/facebook_event-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "facebook_event-Swift.h"
#endif

@implementation FacebookEventPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftFacebookAppEventsPlugin registerWithRegistrar:registrar];
}
@end
