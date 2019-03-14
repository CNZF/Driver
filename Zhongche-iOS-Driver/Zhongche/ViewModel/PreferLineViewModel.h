//
//  PreferLineViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "LineModel.h"

@interface PreferLineViewModel : BaseViewModel
/**
 *  拉取偏爱路线
 *
 *  @param driverid uid
 *  @param callback
 */
-(void)getCapacityDetailsWithDriverId:(int)driverid callback:(void(^)(NSMutableArray * info))callback;
/**
 *  删除偏爱路线
 *
 *  @param driverid uid
 *  @param lines    id 数组
 *  @param callback
 */
-(void)deleteCapacityDetailsWithDriverId:(int)driverid Withlines:(NSArray *)lines callback:(void(^)(BOOL isOk))callback;
/**
 *  添加偏爱路线
 *
 *  @param driverid uid
 *  @param lines    id 数组
 *  @param callback
 */
-(void)addCapacityDetailsWithDriverId:(int)driverid Withlines:(NSArray *)lines callback:(void(^)(BOOL isOk))callback;
/**
 *  依据起点城市拉取路线列表
 *
 *  @param startPositionCode 起点城市code
 *  @param callback
 */
-(void)getCapacityDetailsWithStartPositionCode:(int)startPositionCode callback:(void(^)(NSMutableArray * info))callback;
@end
