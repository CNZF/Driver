//
//  BaseTableViewCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self bindView];
        [self bindAction];
        [self bindModel];
    }
    return self;
}
/**
 *  加载视图
 */
- (void)bindView {}

/**
 *  加载模型
 */
- (void)bindModel {}

/**
 *  加载方法
 */
- (void)bindAction {}
@end
