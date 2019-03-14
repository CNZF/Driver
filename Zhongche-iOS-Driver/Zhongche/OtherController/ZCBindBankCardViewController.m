//
//  ZCBindBankCardViewController.m
//  Zhongche
//
//  Created by lxy on 2016/10/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCBindBankCardViewController.h"
#import "ZCWalletViewModel.h"
#import "UserInfoViewModel.h"
#import "UserInfoModel.h"
#import "ZCBankCardModel.h"
#import "ZCMayBindCardViewController.h"

@interface ZCBindBankCardViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer * validationTimer;
@property (nonatomic, assign) int validationSurplusTime;
@property (nonatomic, strong) ZCBankCardModel *cardinfo;

@end

@implementation ZCBindBankCardViewController



- (void)viewDidLoad {
    [super viewDidLoad];


    //[vm getBankRelativeWithBankCardNum:@"6227000783050216088"];

//    WS(ws);
//    [vm getBankRelativeWithBankCardNum:@"6227000783050216088" callback:^(ZCBankCardModel *info) {
//        ws.cardinfo =info;
//
//
//    }];

}

- (void)bindView {

    self.title = @"绑定银行卡";
    
    [self.btnGetCode setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnGetCode.layer setMasksToBounds:YES];
    [self.btnGetCode.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    [self.btnSubmit setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnSubmit.layer setMasksToBounds:YES];
    [self.btnSubmit.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    self.tfBankCardNum.delegate = self;

}

- (void)onBackAction {

    [self.navigationController popToViewControllerWithClassName:@"ZCWalletViewController" animated:YES];
}


//获取验证码
- (IBAction)codeAction:(id)sender {

    self.btnGetCode.userInteractionEnabled = NO;
    self.validationSurplusTime = 60;
    [self.btnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];
    ZCWalletViewModel *vm = [ZCWalletViewModel new];

    UserInfoModel *us = USER_INFO;

    [vm getRCodeWithPhone:us.phone callback:^(NSString *st) {

    }];

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

//提交
- (IBAction)submiteAction:(id)sender {

    ZCWalletViewModel *vm = [ZCWalletViewModel new];

//    self.cardinfo.name
//    self.tfCode.text
    if ([self.tfName.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"姓名不能为空" aDuration:1];
    }else if ([self.tfBankCardNum.text isEqualToString:@""]){
        [[Toast shareToast]makeText:@"银行卡号不能为空" aDuration:1];
    }else if ([self.tfCode.text isEqualToString:@""]){
        [[Toast shareToast]makeText:@"验证码不能为空" aDuration:1];
    }else{

        WS(ws);
        [vm bindWalletWithUserName:self.tfName.text WithBankCardNum:self.tfBankCardNum.text WithVerifyCode:self.tfCode.text WithBankCardName:self.cardinfo.name WithBankCardCode:self.cardinfo.code callback:^(NSString *st) {
            [ws.navigationController pushViewController:[ZCMayBindCardViewController new] animated:YES];
        }];

    }



    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {


    if (textField == self.tfBankCardNum) {


        int num = (int)string.length;

        if ([string isEqualToString:@""]) {

            num = -1;

        }

        if ( textField.text.length + num == 10) {

            ZCWalletViewModel *vm = [ZCWalletViewModel new];

            WS(ws);

            [vm getBankRelativeWithBankCardNum:textField.text callback:^(ZCBankCardModel *info) {
                ws.cardinfo =info;
                
                ws.tfBankName.text = info.name;
                
                
            }];
            
            
        }

    }




    return YES;
}



@end
