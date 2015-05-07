//
//  AdId.m
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "AdId.h"
#import <AdSupport/AdSupport.h>

@implementation AdId

+ (NSString *)getAdId{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    adId = [adId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    adId = [adId substringFromIndex:10];
    
    return adId;
}

@end
