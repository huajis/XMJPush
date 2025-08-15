//
//  BFJConfig.m
//  BFJPush
//
//  Created by User on 2020/9/3.
//

#import "BFJConfig.h"

@implementation BFJConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.channel = @"App Store";
        self.weChat = [[WeChatConfig alloc] init];
        self.sinaWeibo = [[SinaWeiboConfig alloc] init];
        self.qq = [[QQConfig alloc] init];
    }
    return self;
}

@end

@implementation WeChatConfig
@end

@implementation SinaWeiboConfig
@end

@implementation QQConfig
@end
