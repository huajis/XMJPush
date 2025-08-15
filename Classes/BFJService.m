//
//  BFJService.m
//  Example
//
//  Created by User on 2020/7/31.
//  Copyright © 2020 User. All rights reserved.
//

#import "BFJService.h"
#import <JPush/JPUSHService.h>
#import <JShare/JSHAREService.h>
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>

static NSInteger sequenceNumber = 0;


@interface BFJConfig (BFJService)

- (JSHARELaunchConfig *)launchConfig;

@end


@interface BFJMessage (JSHAREMessage)

- (JSHAREMessage *)JSHAREMessage;
- (NSArray *)shareItem;

@end


@interface BFJService () <JPUSHRegisterDelegate>

@property(class, readonly) BFJService *sharedInstance;
@property(nonatomic, retain) BFJConfig *config;

@end


@implementation BFJService

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BFJService *instance;
    dispatch_once(&onceToken, ^{
        instance = [[BFJService alloc] init];
    });
    return instance;
}

+ (NSInteger)sequenceNumber {
    sequenceNumber++;
    if (sequenceNumber > 1000) {
        sequenceNumber = 0;
    }
    return sequenceNumber;
}

+ (NSString *)registrationID {
    return [JPUSHService registrationID];
}

+ (void)initWithConfig:(BFJConfig *)config launchOptions:(NSDictionary *)launchOptions {
    [BFJService sharedInstance].config = config;
    [self initPushWithAppKey:config.appKey channel:config.channel launchOptions:launchOptions];
    [JSHAREService setupWithConfig:[config launchConfig]];
}

+ (void)initPushWithAppKey:(NSString *)appKey channel:(NSString *)channel launchOptions:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self.sharedInstance];
    
    NSString *advertisingId = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:YES advertisingIdentifier:advertisingId];
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)receiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

+ (void)receiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

+ (void)handleOpenURL:(NSURL *)url {
    [JSHAREService handleOpenUrl:url];
}

+ (void)share:(BFJMessage *)message completionHandler:(BFJServiceShareCompletion)completionHandler {
    if ([self vaildMessage:message]) {
        [JSHAREService share:[message JSHAREMessage] handler:^(JSHAREState state, NSError *error) {
            NSLog(@"Error %@", error.localizedDescription);
            if (!error) {
                switch (state) {
                    case JSHAREStateSuccess:
                        completionHandler(BFJServiceShareStatusSuccess);
                        break;
                    case JSHAREStateFail:
                        completionHandler(BFJServiceShareStatusFail);
                        break;
                    case JSHAREStateCancel:
                        completionHandler(BFJServiceShareStatusCancel);
                        break;
                    default:
                        completionHandler(BFJServiceShareStatusUnknown);
                        break;
                }
            } else {
                completionHandler(BFJServiceShareStatusUnknown);
            }
        }];
    } else {
        UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:[message shareItem] applicationActivities:nil];
        viewController.excludedActivityTypes = @[
            UIActivityTypePostToFacebook,
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypeAirDrop,
            UIActivityTypeOpenInIBooks
        ];
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
    }
}

- (BOOL)isWeChatConfigExist {
    return self.config && self.config.weChat.appId && self.config.weChat.appSecret && self.config.universalLink;
}

- (BOOL)isSinaWeiboConfigExist {
    return self.config && self.config.sinaWeibo.appKey && self.config.sinaWeibo.appSecret;
}

- (BOOL)isQQConfigExist {
    return self.config && self.config.qq.appId && self.config.qq.appKey;
}

+ (BOOL)vaildMessage:(BFJMessage *)message {
    if (message.platform == BFJMessagePlatformWeChat || message.platform == BFJMessagePlatformWeChatTimeLine || message.platform == BFJMessagePlatformWeChatFavourite) {
        return [[self sharedInstance] isWeChatConfigExist];
    }
    else if (message.platform == BFJMessagePlatformSinaWeibo || message.platform == BFJMessagePlatformSinaWeiboContact) {
        return [[self sharedInstance] isSinaWeiboConfigExist];
    }
    else if (message.platform == BFJMessagePlatformQQ || message.platform == BFJMessagePlatformQQZone) {
        return [[self sharedInstance] isQQConfigExist];
    } else {
        return NO;
    }
}

#pragma mark - JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)) {
    
}

@end


@implementation BFJConfig (BFJService)

- (JSHARELaunchConfig *)launchConfig {
    JSHARELaunchConfig *launchConfig = [[JSHARELaunchConfig alloc] init];
    launchConfig.appKey = self.appKey;
    launchConfig.channel = self.channel;
    launchConfig.universalLink = self.universalLink;
    
    launchConfig.WeChatAppId = self.weChat.appId;
    launchConfig.WeChatAppSecret = self.weChat.appSecret;
    
    launchConfig.SinaWeiboAppKey = self.sinaWeibo.appKey;
    launchConfig.SinaWeiboAppSecret = self.sinaWeibo.appSecret;
    launchConfig.SinaRedirectUri = self.sinaWeibo.redirectURL;
    
    launchConfig.QQAppId = self.qq.appId;
    launchConfig.QQAppKey = self.qq.appKey;
    
    return launchConfig;
}

@end


@implementation BFJMessage (JSHAREMessage)

- (JSHAREMessage *)JSHAREMessage {
    JSHAREMessage *message = [JSHAREMessage message];
    message.platform = self.platform;
    if (self.title) {
        message.title = self.title;
    }
    if (self.text) {
        message.mediaType = JSHAREText;
        message.text = self.text;
    }
    if (self.imageURL) {
        NSURL *url = [NSURL URLWithString:self.imageURL];
        if (url && url.scheme && url.host) {
            message.image = [NSData dataWithContentsOfURL:url];
            message.mediaType = JSHAREImage;
        } else {
            message.image = [NSData dataWithContentsOfFile:self.imageURL];
            message.mediaType = JSHAREImage;
        }
    }
    if (self.shareURL) {
        message.url = self.shareURL;
        message.mediaType = JSHARELink;
    }
    return message;
}

- (NSArray *)shareItem {
    NSMutableArray *shareItem = [[NSMutableArray alloc] init];
    if (self.title) {
        [shareItem addObject:self.title];
    }
    if (self.imageURL) {
        NSURL *url = [NSURL URLWithString:self.imageURL];
        if (url && url.scheme && url.host) {
            [shareItem addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]]]];
        } else {
            [shareItem addObject:[UIImage imageWithData:[NSData dataWithContentsOfFile:self.imageURL]]];
        }
    }
    if (self.shareURL) {
        [shareItem addObject:[NSURL URLWithString:self.shareURL]];
    }
    return shareItem;
}

@end
