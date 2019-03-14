//
//  EvaluateResultView.m
//  Zhongche
//
//  Created by lxy on 16/8/10.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "EvaluateResultView.h"


@interface EvaluateResultView()


@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;
@property (nonatomic, strong) UILabel     *lbTop;
@property (nonatomic, strong) UILabel     *lbLine;
@property (nonatomic, strong) UIButton    *btnBackground;
@property (nonatomic, strong) UILabel     *lbMoney;
@property (nonatomic, strong) UIImageView *ivPrice;
@property (nonatomic, strong) UILabel     *lbPrice;
@property (nonatomic, strong) UIImageView *ivReward;
@property (nonatomic, strong) UILabel     *lbReward;
@property (nonatomic, strong) UILabel     *lbTime;
@property (nonatomic, strong) UILabel     *lbLine1;
@property (nonatomic, strong) UILabel     *lbLine2;


@end

@implementation EvaluateResultView

- (void)binView {

    self.viBackground.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self addSubview:self.viBackground];

    self.btnBackground.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self addSubview:self.btnBackground];

    self.viShow.frame = CGRectMake(SCREEN_W/2 - 140, SCREEN_H/2 - 200, 280, 400);
    [self addSubview:self.viShow];

    self.lbTop.frame = CGRectMake(0, 20, 280, 40);
    [self.viShow addSubview:self.lbTop];

    self.btnCancle.frame = CGRectMake(250, 10, 25, 25);
    [self.viShow addSubview:self.btnCancle];

    self.lbLine.frame = CGRectMake(0, self.lbTop.bottom + 20, 280, 0.5);
    [self.viShow addSubview:self.lbLine];

    self.lbMoney.frame = CGRectMake(0, self.lbLine.bottom + 30, 280, 30);
    [self.viShow addSubview:self.lbMoney];

    self.ivPrice.frame = CGRectMake(50, self.lbMoney.bottom + 30, 20, 20);
    [self.viShow addSubview:self.ivPrice];

    self.lbPrice.frame = CGRectMake(self.ivPrice.right + 10, self.lbMoney.bottom + 30, 200, 20);
    [self.viShow addSubview:self.lbPrice];

    self.ivReward.frame = CGRectMake(50, self.lbPrice.bottom + 30, 20, 20);
    [self.viShow addSubview:self.ivReward];

    self.lbReward.frame = CGRectMake(self.ivReward.right + 10, self.lbPrice.bottom + 30, 200, 20);
    [self.viShow addSubview:self.lbReward];

    self.lbTime.frame = CGRectMake(0, self.lbReward.bottom + 30, 280, 20);
    [self.viShow addSubview:self.lbTime];


    self.lbLine1.frame = CGRectMake(0, 340, 280, 0.5);
    [self.viShow addSubview:self.lbLine1];

    self.lbLine2.frame = CGRectMake(140, self.lbLine1.bottom, 0.5, 60);
    [self.viShow addSubview:self.lbLine2];

    self.btnGiveUp.frame = CGRectMake(0, self.lbLine1.bottom, 140, 60);
    [self.viShow addSubview:self.btnGiveUp];

    self.btnAgree.frame = CGRectMake(self.btnGiveUp.right, self.lbLine1.bottom, 140, 60);
    [self.viShow addSubview:self.btnAgree];

}


- (void)removeAction {
    [self removeFromSuperview];
}

- (void)noAction {

}


- (void)ViewWithModel:(PushEvaluateModel *)model{

    self.lbMoney.text = [NSString stringWithFormat:@"￥%i",model.awardPrice + model.standardPrice];
    self.lbPrice.text = [NSString stringWithFormat:@"标准估价%i元",model.standardPrice];
    self.lbReward.text = [NSString stringWithFormat:@"星级奖励%i元",model.awardPrice];

    //设置转换格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //NSString转NSDate
    NSDate *endTimeDate=[formatter dateFromString:model.dispatchEndTime];
    NSDateFormatter *formattershow=[[NSDateFormatter alloc]init];
    [formattershow setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *strDate = [formattershow stringFromDate:endTimeDate];

    NSString *text = [NSString stringWithFormat:@"报价至 %@ 前有效" ,strDate ];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];

    NSRange range = [text rangeOfString:strDate];


    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor blackColor]
                          range:range];

    self.lbTime.attributedText = attributedStr;
}
-(void)setModel:(PushEvaluateModel *)model
{
    [self ViewWithModel:model];
    _model = model;
}
/**
 *  getting
 *
 *  @return <#return value description#>
 */

- (UIView *)viBackground
{
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.backgroundColor = [UIColor blackColor];
        _viBackground.alpha = 0.3;
    }
    return _viBackground;
}

- (UIButton *)btnCancle
{
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"1-2系统任务_03"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];

        _btnCancle = button;
    }
    return _btnCancle;
}


- (UIView *)viShow
{
    if (!_viShow) {
        _viShow = [UIView new];
        _viShow.backgroundColor = [UIColor whiteColor];
        [_viShow.layer setMasksToBounds:YES];
        [_viShow.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    }
    return _viShow;
}

- (UILabel *)lbTop
{
    if (!_lbTop) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        label.text = @"评估结果";
        label.textAlignment = NSTextAlignmentCenter;

        _lbTop = label;
    }
    return _lbTop;
}

- (UILabel *)lbLine
{
    if (!_lbLine) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];

        _lbLine = label;
    }
    return _lbLine;
}

- (UILabel *)lbLine1
{
    if (!_lbLine1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];

        _lbLine1 = label;
    }
    return _lbLine1;
}

- (UILabel *)lbLine2
{
    if (!_lbLine2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];

        _lbLine2 = label;
    }
    return _lbLine2;
}

- (UIButton *)btnBackground
{
    if (!_btnBackground) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];



        _btnBackground = button;
    }
    return _btnBackground;
}

- (UILabel *)lbMoney
{
    if (!_lbMoney) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:32.0f];
        label.text = @"￥3800";
        label.textAlignment = NSTextAlignmentCenter;

        _lbMoney = label;
    }
    return _lbMoney;
}

- (UIImageView *)ivPrice
{
    if (!_ivPrice) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"标准估价蓝色"];

        _ivPrice = imageView;
    }
    return _ivPrice;
}

- (UILabel *)lbPrice
{
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"标准估价3600元";

        _lbPrice = label;
    }
    return _lbPrice;
}

- (UIImageView *)ivReward
{
    if (!_ivReward) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"星级橙色"];


        _ivReward = imageView;
    }
    return _ivReward;
}

- (UILabel *)lbReward
{
    if (!_lbReward) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"星级奖励200元";

        _lbReward = label;
    }
    return _lbReward;
}

- (UILabel *)lbTime
{
    if (!_lbTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;

        NSString *stDay = @"2016-04-26 17:23";
        NSString *text = [NSString stringWithFormat:@"报价至 %@ 前有效" ,stDay ];

        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];

        NSRange range = [text rangeOfString:stDay];


        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor blackColor]
                              range:range];

        label.attributedText = attributedStr;

        _lbTime = label;
    }
    return _lbTime;
}

- (UIButton *)btnGiveUp
{
    if (!_btnGiveUp) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"放弃" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        _btnGiveUp = button;
    }
    return _btnGiveUp;
}

- (UIButton *)btnAgree
{
    if (!_btnAgree) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"同意" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateNormal];

        _btnAgree = button;
    }
    return _btnAgree;
}



@end
