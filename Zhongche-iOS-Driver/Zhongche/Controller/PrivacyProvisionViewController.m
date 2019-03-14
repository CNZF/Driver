//
//  PrivacyProvisionViewController.m
//  Zhongche
//
//  Created by lxy on 2017/3/20.
//  Copyright © 2017年 lxy. All rights reserved.
//

#import "PrivacyProvisionViewController.h"
#import "DynamicDetailsViewController.h"

@interface PrivacyProvisionViewController ()

@end

@implementation PrivacyProvisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";

    UIButton *btnPush = [UIButton new];

    btnPush.frame = CGRectMake(0, 100, SCREEN_W, 40);
    [btnPush setTitle:@"用户协议与隐私条款" forState:UIControlStateNormal];
    btnPush.titleLabel.font = [UIFont systemFontOfSize:18];
    [btnPush setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnPush addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPush];

    NSDictionary *dic = [NSBundle mainBundle].infoDictionary;
    NSString *appversion = dic[@"CFBundleShortVersionString"];

    UILabel *lbAppversion = [UILabel new];
    lbAppversion.frame = CGRectMake(0, SCREEN_H - 164, SCREEN_W, 44);
    lbAppversion.font = [UIFont systemFontOfSize:14];
    lbAppversion.textColor = [UIColor lightGrayColor];
    lbAppversion.textAlignment = NSTextAlignmentCenter;
    lbAppversion.text = [NSString stringWithFormat:@"V %@",appversion];
    [self.view addSubview:lbAppversion];


}

- (void)pushAction{

    DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
    vc.title = @"条款与隐私";
    vc.urlStr = @"";
    [self.navigationController pushViewController:vc animated:YES];

}

@end
