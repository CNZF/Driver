//
//  ZCWalletViewController.m
//  Zhongche
//
//  Created by lxy on 2016/10/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCWalletViewController.h"
#import "ZCAllIncomeViewController.h"
#import "ZCTakeInViewController.h"
#import "ZCBankCardManagerViewController.h"
#import "ZCWalletViewModel.h"
#import "ZCWalletInfo.h"
#import "ZCMayBindCardViewController.h"
#import "ZCSetPayPWDViewController.h"
#import "ZCPaySetViewController.h"
#import "UserInfoModel.h"
#import "ZCWithdrawViewController.h"
#import "UserInfoViewModel.h"


@interface ZCWalletViewController ()
@property (nonatomic, strong) UIView                *viHead;
@property (nonatomic, strong) UILabel               *lbBalance;//余额字
@property (nonatomic, strong) UILabel               *lbRenminbi;//￥
@property (nonatomic, strong) UILabel               *lbNumber;
@property (nonatomic, strong) UIImageView           *ivArrowhead;//箭头
@property (nonatomic, strong) UIView                *vilan;
@property (nonatomic, strong) UIImageView           *ivMyBackCard;
@property (nonatomic, strong) UILabel               *lbMyBackCard;
@property (nonatomic, strong) UIView                *viPaySet;
@property (nonatomic, strong) UIImageView           *ivPaySet;
@property (nonatomic, strong) UILabel               *lbPaySet1;
@property (nonatomic, strong) UILabel               *lbPaySet2;
@property (nonatomic, strong) UILabel               *lbLine;
@property (nonatomic, strong) UIButton              *btnWithdrawCash;
@property (nonatomic, strong) UIButton              *btnHead;
@property (nonatomic, strong) UIButton              *btnPaySet;
@property (nonatomic, strong) UIButton              *btnMyBankCard;

@property (nonatomic, strong) UIView                *viMyBankCard;
@property (nonatomic, strong) UILabel               *lbMyBankCard1;

@property (nonatomic, strong) UILabel               *lbWaitForCenter;
@property (nonatomic, strong) UILabel               *lbWaitForCenterMoney;

@property (nonatomic, strong) UILabel               *lbAllIncome;
@property (nonatomic, strong) UILabel               *lbAllIncomeMoney;
@property (nonatomic, strong) ZCWalletInfo          *model;
@property (nonatomic, strong) UserInfoModel         *userModel;


@end

@implementation ZCWalletViewController

- (void)viewDidDisappear:(BOOL)animated
{
//    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
//    self.navigationController.navigationBar.hidden  = YES;
    
    [super viewWillAppear:animated];

    [self.view endEditing:YES];


    UserInfoViewModel *uvm = [UserInfoViewModel new];

    WS(ws);
    [uvm getUserInfoWithUserId:^(UserInfoModel *userInfo) {

        [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
        if ([userInfo.hasPayPassword isEqualToString:@"1"]) {
             ws.lbPaySet2.hidden = YES;
        }
        
    }];


    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    [vm getWalletInfocallback:^(ZCWalletInfo *info) {

        ws.model = info;

    }];

    self.userModel = USER_INFO;



}

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)bindView {
    self.title = @"钱包";

    self.btnRight.hidden = NO;
    [self.btnRight setTitle:@"收入明细" forState:UIControlStateNormal];
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 100, 30);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 150);
    [self.view addSubview:self.viHead];

    [self ViewHeadMake];

    self.vilan.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 60);
    [self.view addSubview:self.vilan];

    [self ViewLanMake];

    self.viMyBankCard.frame = CGRectMake(0, self.vilan.bottom + 20, SCREEN_W, 50);
    [self.view addSubview:self.viMyBankCard];

    self.btnMyBankCard.frame = CGRectMake(0, self.vilan.bottom + 20, SCREEN_W, 50);
    [self.view addSubview:self.btnMyBankCard];


    [self ViewMyBackCardMake];

    self.viPaySet.frame = CGRectMake(0, self.viMyBankCard.bottom + 20, SCREEN_W, 50);
    [self.view addSubview:self.viPaySet];

    self.btnPaySet.frame =  CGRectMake(0, self.viMyBankCard.bottom + 20, SCREEN_W, 50);
    [self.view addSubview:self.btnPaySet];

    [self ViewPaySetMake];

    self.btnWithdrawCash.frame = CGRectMake(0, SCREEN_H - 108-kiPhoneFooterHeight,SCREEN_W , 44);
    [self.view addSubview:self.btnWithdrawCash];
}

- (void)bindAction {

    WS(ws);


    [[self.btnMyBankCard rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        if([ws.userModel.hasPayPassword isEqualToString:@"1"]){
            if(ws.model.isBoundBank == 1) {

                [ws.navigationController pushViewController:[ZCMayBindCardViewController new] animated:YES];

            }else {

                [ws.navigationController pushViewController:[ZCBankCardManagerViewController new] animated:YES];
                
            }
            
        }else {

            [[Toast shareToast]makeText:@"请先设置支付密码" aDuration:1];
        }




    }];


    [[self.btnPaySet rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        if([ws.userModel.hasPayPassword isEqualToString:@"1"]){

            [ws.navigationController pushViewController:[ZCPaySetViewController new] animated:YES];


        }else {


            UserInfoModel *userInfo = USER_INFO;

            if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {

                //审核通过

                ZCSetPayPWDViewController *vc = [ZCSetPayPWDViewController new];
                vc.title = @"设置支付密码";
                [ws.navigationController pushViewController:vc animated:YES];

            }else {

                //正在审核

                [[Toast shareToast]makeText:@"请先通过审核认证" aDuration:1];
            }




        }



    }];



    [[self.btnWithdrawCash rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {



        if (ws.model.isBoundBank  == 1) {

            ZCWithdrawViewController *vc = [ZCWithdrawViewController new];
            vc.walletModel = self.model;
            [ws.navigationController pushViewController:vc animated:YES];
        }else {
            [[Toast shareToast]makeText:@"请先绑定银行卡" aDuration:1];
        }





    }];

}

- (void)bindModel {




    UserInfoModel *us = USER_INFO;

    WS(ws);
    [RACObserve(self, model) subscribeNext:^(id x) {

        ws.lbNumber.text = [NSString stringWithFormat:@"%.2f",ws.model.withdrawAccount];
        ws.lbAllIncomeMoney.text = [NSString stringWithFormat:@"￥%.2f",ws.model.generalIncome];
        ws.lbWaitForCenterMoney.text = [NSString stringWithFormat:@"￥%.2f",ws.model.waitConfirmedIncome];
        if([us.hasPayPassword isEqualToString:@"1"]){
            ws.lbPaySet2.hidden = YES;
        }

    }];
}

- (void)onRightAction {

    [self.navigationController pushViewController:[ZCTakeInViewController new] animated:YES];

}

//顶部视图
- (void) ViewHeadMake {
    
    self.lbBalance.frame = CGRectMake(10, 10, SCREEN_W - 10, 20);
    [self.viHead addSubview:self.lbBalance];

    self.lbRenminbi.frame  = CGRectMake(10, self.lbBalance.bottom + 30, SCREEN_W - 10, 20);
    [self.viHead addSubview:self.lbRenminbi];

    self.lbNumber.frame = CGRectMake( 40, self.lbBalance.bottom + 35, SCREEN_W - 40, 40);
    [self.viHead addSubview:self.lbNumber];

//    UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 150)];
//    view.image = [UIImage imageNamed:@"money_bg"];
//    [self.viHead addSubview:view];

    
     self.btnHead.frame = CGRectMake(0, 0, SCREEN_W, 150);
    [self.btnHead setBackgroundColor:[UIColor clearColor]];
    [self.btnHead setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.viHead addSubview:self.btnHead];
    
}

//金额视图
- (void) ViewLanMake {

    [self.vilan addSubview:self.lbAllIncome];
    [self.vilan addSubview: self.lbAllIncomeMoney];

    [self.vilan addSubview: self.lbWaitForCenterMoney];
    [self.vilan addSubview: self.lbWaitForCenter];

    [self.vilan addSubview:self.lbLine];
}

//银行卡
- (void) ViewMyBackCardMake {

    [self.viMyBankCard addSubview:self.ivMyBackCard];

    [self.viMyBankCard addSubview:self.lbMyBankCard1];


}

//重置支付密码
- (void) ViewPaySetMake {


    [self.viPaySet addSubview:self.ivPaySet];

    [self.viPaySet addSubview:self.lbPaySet1];

    [self.viPaySet addSubview: self.lbPaySet2];

}

/**
 *  getter
 */

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        
//        _viHead.backgroundColor  = APP_COLOR_PURPLE1;

    }
    return _viHead;
}

- (UILabel *)lbBalance {
    
    if (!_lbBalance) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.text = @"可提现";

        _lbBalance = label;
    }
    return _lbBalance;
}

- (UILabel *)lbRenminbi {
    if (!_lbRenminbi) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR;
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"￥";

        _lbRenminbi = label;
    }
    return _lbRenminbi;
}

- (UILabel *)lbNumber {
    if (!_lbNumber) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:45.0f];
        label.text = @"8796.00";

        _lbNumber = label;
    }
    return _lbNumber;
}

- (UIImageView *)ivArrowhead {
    if (!_ivArrowhead) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"jiantou"];

        _ivArrowhead = imageView;
    }
    return _ivArrowhead;
}

- (UIView *)vilan {
    if (!_vilan) {
        _vilan = [UIView new];
        _vilan.backgroundColor = [UIColor whiteColor];

    }
    return _vilan;
}

- (UIImageView *)ivMyBackCard {
    if (!_ivMyBackCard) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"Slice"];
        imageView.frame = CGRectMake(20, 15, 20, 20);

        _ivMyBackCard = imageView;
    }
    return _ivMyBackCard;
}

- (UILabel *)lbAllIncome {
    if (!_lbAllIncome) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"总收入";
        label.frame = CGRectMake(20, 20, 100, 20);


        _lbAllIncome = label;
    }
    return _lbAllIncome;
}

- (UILabel *)lbAllIncomeMoney {
    if (!_lbAllIncomeMoney) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"80000.00";
        label.frame = CGRectMake(70, 20, 100, 20);

        _lbAllIncomeMoney = label;
    }
    return _lbAllIncomeMoney;
}

- (UILabel *)lbWaitForCenter {
    if (!_lbWaitForCenter) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"待确认";
        label.frame = CGRectMake(SCREEN_W/2 + 20, 20, 100, 20);

        _lbWaitForCenter = label;
    }
    return _lbWaitForCenter;
}

- (UILabel *)lbWaitForCenterMoney {
    if (!_lbWaitForCenterMoney) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"20000.00";
        label.frame = CGRectMake(SCREEN_W/2 + 70, 20, 100, 20);

        _lbWaitForCenterMoney = label;
    }
    return _lbWaitForCenterMoney;
}

- (UIView *) viPaySet {
    if (!_viPaySet) {
        _viPaySet = [UIView new];
        _viPaySet.backgroundColor = [UIColor whiteColor];
        UIImageView *ivJiantou = [UIImageView new];
        ivJiantou.image = [UIImage imageNamed:@"grayjiantou.jpg"];
        ivJiantou.frame = CGRectMake(SCREEN_W - 30, 19, 12, 12);
        [_viPaySet addSubview:ivJiantou];


    }
    return _viPaySet;
}

- (UIImageView *)ivPaySet {
    if (!_ivPaySet) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"setPay"];
        imageView.frame = CGRectMake(20, 15, 20, 20);

        _ivPaySet = imageView;
    }
    return _ivPaySet;
}

- (UILabel *)lbPaySet1 {
    if (!_lbPaySet1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"支付设置";
        label.frame = CGRectMake(self.ivPaySet.right + 20, 15, 100, 20);



        _lbPaySet1 = label;
    }
    return _lbPaySet1;
}

- (UILabel *)lbPaySet2 {
    if (!_lbPaySet2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"请设置支付密码";
        label.frame = CGRectMake(SCREEN_W - 180, 15, 140, 20);
        label.textAlignment = NSTextAlignmentRight;

        _lbPaySet2 = label;
    }
    return _lbPaySet2;
}


- (UILabel *)lbLine {
    if (!_lbLine) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.frame = CGRectMake(SCREEN_W/2, 10,  0.5, 40);

        _lbLine = label;
    }
    return _lbLine;
}


- (UIButton *)btnWithdrawCash {
    if (!_btnWithdrawCash) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提现" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];


        _btnWithdrawCash = button;
    }
    return _btnWithdrawCash;
}

- (UIButton *)btnHead {

    if (!_btnHead) {
        UIButton *button = [[UIButton alloc]init];


        _btnHead = button;
    }
    return _btnHead;
}

- (UIView *)viMyBankCard {

    if (!_viMyBankCard) {
        _viMyBankCard = [UIView new];
        _viMyBankCard.backgroundColor = [UIColor whiteColor];
        UIImageView *ivJiantou = [UIImageView new];
        ivJiantou.image = [UIImage imageNamed:@"grayjiantou.jpg"];
        ivJiantou.frame = CGRectMake(SCREEN_W - 30, 19, 12, 12);
        [_viMyBankCard addSubview:ivJiantou];


    }
    return _viMyBankCard;
}

- (UILabel *)lbMyBankCard1 {
    if (!_lbMyBankCard1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"我的银行卡";
        label.frame = CGRectMake(self.ivMyBackCard.right + 20, 15, 100, 20);

        _lbMyBankCard1 = label;
    }
    return _lbMyBankCard1;
}

- (UIButton *)btnMyBankCard {
    if (!_btnMyBankCard) {
        UIButton *button = [[UIButton alloc]init];


        _btnMyBankCard = button;
    }
    return _btnMyBankCard;
}

- (UIButton *)btnPaySet {
    if (!_btnPaySet) {
        UIButton *button = [[UIButton alloc]init];


        _btnPaySet = button;
    }
    return _btnPaySet;
}




@end
