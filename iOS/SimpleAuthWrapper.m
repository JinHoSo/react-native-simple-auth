#import "SimpleAuthWrapper.h"
#import <SimpleAuth/SimpleAuth.h>

@implementation SimpleAuthWrapper

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(configure:(NSString*)provider config:(NSDictionary*)config) {
  NSLog(@"Configuring %@ with %@", provider, config);
  SimpleAuth.configuration[provider] = config;
};

RCT_EXPORT_METHOD(authorize:(NSString*)provider
                  callback:(RCTResponseSenderBlock)callback) {
  [SimpleAuth authorize:provider completion:^(id responseObject, NSError *error) {

    NSLog(@"\nResponse: %@\nError:%@", responseObject, error);
    
    if (error) {
      NSDictionary *userInfo = [error userInfo];
      NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
      NSDictionary *dict=@{@"code": [NSNumber numberWithInteger:error.code],
                           @"description": errorString};
      callback(@[dict]);
    } else {
      NSDictionary *credentials = [responseObject objectForKey: @"credentials"];
      NSDictionary *info = [responseObject objectForKey: @"info"];
      callback(@[[NSNull null], credentials, info]);
    }
  }];
}

@end
