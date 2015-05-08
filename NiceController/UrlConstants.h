//
//  UrlConstants.h
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdId.h"
#import "HttpResultJson.h"
#import "MJExtension.h"
@interface UrlConstants : NSObject

+ (NSString *)getUrlHead;
+ (NSString *)getDeviceUrl;
+ (NSString *)getUserRegisterUrl;
+ (NSString *)getLoginAmdinUrl;
+ (NSString *)getLogoutAmdinUrl;
+ (NSString *)getModifyAdminPwdUrl;
+ (NSString *)getALLUsersUrl;

@end
