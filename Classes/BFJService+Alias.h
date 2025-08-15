//
//  BFJService+Alias.h
//  Example
//
//  Created by User on 2020/8/3.
//  Copyright © 2020 User. All rights reserved.
//

#import "BFJService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ BFJServiceAliasCompletion)(NSInteger *responseCode, NSString *alias);

@interface BFJService (Alias)

+ (void)setAlias:(NSString *)alias completion:(BFJServiceAliasCompletion)completion;
+ (void)deleteAliasWithCompletion:(BFJServiceAliasCompletion)completion;
+ (void)getAliasWithCompletion:(BFJServiceAliasCompletion)completion;

@end

NS_ASSUME_NONNULL_END
