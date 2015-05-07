//
//  UrlModiifyViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/7.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "UrlModiifyViewController.h"
#import "MBProgressHUD+MJ.h"

@interface UrlModiifyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (weak, nonatomic) IBOutlet UILabel *currentUrlLabel;


- (IBAction)submit:(UIButton *)sender;

@end

@implementation UrlModiifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self readCurrentURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)checkParam{
    if ([self.urlTextView.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"请输需要修改的url_head"];
        return false;
    }else{
        return true;
    }
}

- (IBAction)submit:(UIButton *)sender {
    
    if (![self checkParam]) {
        return ;
    }
    
    //把url存到文档中
    
    // 1.利用NSUserDefaults,就能直接访问软件的偏好设置(Library/Preferences)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 2.存储数据
    [defaults setObject:self.urlTextView.text forKey:@"url_head"];
    
    // 3.立刻同步，将内存中的数据存到文件中
    [defaults synchronize];
    
    self.urlTextView.text = nil;
    
    [self readCurrentURL];
    
}

- (void)readCurrentURL{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *url = [defaults objectForKey:@"url_head"];
    
    if (![url isEqualToString:@""]) {
        self.currentUrlLabel.text = url;
    }
}

@end
