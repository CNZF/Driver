//
//  BillHomeTableViewCell.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTransportOrderModel.h"

 typedef void(^BillCellBtnClickBlock)(ZCTransportOrderModel * model, NSString * btnTitle);

@interface BillHomeTableViewCell : UITableViewCell
@property (nonatomic, strong) ZCTransportOrderModel * model;
@property (nonatomic, copy)BillCellBtnClickBlock block;
@end
