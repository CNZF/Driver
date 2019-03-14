//
//  PayPWDView.m
//  Zhongche
//
//  Created by lxy on 2016/11/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PayPWDView.h"

#import "KeyboardToolBar.h"


@interface PayPWDView()

@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;
@property (nonatomic, strong) UIImageView *ivClose;
@property (nonatomic, strong) UIButton    *btnCancle;
@property (nonatomic, strong) UILabel     *lbTitle;
@property (nonatomic, strong) UIView      *viLine;



@end

@implementation PayPWDView


//定义一个静态变量用于接收实例对象，初始化为nil
static PayPWDView *singleInstance=nil;


+(PayPWDView *)sharePushOrderView{
    @synchronized(self){//线程保护，增加同步锁
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

- (void)binView {

    self.viBackground.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self addSubview:self.viBackground];

    self.viShow.frame = CGRectMake(20, SCREEN_H/2 - 160, SCREEN_W - 40, 200);
    [self addSubview:self.viShow];

    self.ivClose.frame = CGRectMake(10, 10, 20, 20);
    [self.viShow addSubview:self.ivClose];

    self.btnCancle.frame = CGRectMake(0, 0, 40, 40);
    [self.viShow addSubview:self.btnCancle];

    self.lbTitle.frame = CGRectMake(0, 20, SCREEN_W - 40, 20 );
    [self.viShow addSubview:self.lbTitle];

    self.viLine.frame = CGRectMake(0, self.lbTitle.bottom + 10, SCREEN_W - 40, 0.5);
    [self.viShow addSubview:self.viLine];

    self.lbTixian.frame = CGRectMake(0, self.viLine.bottom + 10, SCREEN_W - 40, 20);
    [self.viShow addSubview:self.lbTixian];

    self.lbMoney.frame = CGRectMake(0, self.lbTixian.bottom + 10, SCREEN_W - 40, 20);
    [self.viShow addSubview:self.lbMoney];


    self.TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, self.lbMoney.bottom - 20 ,SCREEN_WIDTH -  40, 40) WithTitle:@""];
        if (![self.TXView.TF becomeFirstResponder]) {
        //成为第一响应者。弹出键盘
        [self.TXView.TF becomeFirstResponder];
    }


    [KeyboardToolBar unregisterKeyboardToolBarWithTextField:self.TXView.TF];

    [self.viShow addSubview:self.TXView];





}


- (void)cancleAction {

    [self removeFromSuperview];
}

/**
 *  getting
 */

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.backgroundColor = [UIColor blackColor];
        _viBackground.alpha = 0.7;
    }
    return _viBackground;
}

- (UIView *)viShow {

    if (!_viShow) {
        _viShow = [UIView new];
        _viShow.backgroundColor = APP_COLOR_ALERTE;
        [_viShow.layer setMasksToBounds:YES];
        [_viShow.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    }
    return _viShow;
}

- (UIImageView *)ivClose {
    if (!_ivClose) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"Close"];

        _ivClose = imageView;
    }
    return _ivClose;
}

- (UIButton *)btnCancle
{
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];



        _btnCancle = button;
    }
    return _btnCancle;
}

- (UILabel *)lbTitle
{
    if (!_lbTitle) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"请输入支付密码";
        label.textAlignment = NSTextAlignmentCenter;

        _lbTitle = label;
    }
    return _lbTitle;
}

- (UIView *)viLine {
    if (!_viLine) {
        _viLine = [UIView new];
        _viLine.backgroundColor = [UIColor grayColor];
    }
    return _viLine;
}

- (UILabel *)lbTixian {
    if (!_lbTixian) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"提现";
        label.textAlignment = NSTextAlignmentCenter;

        _lbTixian = label;
    }
    return _lbTixian;
}

- (UILabel *)lbMoney {
    if (!_lbMoney) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:24.0f];
        label.text = @"￥2000.00";
        label.textAlignment = NSTextAlignmentCenter;



        _lbMoney = label;
    }
    return _lbMoney;
}


@end
