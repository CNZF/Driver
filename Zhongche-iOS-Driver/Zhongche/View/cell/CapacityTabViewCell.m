//
//  CapacityTabViewCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "CapacityTabViewCell.h"

@interface CapacityTabViewCell()
@property (nonatomic, strong) UIView * headLine;
@property (nonatomic, strong) UIImageView * typeImg;
@property (nonatomic, strong) UILabel * typeLab;
@property (nonatomic, strong) UILabel * detailsLab;
@property (nonatomic, strong) UILabel * moneyLab;
@property (nonatomic, strong) UILabel * stateLab;
@end
@implementation CapacityTabViewCell

- (void)loadUIWithmodel:(CapacityModel *)model
{
    if (model.type == 1)
    {
        self.typeImg.image = [UIImage imageNamed:@"按时间"];
        self.typeLab.text = @"按时间段";
        self.detailsLab.text = [NSString stringWithFormat:@"%@至%@",[model.dispatch_start_time componentsSeparatedByString:@" "][0],[model.dispatch_end_time componentsSeparatedByString:@" "][0]];
    }
    else if(model.type == 2)
    {
        self.typeImg.image = [UIImage imageNamed:@"按线路"];
        self.typeLab.text = @"按线路";
        self.detailsLab.text = [NSString stringWithFormat:@"%@-%@",model.start_position_name,model.end_position_name];
    }
    if (model.standard_price) {
        self.moneyLab.text = [NSString stringWithFormat:@"¥%d",model.standard_price + model.award_price];
    }
    else
    {
        self.moneyLab.text = @"---";
    }
    switch (model.status) {
        case 1:
            self.stateLab.text = @"待评估";
            break;
        case 2:
            self.stateLab.text = @"待确认";
            break;
        case 3:
            self.stateLab.text = @"未派单";
            break;
        case 4:
            self.stateLab.text = @"已派单";
            break;
        case 5:
            self.stateLab.text = @"待结算";
            break;
        case 6:
            self.stateLab.text = @"已结算";
            break;
        default:
            self.stateLab.text = @"未成交";
            break;
    }
}
- (void)bindView
{
    self.headLine.frame = CGRectMake(0, 0, SCREEN_W, 3);
    [self addSubview:self.headLine];
    
    self.typeImg.frame = CGRectMake(10, CGRectGetMaxY(self.headLine.frame) + 10, 20, 20);
    [self addSubview:self.typeImg];
    
    self.typeLab.frame = CGRectMake(CGRectGetMaxX(self.typeImg.frame) + 5, CGRectGetMinY(self.typeImg.frame), SCREEN_W * 0.5, 30);
    [self addSubview:self.typeLab];
    
    self.detailsLab.frame = CGRectMake(CGRectGetMinX(self.typeImg.frame), CGRectGetMaxY(self.typeLab.frame) + 10, SCREEN_W * 0.7, 30);
    [self addSubview:self.detailsLab];
    
    self.moneyLab.frame = CGRectMake(SCREEN_W * 0.5, 25, SCREEN_W * 0.25, 40);
    [self addSubview:self.moneyLab];
    
    self.stateLab.frame = CGRectMake(SCREEN_W - 10 - 100, 30, 100, 30);
    [self addSubview:self.stateLab];
}

- (UIView *)headLine
{
    if (!_headLine) {
        _headLine = [UIView new];
        _headLine.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _headLine;
}
- (UIImageView *)typeImg
{
    if (!_typeImg) {
        UIImageView *imageView = [[UIImageView alloc]init];
        _typeImg = imageView;
    }
    return _typeImg;
}
- (UILabel *)typeLab
{
    if (!_typeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        _typeLab = label;
    }
    return _typeLab;
}
- (UILabel *)detailsLab
{
    if (!_detailsLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:18.0f];
        _detailsLab = label;
    }
    return _detailsLab;
}
- (UILabel *)moneyLab
{
    if (!_moneyLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR;
        label.font = [UIFont systemFontOfSize:24.0f];
        _moneyLab = label;
    }
    return _moneyLab;
}
- (UILabel *)stateLab
{
    if (!_stateLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:18.0f];
        _stateLab = label;
    }
    return _stateLab;
}


@end
