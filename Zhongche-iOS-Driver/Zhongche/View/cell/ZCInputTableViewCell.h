//
//  ZCInputTableViewCell.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UIImage+getImage.h"

@protocol getCodeDelegate <NSObject>

- (void)getCodeAction;

@end

@interface ZCInputTableViewCell : BaseTableViewCell
@property (nonatomic, assign) int textFieldMaxLength;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * inputTextField;
@property (nonatomic, strong) UIButton * eyeBut;
@property (nonatomic, strong) UIButton * validationBut;

- (void)validationButAction;

@property (nonatomic, strong) UIImageView *ivLogo;

@property (nonatomic, assign) id<getCodeDelegate>getCodeInfo;
@end
