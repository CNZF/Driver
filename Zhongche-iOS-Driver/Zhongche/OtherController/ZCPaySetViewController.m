//
//  ZCPaySetViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/4.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCPaySetViewController.h"
#import "ZCChangePayPWDViewController.h"
#import "ZCSetPayPWDViewController.h"

@interface ZCPaySetViewController ()

@end

@implementation ZCPaySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindView {
    self.title = @"支付设置";
}

//更改密码
- (IBAction)changePWDAction:(id)sender {
    ZCChangePayPWDViewController *VC = [ZCChangePayPWDViewController new];
    VC.title = @"修改支付密码";

    [self.navigationController pushViewController:VC animated:YES];
}

//忘记密码
- (IBAction)findBackPwd:(id)sender {

    ZCSetPayPWDViewController *vc = [ZCSetPayPWDViewController new];
    vc.title = @"重置支付密码";

    [self.navigationController pushViewController:vc animated:YES];

}


@end
