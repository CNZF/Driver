//
//  ZCMayBindCardViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/1.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCMayBindCardViewController.h"
#import "ZCWalletViewModel.h"
#import "ZCBankCardMessageInfo.h"
#import "ZCBindBankCardViewController.h"
#import "ZCUnBindingBankCardViewController.h"
#import "PayPWDView.h"
#import "TXTradePasswordView.h"

@interface ZCMayBindCardViewController ()<TXTradePasswordViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) ZCBankCardMessageInfo *model;
@property (nonatomic, strong) PayPWDView *pview;

@end

@implementation ZCMayBindCardViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    WS(ws);
    [vm getgetBindingBankCardcallback:^(ZCBankCardMessageInfo *info) {

        ws.model = info;

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindView {

    self.title = @"我的银行卡";


    [self.btnChangeBankCard setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
    [self.btnChangeBankCard.layer setMasksToBounds:YES];
    [self.btnChangeBankCard.layer setCornerRadius:5.0];//设置矩形四个圆角半径

    self.btnRight.hidden = NO;
    [self.btnRight setTitle:@"管理" forState:UIControlStateNormal];
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 60, 30);

}

- (void)bindModel {



    WS(ws);

    [RACObserve(self, model) subscribeNext:^(id x) {

        ws.lbBankName.text = ws.model.bankCardNanme;
        ws.lbUserName.text = [NSString stringWithFormat:@"持卡人:%@",ws.model.userName];

        if (ws.model.bankCardNum.length >4) {
            ws.lbBankNum.text = [ws.model.bankCardNum substringFromIndex:(ws.model.bankCardNum.length -4)];


        }

        
    }];
}

- (void)onRightAction {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解绑", nil];
    [actionSheet showInView:self.view];
}

- (void)onBackAction {

    [self.navigationController popToViewControllerWithClassName:@"ZCWalletViewController" animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //按照按钮的顺序0-N；
    switch (buttonIndex) {
        case 0:

            [self.navigationController pushViewController:[ZCUnBindingBankCardViewController new] animated:YES];
            break;


        default:
            break;
    }
    
}


-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password {

    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    WS(ws);
    [vm checkWithPWD:Password callback:^(NSString *st) {

        if([st isEqualToString:@"10000"]){

            [_pview removeFromSuperview];

           [ws.navigationController pushViewController:[ZCBindBankCardViewController new] animated:YES];

        }else {

            [view clearAction];
        }


    }];

   

}

//更改银行卡号
- (IBAction)changeBankCardAction:(id)sender {


    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    _pview= [PayPWDView sharePushOrderView];
    [_pview.TXView.TF becomeFirstResponder];
    _pview.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    _pview.TXView.TXTradePasswordDelegate = self;
    _pview.lbMoney.text = @"更改银行卡需要输入支付密码";
    _pview.lbMoney.font = [UIFont systemFontOfSize:14];
    _pview.lbTixian.text = @"";
    [window addSubview:_pview];

}




@end
