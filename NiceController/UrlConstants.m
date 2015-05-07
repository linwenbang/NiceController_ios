//
//  UrlConstants.m
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "UrlConstants.h"

@interface UrlConstants ()


@end

@implementation UrlConstants

+ (NSString *)getUrlHead{
    
    
    
    return @"http://smarthome523000.sinaapp.com/";
}

+ (NSString *)getDeviceUrl{
    return [NSString stringWithFormat:@"%@api/v2.0/device/%@",[UrlConstants getUrlHead],[AdId getAdId]];
}

+ (NSString *)getUserRegisterUrl{
    return [NSString stringWithFormat:@"%@api/v2.0/regist/%@",[UrlConstants getUrlHead],[AdId getAdId]];
}


+ (NSString *)getLoginAmdinUrl{
    return [NSString stringWithFormat:@"%@api/v2.0/login/%@",[UrlConstants getUrlHead],[AdId getAdId]];
}

+ (NSString *)getLogoutAmdinUrl{
    return [NSString stringWithFormat:@"%@api/v2.0/logout/%@",[UrlConstants getUrlHead],[AdId getAdId]];
}


@end
