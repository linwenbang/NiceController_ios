//
//  ManagerUser.h
//  NiceController
//
//  Created by linwenbang on 15/5/8.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerUser : NSObject
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,strong) NSString *isAdmin;
@property (nonatomic,strong) NSString *alias;
@end
