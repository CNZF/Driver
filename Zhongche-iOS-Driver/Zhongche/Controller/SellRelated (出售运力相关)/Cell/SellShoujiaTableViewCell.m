//
//  SellShoujiaTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "SellShoujiaTableViewCell.h"

@interface SellShoujiaTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *priceField;

@end

@implementation SellShoujiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.priceField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SellHomeModel *)model
{
    _model = model;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.model.sellPrice = textField.text;
}

@end
