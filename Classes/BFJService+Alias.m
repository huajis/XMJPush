//
//  BFJService+Alias.m
//  Example
//
//  Created by User on 2020/8/3.
//  Copyright © 2020 User. All rights reserved.
//

#import "BFJService+Alias.h"
#import <JPush/JPUSHService.h>

static NSInteger responseCodeSuccess = 200;

@implementation BFJService (Alias)

+ (void)setAlias:(NSString *)alias completion:(BFJServiceAliasCompletion)completion {
    NSInteger number = self.sequenceNumber;
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (seq != number && ![iAlias isEqualToString:alias]) {
            return;
        }
        NSInteger responseCode = iResCode;
        if (iResCode == 0) {
            responseCode = responseCodeSuccess;
        }
        completion(responseCode, iAlias);
    } seq:number];
}

+ (void)deleteAliasWithCompletion:(BFJServiceAliasCompletion)completion {
    NSInteger number = self.sequenceNumber;
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (seq != number) {
            return;
        }
        NSInteger responseCode = iResCode;
        if (iResCode == 0) {
            responseCode = responseCodeSuccess;
        }
        completion(responseCode, iAlias);
    } seq:number];
}

+ (void)getAliasWithCompletion:(BFJServiceAliasCompletion)completion {
    NSInteger number = self.sequenceNumber;
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (seq != number) {
            return;
        }
        NSInteger responseCode = iResCode;
        if (iResCode == 0) {
            responseCode = responseCodeSuccess;
        }
        completion(responseCode, iAlias);
    } seq:number];
}

@end
