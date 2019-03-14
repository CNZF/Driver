//
//  PersonHomeViewController.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "PersonHomeViewController.h"
#import "personHomeHeadView.h"
#import "PersonListTableViewCell.h"
#import "PersontabTableViewCell.h"
#import "DynamicDetailsViewController.h"

@interface PersonHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) personHomeHeadView * personHeadView;

@end

@implementation PersonHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor yellowColor];
    [self.headView addSubview:self.personHeadView];
}

- (void)viewWillAppear:(BOOL)animated
{
//    UserInfoViewModel *vm = [UserInfoViewModel new];
//    WS(ws);
    UserInfoModel *userInfo = USER_INFO;
    self.personHeadView.info = userInfo;
    WS(weakSelf);
    UserInfoViewModel *vm = [UserInfoViewModel new];
    [vm getUserInfoWithUserId:^(UserInfoModel *userInfo) {
        
        [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
        userInfo = USER_INFO;
        weakSelf.personHeadView.info = userInfo;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?1:3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PersonListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonListTableViewCell" forIndexPath:indexPath];
        [cell getTarget:self];
        return cell;
    }else{
        PersontabTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersontabTableViewCell" forIndexPath:indexPath];
        [cell setCellPrefernceWitnIndexPath:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0?94.0f:60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  section == 0?CGFLOAT_MIN:20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self callKefuTel];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [self checkNewVersion];
    }else{
        DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
        vc.title = @"关于";
        vc.urlStr = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --检查新版本
- (void)checkNewVersion{
    UserInfoViewModel *vm = [UserInfoViewModel new];
    WS(ws);
    [vm checkEdition:^(CheckInfo *info) {
        
        if (info) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"有新版本需要更新" preferredStyle:UIAlertControllerStyleAlert];
            //添加确定和取消按钮
            UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"去AppStore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:info.url]];
                
            }];
            [alert addAction:cacleAction];
            [alert addAction:sureAction];
            [ws presentViewController:alert animated:NO completion:nil];
            
        }else{
            [[Toast shareToast]makeText:@"暂无更新！" aDuration:1];
        }
        
    }];
}

#pragma mark  -- 客服电话
- (void)callKefuTel
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" preferredStyle:UIAlertControllerStyleAlert];
    //添加确定和取消按钮
    UIAlertAction *cacleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",APP_CUSTOMER_SERVICE]]];
        
    }];
    [alert addAction:cacleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:NO completion:nil];
}

- (personHomeHeadView *)personHeadView
{
    if (!_personHeadView) {
        _personHeadView = [[[NSBundle mainBundle] loadNibNamed:@"personHomeHeadView" owner:self options:nil] firstObject];
        _personHeadView.frame = CGRectMake(0, 0, SCREEN_W, 249);
        [_personHeadView getControllerWith:self];
    }
    return _personHeadView;
}
@end
