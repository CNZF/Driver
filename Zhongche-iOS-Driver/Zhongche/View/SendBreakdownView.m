//
//  SendBreakdownView.m
//  Zhongche
//
//  Created by lxy on 2016/10/27.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "SendBreakdownView.h"
#import "ZCTransportOrderModel.h"

@interface SendBreakdownView()

@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;

@property (nonatomic, strong) UIButton    *btnSelect1;
@property (nonatomic, strong) UIButton    *btnSelect2;
@property (nonatomic, strong) UIButton    *btnSelect3;





@end

@implementation SendBreakdownView




//定义一个静态变量用于接收实例对象，初始化为nil
static SendBreakdownView *singleInstance=nil;


+(SendBreakdownView *)sharePushOrderView{
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

    [self addSubview:self.viShow];

}

- (void)chooseAction:(UIButton *)btn {

    [self.btnSelect1 setImage:[UIImage imageNamed:@"btnSelect1"] forState:UIControlStateNormal];
    [self.btnSelect2 setImage:[UIImage imageNamed:@"btnSelect1"] forState:UIControlStateNormal];
    [self.btnSelect3 setImage:[UIImage imageNamed:@"btnSelect1"] forState:UIControlStateNormal];

    [btn setImage:[UIImage imageNamed:@"btnSelect2"] forState:UIControlStateNormal];

    self.index = (int)btn.tag;


}


/**
 *  getting
 */

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.backgroundColor = [UIColor blackColor];
        _viBackground.alpha = 0.3;
    }
    return _viBackground;
}

- (UIView *)viShow {

    if (!_viShow) {
        _viShow = [UIView new];
        _viShow.backgroundColor = [UIColor whiteColor];
        _viShow.frame = CGRectMake(30, SCREEN_H/2 - 125, SCREEN_W - 60, 250);
        UILabel *lb = [UILabel new];
        lb.text = @"故障情况";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.frame = CGRectMake(0,20 ,SCREEN_W - 60 , 20);
        lb.font = [UIFont systemFontOfSize:20];
        [_viShow addSubview:lb];

        UILabel *lb1 = [UILabel new];
        lb1.frame = CGRectMake(50,lb.bottom + 20 ,SCREEN_W - 90 , 20);
        lb1.font = [UIFont systemFontOfSize:18];
        lb1.textColor = [UIColor grayColor];
        lb1.text = @"严重故障,无法继续运输";
        [_viShow addSubview:lb1];

        self.btnSelect1 = [UIButton new];
        self.btnSelect1.tag = 0;
        [self.btnSelect1 setImage:[UIImage imageNamed:@"btnSelect1"] forState:UIControlStateNormal];
        self.btnSelect1.frame = CGRectMake(20, lb.bottom + 20, 20, 20);
        [_viShow addSubview:self.btnSelect1];

        UILabel *lb2 = [UILabel new];
        lb2.frame = CGRectMake(50,lb1.bottom + 20 ,SCREEN_W - 90 , 20);
        lb2.font = [UIFont systemFontOfSize:18];
        lb2.textColor = [UIColor grayColor];
        lb2.text = @"一般故障,但可能延误";
        [_viShow addSubview:lb2];

        self.btnSelect2 = [UIButton new];
        self.btnSelect2.tag = 1;
        [self.btnSelect2 setImage:[UIImage imageNamed:@"btnSelect1"] forState:UIControlStateNormal];
        self.btnSelect2.frame = CGRectMake(20, lb1.bottom + 20, 20, 20);
        [_viShow addSubview:self.btnSelect2];

        UILabel *lb3 = [UILabel new];
        lb3.frame = CGRectMake(50,lb2.bottom + 20 ,SCREEN_W - 90 , 20);
        lb3.font = [UIFont systemFontOfSize:18];
        lb3.textColor = [UIColor grayColor];
        lb3.text = @"一般故障,但能按时抵达";
        [_viShow addSubview:lb3];

        self.btnSelect3 = [UIButton new];
        self.btnSelect3.tag = 2;
        [self.btnSelect3 setImage:[UIImage imageNamed:@"btnSelect1"] forState:UIControlStateNormal];
        self.btnSelect3.frame = CGRectMake(20, lb2.bottom + 20, 20, 20);
        [_viShow addSubview:self.btnSelect3];


        [self.btnSelect1 addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnSelect2 addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnSelect3 addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];


        self.btnCertain = [UIButton new];
        [self.btnCertain setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnCertain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnCertain setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [self.btnCertain.layer setMasksToBounds:YES];
        [self.btnCertain.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        self.btnCertain.frame = CGRectMake(20, lb3.bottom + 20, SCREEN_W - 100, 44);
        [_viShow addSubview:self.btnCertain];



    }
    return _viShow;
}



@end
