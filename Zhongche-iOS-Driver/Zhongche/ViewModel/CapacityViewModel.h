//
//  CapacityViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"

@interface CapacityViewModel : BaseViewModel
/**
 *  订单查询
 *
 *  @param tag     类型
 *  @param driverid 用户ID
 *  @param callback 订单对象数组
 */
-(void)selectCapacityWithType:(int)tag WithDriverid:(int)driverid callback:(void(^)(NSMutableArray *arrInfo))callback;
@end
