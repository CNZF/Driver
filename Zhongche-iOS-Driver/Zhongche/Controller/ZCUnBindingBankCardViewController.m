//
//  ZCUnBindingBankCardViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/7.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCUnBindingBankCardViewController.h"
#import "TXTradePasswordView.h"
#import "ZCWalletViewModel.h"
#import "ZCWalletViewController.h"
#import "KeyboardToolBar.h"
#import "ZCBindBankCardViewController.h"

@interface ZCUnBindingBankCardViewController ()<TXTradePasswordViewDelegate>

@property (nonatomic, strong) UIButton            *btn;

@property (nonatomic, strong) TXTradePasswordView *TXView;

@end

@implementation ZCUnBindingBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 为UITextField移除KeyboardToolBar


}

- (void)bindView {

    self.title = @"输入支付密码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(20, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
    _TXView.TXTradePasswordDelegate = self;
    if (![_TXView.TF becomeFirstResponder]) {
        //成为第一响应者。弹出键盘
        [_TXView.TF becomeFirstResponder];
    }


    [KeyboardToolBar unregisterKeyboardToolBarWithTextField:_TXView.TF];
    
    [self.view addSubview:_TXView];

    self.btn.frame = CGRectMake(20, 100,SCREEN_WIDTH, 200);
    [self.view addSubview:self.btn];

}

//获取焦点
- (void)clickAction {


     [_TXView.TF becomeFirstResponder];

}

#pragma mark  密码输入结束后调用此方法

-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password {
    NSLog(@"密码 = %@",Password);
    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    WS(ws);

    if (self.style == 1) {

        [vm checkWithPWD:Password callback:^(NSString *st) {

            //[ZCBindBankCardViewController new]

            if([st isEqualToString:@"10000"]){



                [ws.navigationController pushViewController:[ZCBindBankCardViewController new] animated:YES];

            }else {
                
                [view clearAction];
            }


        }];

    }else {

        [vm unBindingBankCardWithPWD:Password callback:^(NSString *st) {

            if([st isEqualToString:@"10000"]){

                [[Toast shareToast]makeText:@"解绑成功" aDuration:1];

                [ws.navigationController popToViewControllerWithClassName:@"ZCWalletViewController" animated:YES];

            }else {
                
                [view clearAction];
            }
            
            
            
            
        }];

    }



}

- (UIButton *)btn {
    if (!_btn) {
        UIButton *button = [[UIButton alloc]init];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];

        _btn = button;
    }
    return _btn;
}


@end
