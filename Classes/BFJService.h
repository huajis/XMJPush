//
//  BFJService.h
//  Example
//
//  Created by User on 2020/7/31.
//  Copyright © 2020 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFJConfig.h"
#import "BFJMessage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BFJServiceShareStatus) {
    BFJServiceShareStatusSuccess = 0,
    BFJServiceShareStatusFail = 1,
    BFJServiceShareStatusCancel = 2,
    BFJServiceShareStatusUnknown = -1,
};

typedef void (^ BFJServiceShareCompletion)(BFJServiceShareStatus status);

@interface BFJService : NSObject

@property (class, nonatomic, readonly) NSInteger sequenceNumber;

+ (NSString *)registrationID;

// 初始化
+ (void)initWithConfig:(BFJConfig *)config launchOptions:(NSDictionary *)launchOptions;

// 推播
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)receiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
+ (void)receiveRemoteNotification:(nonnull NSDictionary *)userInfo;

// 分享
+ (void)handleOpenURL:(NSURL *)url;
+ (void)share:(BFJMessage *)message completionHandler:(BFJServiceShareCompletion)completionHandler;

@end

NS_ASSUME_NONNULL_END
