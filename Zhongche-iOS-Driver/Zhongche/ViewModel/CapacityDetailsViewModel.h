//
//  CapacityDetailsViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "CapacityModel.h"
@interface CapacityDetailsViewModel : BaseViewModel
/**
 *  获取运力详情
 *
 *  @param poolid ID
 *  @param callback 
 */
-(void)getCapacityDetailsWithPoolid:(int)poolid callback:(void(^)(CapacityModel *info))callback;
/**
 *  接受拒绝订单
 *
 *  @param username     用户ID
 *  @param poolid       订单ID
 *  @param type         1接受  2拒绝
 *  @param rejectReason 拒绝原因
 *  @param callback
 */
-(void)agreeCapacityWithUsername:(int)username WithPoolid:(int)poolid WithType:(int)type WithRejectReason:(NSString *)rejectReason callback:(void(^)(BOOL info))callback;
@end
