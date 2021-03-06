//
//  DeviceViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/6.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "DeviceViewController.h"
#import "ASIHTTPRequest.h"
#import "MJExtension.h"
#import "Device.h"
#import "HttpResultJson.h"
#import "AdId.h"
#import "MBProgressHUD+MJ.h"
#import "UrlConstants.h"

typedef enum{
    //以下是枚举成员
    ALL,
    LED,
    FAN,
    BEEP,
    LOCK
}DEVICE;

@interface DeviceViewController ()<ASIHTTPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIButton *led;
@property (weak, nonatomic) IBOutlet UIButton *fan;
@property (weak, nonatomic) IBOutlet UIButton *beep;
@property (weak, nonatomic) IBOutlet UIButton *lock;
@property (weak, nonatomic) IBOutlet UIButton *hum;
@property (weak, nonatomic) IBOutlet UIButton *temp;

@property (weak, nonatomic) IBOutlet UISlider *hum_bar;
@property (weak, nonatomic) IBOutlet UISlider *temp_bar;

@property (weak, nonatomic) IBOutlet UILabel *HumCount;
@property (weak, nonatomic) IBOutlet UILabel *TempCount;

- (IBAction)ledClick:(UIButton *)sender;
- (IBAction)fanClick:(UIButton *)sender;
- (IBAction)beepClick:(UIButton *)sender;
- (IBAction)lockClick:(UIButton *)sender;



- (IBAction)HumSlide:(UISlider *)sender;
- (IBAction)TempSlide:(UISlider *)sender;
- (IBAction)updateAllDevice:(UIButton *)sender;


@property (nonatomic,assign) DEVICE enum_device;
@property (nonatomic,weak) UIControl *viewClick;


@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNoAdmin];
    [self changeDeviceStatusWithDviceName:@"all" andAction:@"status" andView:nil];
    
}
- (void)setNoAdmin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:false forKey:@"isLogin"];
    [defaults synchronize];
}

- (void)changeDeviceStatusWithDviceName:(NSString *)deviceName andAction:(NSString *)action andView:(UIControl *)view{
    
    self.viewClick = view;
    
    if (![deviceName isEqualToString:@"all"]) {
        if (self.viewClick.isSelected) {
             action = @"close";
        }else{
             action = @"open";
        }
    }

    
    NSString *urlString = [UrlConstants getDeviceUrl];

    NSLog(@"url = %@ ",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //设置post body
    NSString *body = [NSString stringWithFormat:@"device=%@&action=%@",deviceName,action];
    NSLog(@"body = %@ ",body);
    [request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}


- (IBAction)ledClick:(UIButton *)sender {
    self.enum_device = LED;
    [self changeDeviceStatusWithDviceName:@"led" andAction:nil andView:sender];
    
}

- (IBAction)fanClick:(UIButton *)sender {
    self.enum_device = FAN;
     [self changeDeviceStatusWithDviceName:@"fan" andAction:nil andView:sender];
}

- (IBAction)beepClick:(UIButton *)sender {
    self.enum_device = BEEP;
     [self changeDeviceStatusWithDviceName:@"beep" andAction:nil andView:sender];
    
}

- (IBAction)lockClick:(UIButton *)sender {
    self.enum_device = LOCK;
     [self changeDeviceStatusWithDviceName:@"safe_mode" andAction:nil andView:sender];
}

- (IBAction)HumSlide:(UISlider *)sender {
    
    [self.HumCount setText:[NSString stringWithFormat:@"%2.0f",sender.value * 100]];
    
}

- (IBAction)TempSlide:(UISlider *)sender {
    [self.TempCount setText:[NSString stringWithFormat:@"%2.0f",sender.value * 100]];
    
}

- (IBAction)updateAllDevice:(UIButton *)sender {
    
    [self changeDeviceStatusWithDviceName:@"all" andAction:@"status" andView:nil];
    self.enum_device = ALL;
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
            
            switch (self.enum_device) {
                case ALL:
                    //设置led等状态
                    [self setDeviceWithJson:json];
                    [MBProgressHUD showSuccess:@"更新成功"];
                    break;
                default:
                    self.viewClick.selected = !self.viewClick.isSelected;
                    break;
            }

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

/**
 *  设置所有设备状态
 */
- (void)setDeviceWithJson:(HttpResultJson *)json{
    
    //处理json
    Device *device = [Device objectWithKeyValues:json.dto];
    NSLog(@"pic = %@ led = %d",device.picture,device.led);
    
    self.led.selected = device.led;
    self.fan.selected = device.fan;
    
    self.beep.selected = device.beep;
    self.lock.selected = device.safe_mode;
    
    Dht11 *dht11 = device.dht11;
    self.HumCount.text = [NSString stringWithFormat:@"%2.0f",dht11.wet];
    self.TempCount.text = [NSString stringWithFormat:@"%2.0f",dht11.temp];
    self.hum_bar.value = dht11.wet / 100;
    self.temp_bar.value = dht11.temp / 100;
    
}

@end
