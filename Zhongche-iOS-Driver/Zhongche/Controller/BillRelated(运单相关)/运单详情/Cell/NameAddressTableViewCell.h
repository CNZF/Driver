//
//  NameAddressTableViewCell.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTransportOrderModel.h"
 typedef void(^CallBlock)(NSInteger index);
@interface NameAddressTableViewCell : UITableViewCell
@property (nonatomic, strong)ZCTransportOrderModel * model;
@property (nonatomic, copy) CallBlock block;
@end
