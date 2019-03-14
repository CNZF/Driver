//
//  ZCSetPayPWDViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/2.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCSetPayPWDViewController.h"
#import "ZCWalletViewModel.h"

@interface ZCSetPayPWDViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer * validationTimer;
@property (nonatomic, assign) int validationSurplusTime;

@end

@implementation ZCSetPayPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindView {
//    self.title = @"设置支付密码";

    [self.btnGetCode setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnGetCode.layer setMasksToBounds:YES];
    [self.btnGetCode.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    [self.btnSubmit setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnSubmit.layer setMasksToBounds:YES];
    [self.btnSubmit.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    self.tfIDCard.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.view endEditing:YES];

    return YES;
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

//提交
- (IBAction)submiteAction:(id)sender {

    if ([self.tfIDCard.text isEqualToString:@""]) {

        [[Toast shareToast]makeText:@"身份证号为空" aDuration:1];

    }else if ([self.tfGetCode.text isEqualToString:@""]){

        [[Toast shareToast]makeText:@"验证码为空" aDuration:1];
    }
    else if ([self.tfPayPWD.text isEqualToString:@""]){

        [[Toast shareToast]makeText:@"密码为空" aDuration:1];

    } else if (![self.tfPayPWD.text isEqualToString:self.tfPayPWD2.text]){

        [[Toast shareToast]makeText:@"两次密码不一致" aDuration:1];
        
    }else {

        NSString *searchText = self.tfIDCard.text;
        NSError *error = NULL;
        //十五位身份证号

        //        NSRegularExpression *regex15 = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$" options:NSRegularExpressionCaseInsensitive error:&error];
        //        NSTextCheckingResult *result15 = [regex15 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];

        NSRegularExpression *regex18 = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$" options:NSRegularExpressionCaseInsensitive error:&error];

        NSTextCheckingResult *result18 = [regex18 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (result18) {

            ZCWalletViewModel *vm = [ZCWalletViewModel new];
            WS(ws);

            
            [vm setPayPWDWithIdCard:self.tfIDCard.text WithPassword:self.tfPayPWD.text WithVerifyCode:self.tfGetCode.text callback:^(NSString *st) {


                UserInfoModel *userInfo = USER_INFO;
                userInfo.hasPayPassword = @"1";

                [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];

                [[Toast shareToast]makeText:@"设置成功" aDuration:1];
                [ws.navigationController popViewControllerAnimated:YES];

            }];


        }else{
            [[Toast shareToast]makeText:@"身份证号码格式错误" aDuration:1];
        }

    }



}

@end
