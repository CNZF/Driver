//
//  ZCWithdrawViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCWithdrawViewController.h"
#import "ZCBankCardMessageInfo.h"
#import "ZCWalletViewModel.h"
#import "PayPWDView.h"
#import "TXTradePasswordView.h"
#import "ZCSetPayPWDViewController.h"

@interface ZCWithdrawViewController ()<TXTradePasswordViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) ZCBankCardMessageInfo *model;
@property (nonatomic, strong) PayPWDView *pview;

@end

@implementation ZCWithdrawViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    WS(ws);
    [vm getgetBindingBankCardcallback:^(ZCBankCardMessageInfo *info) {

        ws.model = info;
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
//[self.view endEditing:YES];
}

- (void)bindView {

    self.title = @"提现";

    [self.tfMoney setValue:[UIFont boldSystemFontOfSize:22] forKeyPath:@"_placeholderLabel.font"];
    [self.btnWithdraw setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnWithdraw.layer setMasksToBounds:YES];
    [self.btnWithdraw.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    self.tfMoney.textColor = APP_COLOR_ORANGR2;

    [self.btnAll setTitleColor:APP_COLOR_ORANGR2 forState:UIControlStateNormal];

    self.tfMoney.text = @"";

    
    
}


- (void)bindModel {



    WS(ws);

    [RACObserve(self, model) subscribeNext:^(id x) {

        ws.lbBankNum.text = [NSString stringWithFormat:@"(%@)",[ws.model.bankCardNum substringFromIndex:(ws.model.bankCardNum.length -4)]];
        ws.lbBankName.text = ws.model.bankCardNanme;
        
        
    }];



    [RACObserve(self, walletModel) subscribeNext:^(id x) {


        ws.lbNow.text = [NSString stringWithFormat:@"当前可提现金额为%.2f元",ws.walletModel.withdrawAccount];

    }];
}

//全部金额
- (IBAction)allAction:(id)sender {

     self.tfMoney.text = [NSString stringWithFormat:@"%.2f",self.walletModel.withdrawAccount];
}

//金额提取
- (IBAction)withDrawAction:(id)sender {


    if ([self.tfMoney.text isEqualToString:@""]) {

        [[Toast shareToast]makeText:@"请输入金额" aDuration:1];

    }else if ([self.tfMoney.text floatValue]>self.walletModel.withdrawAccount) {

         [[Toast shareToast]makeText:@"可提现金额不足" aDuration:1];

    }else if ([self.tfMoney.text floatValue]==0){

        [[Toast shareToast]makeText:@"可提现金额不足" aDuration:1];


    }else{

        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        _pview= [PayPWDView sharePushOrderView];
        [_pview.TXView.TF becomeFirstResponder];
        _pview.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        _pview.TXView.TXTradePasswordDelegate = self;
        _pview.lbMoney.text = [NSString stringWithFormat:@"￥%@",self.tfMoney.text];
        [window addSubview:_pview];

    }


}


#pragma mark  密码输入结束后调用此方法

-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password {


    [_pview.TXView.TF resignFirstResponder];
    [_pview removeFromSuperview];

    NSLog(@"密码 = %@",Password);
    ZCWalletViewModel *vm = [ZCWalletViewModel new];


    [vm withdrawMoneyWithAmount:self.tfMoney.text WithPayPassword:Password callback:^(NSString *st) {

        if ([st isEqualToString:@"10042"]) {


            UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"提现失败" message:@"支付密码错误" delegate:self cancelButtonTitle:@"忘记密码" otherButtonTitles:@"重试", nil ];

            [customAlertView show];



        }else {

            UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:@"提现成功" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil ];
            customAlertView.tag = 11;

            [customAlertView show];

        }

        
    }];


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 11) {


        [[alertView textFieldAtIndex:buttonIndex]resignFirstResponder];

        [self performSelector:@selector(onBackAction) withObject:nil afterDelay:0.25];



    }else {

        if (buttonIndex == 0) {

            ZCSetPayPWDViewController *vc = [ZCSetPayPWDViewController new];
            vc.title = @"重置支付密码";

            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }


    }


}


@end
