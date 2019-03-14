//
//  OrderTabViewCell.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZCTransportOrderModel.h"

@interface OrderTabViewCell : BaseTableViewCell
- (void)loadUIWithmodel:(ZCTransportOrderModel *)model;
@end
