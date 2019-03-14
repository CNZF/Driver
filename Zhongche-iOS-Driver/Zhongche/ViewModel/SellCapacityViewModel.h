//
//  SellCapacityViewModel.h
//  Zhongche
//
//  Created by lxy on 16/9/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZCTransportationModel.h"
#import "ZCTransportOrderModel.h"

@interface SellCapacityViewModel : BaseViewModel
/**
 *  出售运力接口
 *
 *  @param pathId          路径标识
 *  @param totalPrice      总价格
 *  @param userId          用户ID
 *  @param vehicleId       车辆标识
 *  @param startRegionCode 起始地区code
 *  @param endRegionCode   结束地区code
 *  @param startEntrepotId 起点仓库ID
 *  @param endEntrepotId   终点仓库ID
 *  @param vehicleType     车辆类型
 *  @param startEffective  开始时间
 *  @param endEffective    结束时间
 *  @param callback        回调
 */
- (void)sellCapacityWith:(ZCTransportationModel *)model callback:(void(^)())callback;

/**
 *  运力交易记录
 *  tab（0、未结算，1、已结算，2、未成交）
 */

- (void)selectCapacityWith:(int )tab callback:(void (^)(NSArray * recordList))callback;

/**
 *  运力详情
 *
 *  @param capacityId 运力号
 *  @param info       运力详情
 */

- (void)selectCapacityDetailWith:(int)capacityId callback:(void (^)(ZCTransportationModel * info))callback;

/**
 *  更改价格
 *
 *  @param capacityId 运力号
 *  @param price      价格
 */

- (void)changePriceWith:(int)capacityId WithPrice:(NSString *)price callback:(void(^)())callback;

/**
 *  取消运力
 *
 *  @param capacityId 运力号
 */

- (void)cancleWith:(int)capacityId callback:(void(^)())callback;
@end
