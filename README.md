
[![pipeline status](https://gitlab.baifu-tech.net/ios/BFJPush/badges/master/pipeline.svg)](https://gitlab.baifu-tech.net/ios/BFJPush/commits/master)

# BFJPush

極光SDK整合元件

## 使用說明

- 若還有沒有安裝過Cocoapods, 請先安裝[Cocoapods](https://cocoapods.org/)

### Profile

- 若專案沒有podfile 請先於iOS專案目錄下執行以下指令

```
pod init
```

- 打開你的podfile, 在最上方加入以下source(如下圖黃色框框)

```
source 'git@gitlab.baifu-tech.net:ios/PrivatePodRepo.git'
source 'https://cdn.cocoapods.org/'
```

- 加入以下pod(如下圖)

```
pod 'BFJPush', '~> 2.0.2'
```

![](Images/Podfile.png)

- 於iOS專案目錄下執行以下指令

```
pod install --repo-update
```

### 推播功能程式碼整合

- 打開專案找到 AppDelegate.m 的檔案 做以下調整

```objc
#import "AppDelegate.h"
// Step.1 加入BFJPush標頭檔
#import <BFJPush/BFJPush.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Step.2 建立 BFJConfig
    BFJConfig *config = [[BFJConfig alloc] init];
    // Step.3 指定以下的值 用來初始化 BFJService
    config.appKey = @"50a9cd8acd05966739ae3839"; // 極光平台提供的AppKey(必填), 極光推播跟分享都需要給appKey
    config.channel = @"App Store"; // 指定的Channel(選填), 預設為App Store
    
    // Step.4 將 config 傳給 BFJService 完成初始化
    [BFJService initWithConfig:config launchOptions:launchOptions];
    return YES;
}
```

- 加入`[BFJService registerDeviceToken:deviceToken];` 如下

```objc
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [BFJService registerDeviceToken:deviceToken];
}
```

- 加入`[BFJService receiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];` 如下

```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    [BFJService receiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
```

- 加入`[BFJService receiveRemoteNotification:userInfo];` 如下

```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [BFJService receiveRemoteNotification:userInfo];
}
```

- App 需要增加 `Background Modes` 並勾選 `Remote notifications` 
- App 增加 `Push Notifications` 

![](Images/ProjectSettings.png)

### 分享功能程式碼整合

- 打開專案找到 AppDelegate.m 的檔案 做以下調整

```objc
#import "AppDelegate.h"
// Step.1 加入BFJPush標頭檔
#import <BFJPush/BFJPush.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Step.2 建立 BFJConfig
    BFJConfig *config = [[BFJConfig alloc] init];
    
    // Step.3 指定以下的值 用來初始化 BFJService
    config.appKey = @"50a9cd8acd05966739ae3839"; // 極光平台提供的AppKey(必填), 極光推播跟分享都需要給appKey
    config.channel = @"App Store"; // 指定的Channel(選填), 預設為App Store
    
    /**
     *  以下為分享功能才需要指定
     */
    // 設置極光魔鍊 取得universal link
    config.universalLink = @"https://bgrqbg.jmlk.co/50a9cd8acd05966739ae3839";
    
    // 須註冊微信開發者 取得以下資料
    config.weChat.appId = @"";
    config.weChat.appSecret = @"";
    
    // 須註冊新浪網開發者 取得以下資料
    config.sinaWeibo.appKey = @"";
    config.sinaWeibo.appSecret = @"";
    config.sinaWeibo.redirectURL = @"";
    
    // 須註冊QQ開發者 取得以下資料
    config.qq.appId = @"";
    config.qq.appKey = @"";
    
    // Step.4 將 config 傳給 BFJService 完成初始化
    [BFJService initWithConfig:config launchOptions:launchOptions];
    return YES;
}
```

- 加入`[BFJService handleOpenURL:url];` 如下

```objc
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [BFJService handleOpenURL:url];
    return YES;
}
```

- 若專案內有 SceneDelegate 需要打開 SceneDelegate.m 加入 `[BFJService handleOpenURL:url];` 如下

```objc
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *context in URLContexts) {
        NSURL *url = context.URL;
        [BFJService handleOpenURL:url];
    }
}
```

- 使用 fastlane 執行以下 action, 將專案內 `Example/fastlane/actoins` 複製至您的專案下方的 `fastlane/actoins`, 於您的專案下執行以下指令, plist 請帶入您的 Info.plist 路徑
	- 增加白名單

	```
	fastlane run share_setting plist:{Info.plist path}
	```
	
	- 增加微信 URL Scheme, id 請帶入您的微信 appKey, plist 請帶入您的 Info.plist 路徑

	```
	fastlane run wechat_scheme id:{wechat_appKey} plist:{Info.plist path}
	```
	
	- 增加QQ URL Scheme, id 請帶入您的 QQ appId, plist 請帶入您的 Info.plist 路徑

	```
	fastlane run qq_scheme id:{QQ_appId} plist:{Info.plist path}
	```
	
	- 增加新浪微博 URL Scheme, id 請帶入您的新浪微博 appKey, plist 請帶入您的 Info.plist 路徑

	```
	fastlane run sinaweibo_scheme id:{sinaweibo_appKey} plist:{Info.plist path}
	```
	
## Universal Link設定

- 參考網站
	- [https://www.jianshu.com/p/9117f925447c](https://www.jianshu.com/p/9117f925447c)

	

## React Native Bridge

[React Native Bridge 安裝手冊](Documents/ReactNativeInstall.md)

[React Native Bridge API文件](Documents/ReactNativeAPI.md)
