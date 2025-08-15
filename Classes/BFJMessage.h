//
//  BFJMessage.h
//  BFJPush
//
//  Created by User on 2020/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BFJMessagePlatform) {
    BFJMessagePlatformWeChat = 1,
    BFJMessagePlatformWeChatTimeLine = 2,
    BFJMessagePlatformWeChatFavourite = 3,
    BFJMessagePlatformQQ = 4,
    BFJMessagePlatformQQZone = 5,
    BFJMessagePlatformSinaWeibo = 6,
    BFJMessagePlatformSinaWeiboContact = 7
};

/**
    微信
        分享文本：text 必填
        分享圖片：imageURL 必填
        分享網頁：shareURL 必填
    QQ
        分享文本：text 必填
        分享圖片：imageURL 必填
        分享鏈結：shareURL 必填
    微博
        分享文本：text 必填
        分享圖片：imageURL 必填
        分享網頁：shareURL 必填
 */

@interface BFJMessage : NSObject

@property (nonatomic, assign) BFJMessagePlatform platform;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *shareURL;

@end

NS_ASSUME_NONNULL_END
