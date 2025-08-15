//
//  BFJConfig.h
//  BFJPush
//
//  Created by User on 2020/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeChatConfig : NSObject
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appSecret;
@end

@interface SinaWeiboConfig : NSObject
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, strong) NSString *redirectURL;
@end

@interface QQConfig : NSObject
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *appKey;
@end

@interface BFJConfig : NSObject

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *universalLink;
@property (nonatomic, strong) WeChatConfig *weChat;
@property (nonatomic, strong) SinaWeiboConfig *sinaWeibo;
@property (nonatomic, strong) QQConfig *qq;

@end

NS_ASSUME_NONNULL_END
