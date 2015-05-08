//
//  SettingTableViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/8.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "SettingTableViewController.h"
#import "ManagerTableViewController.h"
#import "LoginAdminViewController.h"
@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (BOOL)isLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSLog(@"isLogin = %d",[defaults boolForKey:@"isLogin"]);
    return [defaults boolForKey:@"isLogin"];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if ([self isLogin]) {
                [self performSegueWithIdentifier:@"setting2manager" sender:nil];
            }else{
                [self performSegueWithIdentifier:@"setting2login" sender:nil];
            }
            break;
            
        default:
            break;
    }
    
}



@end
