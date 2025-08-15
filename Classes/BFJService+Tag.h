//
//  BFJService+Tag.h
//  Example
//
//  Created by User on 2020/8/3.
//  Copyright © 2020 User. All rights reserved.
//

#import "BFJService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ BFJServiceTagCompletion)(NSInteger responseCode);

@interface BFJService (Tag)

+ (void)addTag:(NSString *)tag completion:(BFJServiceTagCompletion)completion;
+ (void)setTag:(NSString *)tag completion:(BFJServiceTagCompletion)completion;
+ (void)validTag:(NSString *)tag completion:(BFJServiceTagCompletion)completion;

@end

NS_ASSUME_NONNULL_END
