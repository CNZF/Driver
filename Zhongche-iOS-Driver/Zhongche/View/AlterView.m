//
//  AlterView.m
//  Zhongche
//
//  Created by lxy on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "AlterView.h"

@implementation AlterView

-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{

    self.backgroundColor = [UIColor whiteColor];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:10.0];

    self.btnCentain.frame = CGRectMake(140, 140, 140, 60);
    [self addSubview:self.btnCentain];

    self.btnCancle.frame = CGRectMake(0, 140, 140, 60);
    [self addSubview:self.btnCancle];

    UILabel *lbLine1 = [UILabel new];
    lbLine1.frame = CGRectMake(0, 140, 280, 0.5);
    lbLine1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lbLine1];

    UILabel *lbLine2 = [UILabel new];
    lbLine2.frame = CGRectMake(140, 140, 0.5, 60);
    lbLine2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lbLine2];

}

- (UIButton *)btnCentain {
    if (!_btnCentain) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateNormal];

        _btnCentain = button;
    }
    return _btnCentain;
}

- (UIButton *)btnCancle {
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateNormal];



        _btnCancle = button;
    }
    return _btnCancle;
}


@end
