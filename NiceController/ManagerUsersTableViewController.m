//
//  ManagerUsersTableViewController.m
//  NiceController
//
//  Created by linwenbang on 15/5/8.
//  Copyright (c) 2015年 linwenbang. All rights reserved.
//

#import "ManagerUsersTableViewController.h"
#import "ManagerUser.h"
#import "ASIHTTPRequest.h"
#import "HttpResultJson.h"
#import "MBProgressHUD+MJ.h"

@interface ManagerUsersTableViewController ()<ASIHTTPRequestDelegate>
@property (nonatomic,strong) NSMutableArray *userData;

@property (nonatomic,weak) UIButton *delBtn;

@end

@implementation ManagerUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 85;
    [self getData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userData.count;
}

- (void)getData{
    
    [MBProgressHUD showMessage:@"正在加载中..." toView:self.view];
    NSString *urlString = [UrlConstants getALLUsersUrl];
    
    NSLog(@"url = %@ ",urlString);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // 当以文本形式读取返回内容时用这个方法
    NSString *responseString = [request responseString];
    NSLog(@"responseString = %@",responseString);
    
    HttpResultJson *json = [HttpResultJson objectWithKeyValues:responseString];
    
//    UITableViewCell *cell = (UITableViewCell *)[[[self.delBtn superview] superview] superview];
//     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (json.code) {
        case 200:
            
            self.userData = (NSMutableArray *)[ManagerUser objectArrayWithKeyValuesArray:json.dto];
            
            [self.tableView reloadData];
            break;
        case 444:
            //删除成功返回

            NSLog(@"indexPath is = %i",self.delBtn.tag);
            [self.userData removeObjectAtIndex:self.delBtn.tag];
            
            [self.tableView reloadData];
            
            break;
        default:
            [MBProgressHUD showError:json.summary];
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"请求失败");
    [MBProgressHUD showError:@"请求失败"];
}

- (void)delUser:(UIButton *)btn{
    
    ManagerUser *user = self.userData[self.tableView.indexPathForSelectedRow.row];
    self.delBtn = btn;
    NSLog(@"selectRow = %d",self.delBtn.tag);
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v2.0/regist/%@&%@",[UrlConstants getUrlHead],[AdId getAdId],user.userid];

    
    NSLog(@"url = %@ ",urlString);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setRequestMethod:@"DELETE"];
    [request setDelegate:self];
    [request startAsynchronous];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"user";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *subviews = [cell.contentView subviews];
    
    ManagerUser *user = self.userData[indexPath.row];
    UILabel *userid = subviews[1];
    UILabel *alias = subviews[3];
    UILabel *isAdmin = subviews[2];
    UIButton *delBtn = subviews[0];
    
    [delBtn addTarget:self action:@selector(delUser:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = indexPath.row;
    
    userid.text = user.userid;
    alias.text = user.alias;
    isAdmin.text = user.isAdmin;
    
    return cell;
}


@end
