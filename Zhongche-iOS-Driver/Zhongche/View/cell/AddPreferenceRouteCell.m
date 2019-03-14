//
//  addPreferenceRouteCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "addPreferenceRouteCell.h"

@interface AddPreferenceRouteCell()
@property (nonatomic, strong) UILabel * routesLab;

@end

@implementation AddPreferenceRouteCell
- (void)bindView
{
    self.routesLab.frame = CGRectMake(0, 10, SCREEN_W, 40);
    self.backgroundColor = APP_COLOR_GRAY_LINE;
    [self addSubview:self.routesLab];
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
-(void)setLabeltext:(NSMutableAttributedString *)labeltext
{
    _labeltext = labeltext;
    self.routesLab.attributedText = _labeltext;
}
@end
