//
//  TwoLabelCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/31.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "TwoLabelCell.h"

@implementation TwoLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CarInfoModel *)model
{
    _model = model;
    self.label1.text = model.code;
    self.label2.text = model.vehicle_type;
    
}

@end
