//
//  LoginAdminViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "LoginAdminViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ASIHTTPRequest.h"
#import "UrlConstants.h"

@interface LoginAdminViewController ()<ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *sumbitBtn;


- (IBAction)submit:(UIButton *)sender;

@end

@implementation LoginAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self isLogin]) {
        [self.sumbitBtn setTitle:@"登录" forState:UIControlStateNormal];
    }else{
        [self.sumbitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        self.pwdTextField.enabled = NO;
    }
}

- (BOOL)checkParam{
    if ([self.pwdTextField.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输入密码"];
        return false;
    }else{
        return true;
    }
}

- (IBAction)submit:(UIButton *)sender {
    
    
    NSString *urlString = nil;
    ASIHTTPRequest *request  = nil;
    if (![self isLogin]) {
        
        if (![self checkParam]) {
            return ;
        }
        
        
        urlString = [UrlConstants getLoginAmdinUrl];
        
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [request setRequestMethod:@"POST"];
        
        //设置post body
        NSString *body = [NSString stringWithFormat:@"userid=%@&password=%@",[AdId getAdId],self.pwdTextField.text];
        NSLog(@"body = %@",body);
        [request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
    }else{
        urlString = [UrlConstants getLogoutAmdinUrl];
        
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [request setRequestMethod:@"PUT"];
    }
    
    NSLog(@"url = %@",urlString);
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    
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
            [MBProgressHUD showSuccess:@"登陆成功"];
            //将登陆状态 保存到文件中
            [defaults setBool:true forKey:@"isLogin"];
            
            [defaults synchronize];
            
            [self.sumbitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            
            self.pwdTextField.enabled = NO;
            
            break;
        case 201:
            [MBProgressHUD showSuccess:@"退出登陆成功"];
            //将登陆状态 保存到文件中
            [defaults setBool:false forKey:@"isLogin"];
            
            [defaults synchronize];
            
            [self.sumbitBtn setTitle:@"登录" forState:UIControlStateNormal];
            self.pwdTextField.enabled = YES;
            
            break;
        default:
            if ([self isLogin]) {
                [defaults setBool:false forKey:@"isLogin"];
                [defaults synchronize];
                
                [self.sumbitBtn setTitle:@"登录" forState:UIControlStateNormal];
                self.pwdTextField.enabled = YES;
                
            }
            
            [MBProgressHUD showError:json.summary];
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD showError:@"请求失败"];
}

@end
