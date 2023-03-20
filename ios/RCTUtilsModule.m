//
//  RCTUtilsModule.m
//  LxMusicMobile
//
//  Created by 周佳磊 on 2023/3/20.
//

#import "RCTUtilsModule.h"
@import UserNotifications;
#import <React/RCTLog.h>

@implementation RCTUtilsModule

RCT_EXPORT_MODULE(UtilsModule)

RCT_EXPORT_METHOD(exitApp)
{
  
}

RCT_EXPORT_METHOD(isNotificationsEnabled:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  if (@available(iOS 10, *)) {
    UNUserNotificationCenter *current = [UNUserNotificationCenter currentNotificationCenter];
    if (current) {
      [current getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        UNAuthorizationStatus status = [settings authorizationStatus];
        if (status == UNAuthorizationStatusAuthorized) {
          resolve(@(YES));
        } else {
          resolve(@(NO));
        }
      }];
    } else {
      resolve(@(NO));
    }
  } else {
    BOOL isRegistered = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    resolve(@(isRegistered));
  }
}

RCT_EXPORT_METHOD(openNotificationPermissionActivity)
{
  if (@available(iOS 10, *)) {
    UNUserNotificationCenter *current = [UNUserNotificationCenter currentNotificationCenter];
    if (current) {
      UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [current requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        RCTLogInfo(@"open notification permission granted");
      }];
    }
  } else {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  }
}

@end
