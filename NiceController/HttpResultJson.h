//
//  HttpResultJson.h
//  NiceController
//
//  Created by linwenbang on 15/5/6.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResultJson : NSObject

@property (nonatomic,assign) int code;
@property (nonatomic,copy) NSString *dto;
@property (nonatomic,copy) NSString *summary;

@end
