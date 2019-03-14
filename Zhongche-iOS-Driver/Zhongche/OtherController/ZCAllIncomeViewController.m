//
//  ZCAllIncomeViewController.m
//  Zhongche
//
//  Created by lxy on 2016/10/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCAllIncomeViewController.h"

@interface ZCAllIncomeViewController ()
@property (nonatomic, strong) UIView      *viHead;
@property (nonatomic, strong) UILabel     *lbBalance;//余额字
@property (nonatomic, strong) UILabel     *lbRenminbi;//￥
@property (nonatomic, strong) UILabel     *lbNumber;
@property (nonatomic, strong) UIView      *vi1;
@property (nonatomic, strong) UIView      *vi2;
@property (nonatomic, strong) UILabel     *lbPrice1;
@property (nonatomic, strong) UILabel     *lbPrice2;
@property (nonatomic, strong) UIButton    *btnWithdrawCash;

@end

@implementation ZCAllIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)bindView {
    self.title = @"钱包";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 150);;
    [self.view addSubview:self.viHead];
    [self ViewHeadMake];

    [self.view addSubview:self.vi1];
    [self.view addSubview:self.vi2];

    self.btnWithdrawCash.frame = CGRectMake(20, SCREEN_H - 144,SCREEN_W - 40 , 44);
    [self.view addSubview:self.btnWithdrawCash];
}

//顶部视图
- (void) ViewHeadMake {

    self.lbBalance.frame = CGRectMake(10, 10, SCREEN_W - 10, 20);
    [self.viHead addSubview:self.lbBalance];

    self.lbRenminbi.frame  = CGRectMake(10, self.lbBalance.bottom + 30, SCREEN_W - 10, 20);
    [self.viHead addSubview:self.lbRenminbi];

    self.lbNumber.frame = CGRectMake( 40, self.lbBalance.bottom + 35, SCREEN_W - 40, 40);
    [self.viHead addSubview:self.lbNumber];

    
}


/**
 *  getter
 */

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor  = APP_COLOR_PURPLE1;

    }
    return _viHead;
}

- (UILabel *)lbBalance {
    if (!_lbBalance) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT1;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.text = @"总收入（元）";

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
        label.text = @"18796.00";

        _lbNumber = label;
    }
    return _lbNumber;
}

- (UIView *)vi1 {
    if (!_vi1) {
        _vi1 = [UIView new];
        _vi1.backgroundColor = [UIColor whiteColor];
        _vi1.frame = CGRectMake(0, self.viHead.bottom, SCREEN_W, 85);
        UILabel *lb1 = [UILabel new];
        lb1.text = @"待结算（元）";
        lb1.frame = CGRectMake(20, 15, 120, 20);
        lb1.textAlignment = NSTextAlignmentLeft;
        lb1.font = [UIFont systemFontOfSize:17];
        lb1.textColor = [UIColor lightGrayColor];
        [_vi1 addSubview:lb1];

        _lbPrice1 = [UILabel new];
        _lbPrice1.text = @"796.00";
        _lbPrice1.frame = CGRectMake(20, 45, 200, 30);
        _lbPrice1.textAlignment = NSTextAlignmentLeft;
        _lbPrice1.font = [UIFont systemFontOfSize:30];
        _lbPrice1.textColor = [UIColor blackColor];
        [_vi1 addSubview:_lbPrice1];

        UIImageView *ivJiantou = [UIImageView new];
        ivJiantou.image = [UIImage imageNamed:@"grayjiantou.jpg"];
        ivJiantou.frame = CGRectMake(SCREEN_W - 30, 35, 20, 20);
        [_vi1 addSubview:ivJiantou];


    }
    return _vi1;
}

- (UIView *)vi2 {
    if (!_vi2) {
        _vi2 = [UIView new];
        _vi2.backgroundColor = [UIColor whiteColor];
        _vi2.frame = CGRectMake(0, self.vi1.bottom + 1, SCREEN_W, 85);
        UILabel *lb2 = [UILabel new];
        lb2.text = @"可提现（元）";
        lb2.frame = CGRectMake(20, 15, 120, 20);
        lb2.textAlignment = NSTextAlignmentLeft;
        lb2.font = [UIFont systemFontOfSize:17];
        lb2.textColor = [UIColor lightGrayColor];
        [_vi2 addSubview:lb2];

        _lbPrice2 = [UILabel new];
        _lbPrice2.text = @"8796.00";
        _lbPrice2.frame = CGRectMake(20, 45, 200, 30);
        _lbPrice2.textAlignment = NSTextAlignmentLeft;
        _lbPrice2.font = [UIFont systemFontOfSize:30];
        _lbPrice2.textColor = [UIColor blackColor];
        [_vi2 addSubview:_lbPrice2];
    }
    return _vi2;
}

- (UIButton *)btnWithdrawCash
{
    if (!_btnWithdrawCash) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提现" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径


        _btnWithdrawCash = button;
    }
    return _btnWithdrawCash;
}


@end
