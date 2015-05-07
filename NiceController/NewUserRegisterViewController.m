//
//  NewUserRegisterViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "NewUserRegisterViewController.h"
#import "AdId.h"
#import "ASIHTTPRequest.h"
#import "HttpResultJson.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UrlConstants.h"

@interface NewUserRegisterViewController ()<ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;
- (IBAction)submit:(UIButton *)sender;

@end

@implementation NewUserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)showToastWithText:(NSString *)text{
//    //只显示文字
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = text;
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:3];
//}

- (BOOL)checkParam{
    if([self.aliasTextField.text isEqualToString:@""]){
        
        [MBProgressHUD showError:@"请输入昵称"];
        
        return false;
    }else{
        return true;
    }
        
    
   
}

/**
 *  提交POST: /api/v2.0/regist/{userid}
 */
- (IBAction)submit:(UIButton *)sender {
    
    //先检查submit问题
    if (![self checkParam]) {
        return ;
    }
    
    
    NSString *urlString = [UrlConstants getUserRegisterUrl];
    NSLog(@"url = %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //设置post body
    NSString *body = [NSString stringWithFormat:@"userid=%@&Alias=%@",[AdId getAdId],self.aliasTextField.text];
    NSLog(@"body = %@",body);
    [request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    NSString *responseString = [request responseString];
    NSLog(@"responseString = %@",responseString);
    
    HttpResultJson *json = [HttpResultJson objectWithKeyValues:responseString];
    switch (json.code) {
        case 200:
            [MBProgressHUD showSuccess:@"注册成功"];
            break;
            
        default:
            [MBProgressHUD showError:json.summary];
            break;
    }
}


-  (void)requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD showError:@"请求失败"];
}

@end
