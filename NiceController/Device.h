//
//  Device.h
//  NiceController
//
//  Created by linwenbang on 15/5/6.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dht11.h"

@interface Device : NSObject

@property (nonatomic,copy) NSString *picture;
@property (nonatomic,assign) bool led;
@property (nonatomic,assign) bool beep;
@property (nonatomic,assign) bool fan;
@property (nonatomic,assign) bool safe_mode;
@property (nonatomic,strong) Dht11 *dht11;


@end
