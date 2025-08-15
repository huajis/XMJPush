//
//  BFJService+Tag.m
//  Example
//
//  Created by User on 2020/8/3.
//  Copyright © 2020 User. All rights reserved.
//

#import "BFJService+Tag.h"
#import <JPush/JPUSHService.h>

static NSInteger responseCodeSuccess = 200;

@implementation BFJService (Tag)

+ (void)addTag:(NSString *)tag completion:(BFJServiceTagCompletion)completion {
    NSInteger number = self.sequenceNumber;
    [JPUSHService addTags:[NSSet setWithObject:tag] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        if (seq != number && ![iTags containsObject:tag]) {
            return;
        }
        NSInteger responseCode = iResCode;
        if (iResCode == 0) {
            responseCode = responseCodeSuccess;
        }
        completion(responseCode);
    } seq:number];
}

+ (void)setTag:(NSString *)tag completion:(BFJServiceTagCompletion)completion {
    NSInteger number = self.sequenceNumber;
    [JPUSHService setTags:[NSSet setWithObject:tag] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        if (seq != number && ![iTags containsObject:tag]) {
            return;
        }
        NSInteger responseCode = iResCode;
        if (iResCode == 0) {
            responseCode = responseCodeSuccess;
        }
        completion(responseCode);
    } seq:number];
}

+ (void)validTag:(NSString *)tag completion:(BFJServiceTagCompletion)completion {
    NSInteger number = self.sequenceNumber;
    [JPUSHService validTag:tag completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq, BOOL isBind) {
        if (seq != number && ![iTags containsObject:tag]) {
            return;
        }
        NSInteger responseCode = iResCode;
        if (iResCode == 0 && isBind) {
            responseCode = responseCodeSuccess;
        }
        completion(responseCode);
    } seq:number];
}

@end
