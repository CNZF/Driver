//
//  SellChuFaTableViewCell.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellHomeModel.h"
 typedef void(^PressBlock)(NSInteger index);
@interface SellChuFaTableViewCell : UITableViewCell

@property (nonatomic, strong) SellHomeModel * model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy)PressBlock block;

- (void)setCellPrefrenceWithIndexPatRow:(NSInteger)index WithModel:(SellHomeModel *)model;

@end
