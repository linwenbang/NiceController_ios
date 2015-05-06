//
//  ViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/4.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "ViewController.h"
#import "APService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册JPush
    [APService init];
    
    
}


@end
