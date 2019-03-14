//
//  OrderTabViewCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "OrderTabViewCell.h"

@interface OrderTabViewCell()
@property (nonatomic, strong) UIView * headLine;
@property (nonatomic, strong) UIImageView * startImg;
@property (nonatomic, strong) UILabel * startLab;
@property (nonatomic, strong) UIImageView * arrowImg;
@property (nonatomic, strong) UILabel * timeUseLab;
@property (nonatomic, strong) UIImageView * endImg;
@property (nonatomic, strong) UILabel * endLab;
@property (nonatomic, strong) UILabel * timeStartLab;
@property (nonatomic, strong) UILabel * moneyLab;
@property (nonatomic, strong) UILabel * taskLab;
@property (nonatomic, strong) UILabel * typeLab;
@end
@implementation OrderTabViewCell
- (void)loadUIWithmodel:(ZCTransportOrderModel *)model
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.startLab.text = model.start_region_name;
    self.timeUseLab.text = [NSString stringWithFormat:@"%d天",(int)(([[dateFormatter dateFromString:model.endTime] timeIntervalSinceDate:[dateFormatter dateFromString:model.startTime]]) / 3600 /24) + 1];
    self.endLab.text = model.end_region_name;
    self.timeStartLab.text = model.startTime;
    self.endLab.text = model.end_region_name;
    switch (model.status) {
        case 0:
            self.typeLab.text = @"未装载";
            break;
        case 1:
            self.typeLab.text = @"在途";
            break;
        case 2:
            self.typeLab.text = @"待结算";
            break;
        case 3:
            self.typeLab.text = @"已完成";
            break;
        default:
            break;
    }
    if (model.type == 1)
    {
        self.taskLab.hidden = NO;
    }
    else
    {
        self.taskLab.hidden = NO;
    }
}
- (void)bindView
{
    self.headLine.frame = CGRectMake(0, 0, SCREEN_W, 5);
    [self addSubview:self.headLine];
    
    self.startImg.frame = CGRectMake(12 * SCREEN_W_COEFFICIENT, 20 + CGRectGetMaxY(self.headLine.frame), 20 *SCREEN_W_COEFFICIENT, 20 *SCREEN_W_COEFFICIENT);
    [self addSubview:self.startImg];
    
    self.startLab.frame = CGRectMake(CGRectGetMaxX(self.startImg.frame) + 6 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.startImg.frame), 80 * SCREEN_W_COEFFICIENT, 30);
    [self addSubview:self.startLab];
    
    self.arrowImg.frame = CGRectMake(CGRectGetMaxX(self.startLab.frame), CGRectGetMaxY(self.startLab.frame) - 10, 40 * SCREEN_W_COEFFICIENT, 5);
    [self addSubview:self.arrowImg];
    
    self.timeUseLab.frame = CGRectMake(CGRectGetMinX(self.arrowImg.frame), CGRectGetMaxY(self.arrowImg.frame) - 20, CGRectGetWidth(self.arrowImg.frame), 20);
    [self addSubview:self.timeUseLab];
    
    self.endImg.frame = CGRectMake(CGRectGetMaxX(self.timeUseLab.frame) + 12 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.startImg.frame), CGRectGetWidth(self.startImg.frame), 25);
    [self addSubview:self.endImg];
    
    self.endLab.frame = CGRectMake(CGRectGetMaxX(self.endImg.frame) + 6 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.endImg.frame), CGRectGetWidth(self.startLab.frame), CGRectGetHeight(self.startLab.frame));
    [self addSubview:self.endLab];
    
    self.timeStartLab.frame = CGRectMake(CGRectGetMinX(self.startLab.frame), CGRectGetMaxY(self.startLab.frame) + 20, CGRectGetMaxX(self.endLab.frame) - CGRectGetMinX(self.startLab.frame), 20);
    [self addSubview:self.timeStartLab];
    
    self.typeLab.frame = CGRectMake(SCREEN_W - 60 * SCREEN_W_COEFFICIENT,35, 60 * SCREEN_W_COEFFICIENT, 30);
    [self addSubview:self.typeLab];
    
    self.moneyLab.frame = CGRectMake(CGRectGetMinX(self.typeLab.frame) - 80 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.typeLab.frame), 80 * SCREEN_W_COEFFICIENT, CGRectGetHeight(self.typeLab.frame));
    [self addSubview:self.moneyLab];
    
    self.taskLab.frame = CGRectMake(CGRectGetMinX(self.typeLab.frame) - 80 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.typeLab.frame), 80 * SCREEN_W_COEFFICIENT, CGRectGetHeight(self.typeLab.frame));
    [self addSubview:self.taskLab];
}
- (UIView *)headLine
{
    if (!_headLine) {
        _headLine = [UIView new];
        _headLine.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _headLine;
}
- (UIImageView *)startImg
{
    if (!_startImg) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        imageView.image = [UIImage imageNamed:@"起点-拷贝"];
        
        _startImg = imageView;
    }
    return _startImg;
}
- (UILabel *)startLab
{
    if (!_startLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20 * SCREEN_W_COEFFICIENT];
        _startLab = label;
    }
    return _startLab;
}
- (UIImageView *)arrowImg
{
    if (!_arrowImg) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        imageView.image = [UIImage imageNamed:@"形状-4"];
        _arrowImg = imageView;
    }
    return _arrowImg;
}
- (UILabel *)timeUseLab
{
    if (!_timeUseLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20 * SCREEN_W_COEFFICIENT];
        
        _timeUseLab = label;
    }
    return _timeUseLab;
}

- (UIImageView *)endImg
{
    if (!_endImg) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 8)];
        imageView.image = [UIImage imageNamed:@"终点"];
        
        _endImg = imageView;
    }
    return _endImg;
}
- (UILabel *)endLab
{
    if (!_endLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20 * SCREEN_W_COEFFICIENT];
        _endLab = label;
    }
    return _endLab;
}
- (UILabel *)timeStartLab
{
    if (!_timeStartLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:18 * SCREEN_W_COEFFICIENT];
        _timeStartLab = label;
    }
    return _timeStartLab;
}
- (UILabel *)taskLab
{
    if (!_taskLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR;
        label.font = [UIFont systemFontOfSize:22 * SCREEN_W_COEFFICIENT];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"任务";
        _taskLab = label;
    }
    return _taskLab;
}
- (UILabel *)moneyLab
{
    if (!_moneyLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _moneyLab = label;
    }
    return _moneyLab;
}
- (UILabel *)typeLab
{
    if (!_typeLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:14.0f];
        
        _typeLab = label;
    }
    return _typeLab;
}
@end
