//
//  ZCInputTableViewCell.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ZCInputTableViewCell : BaseTableViewCell

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * inputTextField;
@property (nonatomic, strong) UIButton * eyeBut;
@property (nonatomic, strong) UIButton * validationBut;
@property (nonatomic, assign) int textFieldMaxLength;
@end
