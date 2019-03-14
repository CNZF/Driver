//
//  ListTableViewCell.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTransportOrderModel.h"
@interface ListTableViewCell : UITableViewCell
@property (nonatomic, strong)ZCTransportOrderModel * model;
@property (nonatomic, assign)NSInteger index;
- (void) setModelWith:(ZCTransportOrderModel *)model AndIndex:(NSInteger) index;

@end
