//
//  PreferenceRouteCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PreferenceRouteCell.h"

@interface PreferenceRouteCell()
@property (nonatomic, strong) UILabel * routesLab;
@end
@implementation PreferenceRouteCell
- (void)bindView
{
    self.routesBtn.frame = CGRectMake(20, 20, 20, 20);
    [self addSubview:self.routesBtn];
    
    self.routesLab.frame = CGRectMake(CGRectGetMaxX(self.routesBtn.frame), 10, SCREEN_W - CGRectGetMaxX(self.routesBtn.frame), 40);
    [self addSubview:self.routesLab];
}
-(void)setLabeltext:(NSMutableAttributedString *)labeltext
{
    _labeltext = labeltext;
    self.routesLab.attributedText = _labeltext;
}
- (UILabel *)routesLab
{
    if (!_routesLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        _routesLab = label;
    }
    return _routesLab;
}

- (UIButton *)routesBtn
{
    if (!_routesBtn) {
        UIButton *button = [[UIButton alloc]init];
        button.userInteractionEnabled = NO;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"椭圆-32"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        _routesBtn = button;
    }
    return _routesBtn;
}
-(void)setIsEditoring:(BOOL)isEditoring
{
    _isEditoring = isEditoring;
    if (isEditoring == NO) {
        self.routesBtn.hidden = YES;
        self.routesLab.frame = CGRectMake(10, 10, SCREEN_W - CGRectGetMaxX(self.routesBtn.frame), 40);
    }
    else
    {
        self.routesBtn.hidden = NO;
        self.routesLab.frame = CGRectMake(CGRectGetMaxX(self.routesBtn.frame), 10, SCREEN_W - CGRectGetMaxX(self.routesBtn.frame), 40);
    }
}
@end
