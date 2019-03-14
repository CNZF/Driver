//
//  ZCCarInfomationTableViewCell.m
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCarInfomationTableViewCell.h"

@implementation ZCCarInfomationTableViewCell

-(void)bindView {

    self.lbTitle.frame = CGRectMake(20, 5, 120, 44);
    [self addSubview:self.lbTitle];

    self.lb.frame = CGRectMake(self.lbTitle.right + 15, 10, 200, 40);
    [self addSubview:self.lb];

    self.textView.frame = CGRectMake(SCREEN_W - 180, 10, 180, 40);
    [self addSubview:self.textView];



}

- (UILabel *)lbTitle {
    if (!_lbTitle) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.numberOfLines = 0;


        _lbTitle = label;
    }
    return _lbTitle;
}

- (YMTextView *)textView {
    if (!_textView) {
        _textView = [YMTextView new];
        _textView.font = [UIFont systemFontOfSize:18.0f];
        _textView.placeholder = @"请选择";
        _textView.editable = NO;
        _textView.scrollEnabled = NO;



    }
    return _textView;
}

- (UILabel *)lb
{
    if (!_lb) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"请选择";


        _lb = label;
    }
    return _lb;
}



@end
