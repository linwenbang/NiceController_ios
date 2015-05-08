//
//  ManagerTableViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/8.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "ManagerTableViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD+MJ.h"
#import "HttpResultJson.h"
@interface ManagerTableViewController ()<ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;

@end

@implementation ManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isLogin]) {
        self.logoutCell.hidden = NO;
    }else{
        self.logoutCell.hidden = YES;
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

/**
 *  退出登录
 */
- (void)logout{
    NSString *urlString = [UrlConstants getLogoutAmdinUrl];
    ASIHTTPRequest *request = request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setRequestMethod:@"PUT"];
    [request setDelegate:self];
    [request startSynchronous];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 3:
            [self logout];
            break;
            
        default:
            break;
    }
}

- (BOOL)isLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSLog(@"isLogin = %d",[defaults boolForKey:@"isLogin"]);
    return [defaults boolForKey:@"isLogin"];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    NSLog(@"responseString = %@",responseString);
    
    HttpResultJson *json = [HttpResultJson objectWithKeyValues:responseString];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (json.code) {
        case 200:
        case 201:
            [MBProgressHUD showSuccess:@"退出登陆成功"];
            //将登陆状态 保存到文件中
            [defaults setBool:false forKey:@"isLogin"];
            
            [defaults synchronize];
            
            self.logoutCell.hidden = YES;
            break;
        default:
//            [MBProgressHUD showSuccess:@"退出登陆成功"];
//            //将登陆状态 保存到文件中
//            [defaults setBool:false forKey:@"isLogin"];
//            
//            [defaults synchronize];
//            
//            self.logoutCell.hidden = YES;
            [MBProgressHUD showError:json.summary];
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD showError:@"请求失败"];
}



@end
