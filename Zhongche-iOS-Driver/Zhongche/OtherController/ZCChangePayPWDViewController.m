//
//  ZCChangePayPWDViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/3.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCChangePayPWDViewController.h"
#import "ZCWalletViewModel.h"

@interface ZCChangePayPWDViewController ()

@property (nonatomic, strong) NSTimer * validationTimer;
@property (nonatomic, assign) int validationSurplusTime;

@end

@implementation ZCChangePayPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindView {
    //    self.title = @"设置支付密码";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self.btnGetCode setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnGetCode.layer setMasksToBounds:YES];
    [self.btnGetCode.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    [self.btnSubmite setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnSubmite.layer setMasksToBounds:YES];
    [self.btnSubmite.layer setCornerRadius:5.0];//设置矩形四个圆角半径

//    self.tfIDCard.delegate = self;
}


/**
 *  更新验证码时间
 */
-(void)updateVerificatetime {
    self.validationSurplusTime --;
    [self.btnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    if (self.validationSurplusTime == 0) {
        [self.btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_validationTimer invalidate];
        self.btnGetCode.userInteractionEnabled = YES;
    }
}

//获取验证码
- (IBAction)getCodeAction:(id)sender {

    self.btnGetCode.userInteractionEnabled = NO;
    self.validationSurplusTime = 60;
    [self.btnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];

    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    UserInfoModel *us = USER_INFO;
    [vm getPayPWDRCodeWithPhone: us.phone callback:^(NSString *st) {

    }];
}

//提交操作
- (IBAction)submiteAction:(id)sender {

    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    WS(ws);
    [vm setPayPWDWithOldPassword:self.tfOldPWD.text WithNewPassword:self.tfNewPWD.text WithVerifyCode:self.tfGetCode.text callback:^(NSString *st) {
        [[Toast shareToast]makeText:@"修改成功" aDuration:1];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

@end
