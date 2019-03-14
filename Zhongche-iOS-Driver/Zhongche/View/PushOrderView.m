//
//  PushOrderView.m
//  Zhongche
//
//  Created by lxy on 16/8/9.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PushOrderView.h"

@interface PushOrderView()


@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;
@property (nonatomic, strong) UILabel     *lbLine;
@property (nonatomic, strong) UIImageView *ivStart;
@property (nonatomic, strong) UIImageView *ivEnd;
@property (nonatomic, strong) UILabel     *lbStart;
@property (nonatomic, strong) UILabel     *lbEnd;
@property (nonatomic, strong) UILabel     *lbTimeShow;
@property (nonatomic, strong) UILabel     *lbTime;
@property (nonatomic, strong) UILabel     *lbGoods;
@property (nonatomic, strong) UILabel     *lbSize;
@property (nonatomic, strong) UILabel     *lbDay;
@property (nonatomic, strong) UIButton    *btnBackground;
@property (nonatomic, strong) UILabel     *lbDistance;

@end

@implementation PushOrderView

//定义一个静态变量用于接收实例对象，初始化为nil
static PushOrderView *singleInstance=nil;


+(PushOrderView *)sharePushOrderView{
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

    self.btnBackground.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self addSubview:self.btnBackground];

    self.viShow.frame = CGRectMake(20, SCREEN_H/2 - 200, SCREEN_W - 40, 400);
    [self addSubview:self.viShow];


    self.lbType.frame = CGRectMake(0, 0, SCREEN_W - 40, 70);
    [self.viShow addSubview:self.lbType];

    self.lbTimeShow.frame = CGRectMake(10, self.lbType.bottom + 20, 80, 20);
    [self.viShow addSubview:self.lbTimeShow];


    if(SCREEN_W < 350){

        self.lbTime.frame = CGRectMake(self.lbTimeShow.right - 10, self.lbType.bottom + 20, 130, 20);
        [self.viShow addSubview:self.lbTime];

        self.lbDay.frame = CGRectMake(self.lbTime.right, self.lbType.bottom + 20, 60, 20);
        [self.viShow addSubview:self.lbDay];

    }else {

        self.lbTime.frame = CGRectMake(self.lbTimeShow.right, self.lbType.bottom + 20, SCREEN_W - 40 - self.lbTimeShow.right - 80, 20);
        [self.viShow addSubview:self.lbTime];

        self.lbDay.frame = CGRectMake(SCREEN_W - 40 - 70, self.lbType.bottom + 20, 60, 20);
        [self.viShow addSubview:self.lbDay];

    }



    self.btnCancle.frame = CGRectMake(SCREEN_W - 70, 10, 20, 20);
    [self.viShow addSubview:self.btnCancle];

    self.btnCancle1.frame = CGRectMake(SCREEN_W - 80, 20, 40, 40);
    [self.viShow addSubview:self.btnCancle1];


    self.lbLine.frame = CGRectMake(0, self.lbTime.bottom + 15, SCREEN_W - 40, 0.5);
    [self.viShow addSubview:self.lbLine];


    self.ivStart.frame = CGRectMake(20, self.lbLine.bottom + 15, 24, 28);
    [self.viShow addSubview:self.ivStart];

    self.lbStart.frame = CGRectMake(self.ivStart.right + 20, self.lbLine.bottom + 15, 200, 30);
    [self.viShow addSubview:self.lbStart];

    self.ivStyle.frame = CGRectMake(SCREEN_W - 120, self.lbTime.bottom + 35, 70, 55);
    [self.viShow addSubview:self.ivStyle];

    self.lbDistance.frame = CGRectMake(SCREEN_W - 120, self.ivStyle.bottom, 70, 20);
    [self.viShow addSubview:self.lbDistance];

    self.ivEnd.frame = CGRectMake(20, self.ivStart.bottom + 15, 24, 28);
    [self.viShow addSubview:self.ivEnd];

    self.lbEnd.frame = CGRectMake(self.ivEnd.right + 20, self.ivStart.bottom + 15, 200, 30);
    [self.viShow addSubview:self.lbEnd];

    UILabel *lbLine2 = [[UILabel alloc]initWithFrame:CGRectMake(20, self.lbEnd.bottom + 15, SCREEN_W - 60, 0.5)];
    lbLine2.backgroundColor = [UIColor lightGrayColor];
    [self.viShow addSubview:lbLine2];


    self.lbGoods.frame = CGRectMake(20, lbLine2.bottom + 10, SCREEN_W - 60, 20);
    [self.viShow addSubview:self.lbGoods];

    self.lbSize.frame = CGRectMake(20, self.lbGoods.bottom + 10, SCREEN_W - 60, 20);
    [self.viShow addSubview:self.lbSize];

    self.lbPrice.frame = CGRectMake(0, self.lbSize.bottom - 1, SCREEN_W - 60, 20);
    [self.viShow addSubview:self.lbPrice];


    self.btnOverLook.frame = CGRectMake(20, self.lbSize.bottom + 50, (SCREEN_W - 100)/2, 44);
    [self.viShow addSubview:self.btnOverLook];

    self.btnPlunder.frame = CGRectMake( self.btnOverLook.right + 20, self.lbSize.bottom + 50, (SCREEN_W - 100)/2, 44);
    [self.viShow addSubview:self.btnPlunder];
//
//





}

- (void)noAction {
    
}

- (void)removeAction {
    [self removeFromSuperview];
}

- (void)ViewWithModel:(PushModel *)model {
    if (model.type == 2) {
        
        [self.btnOverLook setTitle:@"忽略" forState:UIControlStateNormal];
        [self.btnPlunder setTitle:@"抢单" forState:UIControlStateNormal];
    }else {

        self.lbType.text = @"任务";

    }

    self.lbStart.text = model.start_region;
    self.lbEnd.text = model.end_region;


    //NSString转NSDate
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[model.startTime longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];

    self.lbTime.text = [outputFormatter stringFromDate:date];

    double daytime = ([model.endTime doubleValue] - [model.startTime doubleValue])/1000/60/60/24;
    if (daytime > (int)daytime) {
        daytime ++;
    }

    self.lbDay.text = [NSString stringWithFormat:@"%i天送达",(int)daytime];

    self.lbGoods.text = [NSString stringWithFormat:@"物品：%@",model.goods_name];
    self.lbSize.text  = [NSString stringWithFormat:@"箱型：%@",model.containerType];

    self.lbPrice.text = [NSString stringWithFormat:@"￥%i",model.price];


    if(model.distance>0){

        self.lbDistance.text = [NSString stringWithFormat:@"约%.0f公里",model.distance];

    }else {

        self.lbDistance.text = @"同城";

    }

}

- (void)setModel:(PushModel *)model {
    [self ViewWithModel:model];
    _model = model;
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

- (UIButton *)btnCancle {
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"cancle1"] forState:UIControlStateNormal];


        _btnCancle = button;
    }
    return _btnCancle;
}

- (UIButton *)btnCancle1 {
    if (!_btnCancle1) {
        UIButton *button = [[UIButton alloc]init];




        _btnCancle1 = button;
    }
    return _btnCancle1;
}

- (UIView *)viShow {

    if (!_viShow) {
        _viShow = [UIView new];
        _viShow.backgroundColor = [UIColor whiteColor];
        [_viShow.layer setMasksToBounds:YES];
        [_viShow.layer setCornerRadius:10.0];//设置矩形四个圆角半径
    }
    return _viShow;
}

- (UILabel *)lbLine {
    if (!_lbLine) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];

        _lbLine = label;
    }
    return _lbLine;
}

- (UIImageView *)ivStart {
    if (!_ivStart) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"startPoint"];
        _ivStart = imageView;
    }
    return _ivStart;
}

- (UIImageView *)ivEnd {
    if (!_ivEnd) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"endPoint"];

        _ivEnd = imageView;
    }
    return _ivEnd;
}

- (UILabel *)lbStart {
    if (!_lbStart) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"呼和浩特";


        _lbStart = label;
    }
    return _lbStart;
}

- (UILabel *)lbEnd {
    if (!_lbEnd) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"齐齐哈尔";

        _lbEnd = label;
    }
    return _lbEnd;
}

- (UILabel *)lbTimeShow {
    if (!_lbTimeShow) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:15.0f];
        }
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"出发日期:";

        _lbTimeShow = label;
    }
    return _lbTimeShow;
}

- (UILabel *)lbTime {
    if (!_lbTime) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0f];


        label.textColor = [UIColor grayColor];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:15.0f];
        }
        label.text = @"2016-05-06 10:10";

        _lbTime = label;
    }
    return _lbTime;
}

- (UILabel *)lbGoods {
    if (!_lbGoods) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:15.0f];
        }
        label.text = @"物品：仪器仪表";


        _lbGoods = label;
    }
    return _lbGoods;
}

- (UILabel *)lbSize {
    if (!_lbSize) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:15.0f];
        }
        label.text = @"箱型：20英尺集装箱";


        _lbSize = label;
    }
    return _lbSize;
}

- (UILabel *)lbType {
    if (!_lbType) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = APP_COLOR_PURPLE;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:23.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抢单";

        _lbType = label;
    }
    return _lbType;
}

- (UILabel *)lbDay {
    if (!_lbDay) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR2;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentLeft;
        label.layer.borderWidth = 1;
        label.layer.borderColor = APP_COLOR_ORANGR2.CGColor;
        [label.layer setMasksToBounds:YES];
        label.text = @"3天送达";
        [label.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        label.textAlignment = NSTextAlignmentCenter;


        _lbDay = label;
    }
    return _lbDay;
}

- (UIButton *)btnOverLook {
    if (!_btnOverLook) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _btnOverLook = button;
    }
    return _btnOverLook;
}

- (UIButton *)btnPlunder {
    if (!_btnPlunder) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"抢单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnPlunder = button;
    }
    return _btnPlunder;
}

- (UIButton *)btnBackground {
    if (!_btnBackground) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];



        _btnBackground = button;
    }
    return _btnBackground;
}

- (UIImageView *)ivStyle {
    if (!_ivStyle) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"qiangdan"];

        _ivStyle = imageView;
    }
    return _ivStyle;
}

- (UILabel *)lbPrice {
    if (!_lbPrice) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:17.0f];
        }
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"￥1000";


        _lbPrice = label;
    }
    return _lbPrice;
}

- (UILabel *)lbDistance {
    if (!_lbDistance) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:14.0f];
        }
        label.text = @"同城";
        label.textAlignment = NSTextAlignmentCenter;

        _lbDistance = label;
    }
    return _lbDistance;
}


@end
