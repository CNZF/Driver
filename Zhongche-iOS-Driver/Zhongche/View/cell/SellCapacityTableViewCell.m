//
//  SellCapacityTableViewCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/21.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "SellCapacityTableViewCell.h"

@interface SellCapacityTableViewCell()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailsLabel;
@property (nonatomic, strong) UIView * lineView;
@end

@implementation SellCapacityTableViewCell
-(void)bindView
{
    self.titleLabel.frame = CGRectMake(10, 15, SCREEN_W * 0.4,30);
    [self addSubview:self.titleLabel];
    
    self.detailsLabel.frame = CGRectMake(SCREEN_W * 0.5, CGRectGetMinY(self.titleLabel.frame), SCREEN_W * 0.5 - 20, 30);
    [self addSubview:self.detailsLabel];
    
    self.lineView.frame = CGRectMake(0, 58, SCREEN_W, 2);
    [self addSubview:self.lineView];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UILabel *)detailsLabel
{
    if (!_detailsLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentRight;
        _detailsLabel = label;
    }
    return _detailsLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _lineView;
}

-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    if (accessoryType == UITableViewCellAccessoryNone)
    {
        self.detailsLabel.frame = CGRectMake(SCREEN_W * 0.5, CGRectGetMinY(self.titleLabel.frame), SCREEN_W * 0.5 - 20, 30);
    }
    else
    {
        self.detailsLabel.frame = CGRectMake(SCREEN_W * 0.5, CGRectGetMinY(self.titleLabel.frame), SCREEN_W * 0.5 - 40, 30);
    }
}
-(void)setModelStr:(NSString *)modelStr
{
    _modelStr = [NSString stringWithString:modelStr];
    NSArray * strs = [_modelStr componentsSeparatedByString:@"$$"];
    self.titleLabel.text = strs[0];
    self.detailsLabel.text = strs[1];
    if ([_titleLabel.text isEqualToString:@"优选线路"]) {
        self.detailsLabel.numberOfLines = 0;
        NSInteger lines = [self.detailsLabel.text componentsSeparatedByString:@"\n"].count;
        if(lines == 1)
        {
            lines = 2;
        }
        self.detailsLabel.frame = CGRectMake(self.detailsLabel.frame.origin.x, self.detailsLabel.frame.origin.y, self.detailsLabel.frame.size.width, self.detailsLabel.frame.size.height + (lines - 1)*20);
        self.lineView.frame = CGRectMake(self.lineView.frame.origin.x, 60 + 20 * (lines - 2) - 2, self.lineView.frame.size.width, self.lineView.frame.size.height);
    }
}
@end
