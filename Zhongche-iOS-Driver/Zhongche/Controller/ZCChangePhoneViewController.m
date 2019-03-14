//
//  ZCChangePhoneViewController.m
//  Zhongche
//
//  Created by lxy on 2016/9/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCChangePhoneViewController.h"
#import "UserInfoViewModel.h"

@interface ZCChangePhoneViewController ()

@property (nonatomic, strong) UIView      *viPhone;

@property (nonatomic, strong) UITextField *tfPhone;

@property (nonatomic, strong) UILabel     *lbPhone;

@property (nonatomic, strong) UILabel     *lbPWD;

@property (nonatomic, strong) UIView      *viverifyCode;

@property (nonatomic, strong) UITextField *tfverifyCode;

@property (nonatomic, strong) UIButton    *btnGetverifyCode;

@property (nonatomic, strong) UIButton    *btnFinish;

@property (nonatomic, strong) UIView      *viPWD;

@property (nonatomic, strong) UITextField *tfPWD;

@property (nonatomic, strong) NSTimer     * validationTimer;
@property (nonatomic, assign) int         validationSurplusTime;

@end

@implementation ZCChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {
    self.title = @"更换手机";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.viPhone.frame = CGRectMake(0, 20, SCREEN_W, 50);
    [self.view addSubview:self.viPhone];

    self.lbPhone.frame = CGRectMake(20, 10, 100, 30);
    [self.viPhone addSubview:self.lbPhone];

    self.tfPhone.frame = CGRectMake(self.lbPhone.right, 10, SCREEN_W - self.lbPhone.right, 30);
    [self.viPhone addSubview:self.tfPhone];

    self.viPWD.frame = CGRectMake(0, self.viPhone.bottom + 1, SCREEN_W, 50);
    [self.view addSubview:self.viPWD];

    self.lbPWD.frame = CGRectMake(20, 10, 100, 30);
    [self.viPWD addSubview:self.lbPWD];

    self.tfPWD.frame = CGRectMake(self.lbPWD.right, 10, SCREEN_W - self.lbPWD.right, 30);
    [self.viPWD addSubview:self.tfPWD];

    self.viverifyCode.frame = CGRectMake(0, self.viPWD.bottom + 1, SCREEN_W, 50);
    [self.view addSubview:self.viverifyCode];

    self.tfverifyCode.frame = CGRectMake(20, 10, SCREEN_W - 150, 30);
    [self.viverifyCode addSubview:self.tfverifyCode];

    self.btnGetverifyCode.frame = CGRectMake(self.tfverifyCode.right, 10, 100, 30);
    [self.viverifyCode addSubview:self.btnGetverifyCode];



    self.btnFinish.frame = CGRectMake(30, self.viverifyCode.bottom + 20, SCREEN_W - 60, 44);
    [self.view addSubview:self.btnFinish];




}

- (void)bindAction {

    WS(ws);
    [[self.btnFinish rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws finishAction];
    }];

    [[self.btnGetverifyCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws getcodeAction];
    }];
}

-(void)getcodeAction {


    if ([self.tfPhone.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"手机号为空" aDuration:1];

    }else {

    if ([self checkPhoneWithPhone:self.tfPhone.text]) {


            self.btnGetverifyCode.userInteractionEnabled = NO;
            self.validationSurplusTime = 60;
            [self.btnGetverifyCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
            _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];

            UserInfoViewModel *vm = [UserInfoViewModel new];

            [vm getRCodeWithPhone: self.tfPhone.text callback:^(NSString *st) {

                
            }];
            
        }else{

            [[Toast shareToast]makeText:@"手机号不正确" aDuration:1];
        }
    }
}

/**
 *  更新验证码时间
 */
-(void)updateVerificatetime {
    self.validationSurplusTime --;
    [self.btnGetverifyCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    if (self.validationSurplusTime == 0) {
        [self.btnGetverifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_validationTimer invalidate];
        self.btnGetverifyCode.userInteractionEnabled = YES;
    }
}

- (void)finishAction {

    if ([self.tfPhone.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"手机号为空" aDuration:1];

    }else if ([self.tfPWD.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"登陆密码为空" aDuration:1];

    }else if ([self.tfverifyCode.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"验证码为空" aDuration:1];

    }else {

        UserInfoViewModel *vm = [UserInfoViewModel new];
        WS(ws);
        [vm changePhoneWithPhone:self.tfPhone.text WithVerifyCode:self.tfverifyCode.text WithPassword:self.tfPWD.text callback:^(NSString *st) {

            UserInfoModel *us = nil;
            [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];

            CarInfoModel *car = nil;

            [NSKeyedArchiver archiveRootObject:car toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];
            [[Toast shareToast]makeText:@"注销成功" aDuration:1];
            [ws.navigationController popToRootViewControllerAnimated:YES];

        }];

    }



}


/**
 *  getter
 */

- (UIView *)viPhone {
    if (!_viPhone) {
        _viPhone = [UIView new];
        _viPhone.backgroundColor = [UIColor whiteColor];
    }
    return _viPhone;
}

- (UILabel *)lbPhone {
    if (!_lbPhone) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"新手机号";

        _lbPhone = label;
    }
    return _lbPhone;
}

- (UILabel *)lbPWD {
    if (!_lbPWD) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"登陆密码";

        _lbPWD = label;
    }
    return _lbPWD;
}

- (UITextField *)tfPhone {
    if (!_tfPhone) {
        _tfPhone = [UITextField new];
        _tfPhone.placeholder = @"请输入新手机号";
        _tfPhone.font = [UIFont systemFontOfSize:16.0f];
        _tfPhone.keyboardType = UIKeyboardTypePhonePad;
    }
    return _tfPhone;
}

- (UIView *)viverifyCode {
    if (!_viverifyCode) {
        _viverifyCode = [UIView new];
         _viverifyCode.backgroundColor = [UIColor whiteColor];
    }
    return _viverifyCode;
}

- (UITextField *)tfverifyCode {
    if (!_tfverifyCode) {
        _tfverifyCode = [UITextField new];
        _tfverifyCode.placeholder = @"请输入验证码";
        _tfverifyCode.font = [UIFont systemFontOfSize:16.0f];
    }
    return _tfverifyCode;
}

- (UIButton *)btnGetverifyCode {
    if (!_btnGetverifyCode) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];

        _btnGetverifyCode = button;
    }
    return _btnGetverifyCode;
}

- (UIButton *)btnFinish {
    if (!_btnFinish) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];

        _btnFinish = button;
    }
    return _btnFinish;
}

- (UIView *)viPWD {
    if (!_viPWD) {
        _viPWD = [UIView new];
        _viPWD.backgroundColor = [UIColor whiteColor];
    }
    return _viPWD;
}

- (UITextField *)tfPWD {
    if (!_tfPWD) {
        _tfPWD = [UITextField new];
        _tfPWD.placeholder = @"请输入登录密码";
        _tfPWD.font = [UIFont systemFontOfSize:16.0f];
        _tfPWD.secureTextEntry = YES;

    }
    return _tfPWD;
}

@end
