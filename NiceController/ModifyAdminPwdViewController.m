//
//  ModifyAdminPwdViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "ModifyAdminPwdViewController.h"
#import "ASIHTTPRequest.h"
#import "HttpResultJson.h"
#import "MBProgressHUD+MJ.h"

@interface ModifyAdminPwdViewController ()<ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pwdOld;
@property (weak, nonatomic) IBOutlet UITextField *pwdNew;

- (IBAction)submit:(UIButton *)sender;


@end
@implementation ModifyAdminPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)checkParam{
    if ([self.pwdOld.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入旧密码"];
        return false;
    }
    
    if ([self.pwdNew.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入新密码"];
        return false;
    }
    
    if ([self.pwdOld.text isEqualToString:self.pwdNew.text]) {
        [MBProgressHUD showError:@"旧密码和新密码不能一样"];
        return false;
    }
    return true;
}

- (IBAction)submit:(UIButton *)sender {
    
    if (![self checkParam]) {
        return ;
    }
    
    NSString *urlString = [UrlConstants getModifyAdminPwdUrl];
    
    NSLog(@"url = %@ ",urlString);
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //设置post body
    NSString *body = [NSString stringWithFormat:@"userid=%@&oldpassword=%@&newpassword=%@",[AdId getAdId],self.pwdOld.text, self.pwdNew.text];
    NSLog(@"body = %@ ",body);
    [request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"PUT"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    
}


- (void)requestFinished:(ASIHTTPRequest *)request{
    // 当以文本形式读取返回内容时用这个方法
    NSString *responseString = [request responseString];
    NSLog(@"responseString = %@",responseString);
    // 当以二进制形式读取返回内容时用这个方法
    //    NSData *responseData = [request responseData];
    
    HttpResultJson *json = [HttpResultJson objectWithKeyValues:responseString];
    switch (json.code) {
        case 200:
            
            [MBProgressHUD showSuccess:@"修改成功"];
            
            break;
            
        default:
            [MBProgressHUD showError:json.summary];
            break;
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求失败");
    [MBProgressHUD showError:@"请求失败"];
}
@end
