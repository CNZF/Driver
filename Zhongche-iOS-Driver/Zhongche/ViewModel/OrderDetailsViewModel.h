//
//  OrderDetailsViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZCTransportOrderModel.h"

@interface OrderDetailsViewModel : BaseViewModel
/**
 *  运单详情
 *
 *  @param uid      用户id
 *  @param billid   订单id
 *  @param callback
 */
-(void)selectOrderWithUserId:(int)uid WithBillid:(int)billid callback:(void(^)(ZCTransportOrderModel *info))callback;
@end
