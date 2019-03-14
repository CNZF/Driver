//
//  PeripheralServicesViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"

@interface PeripheralServicesViewModel : BaseViewModel
/**
 *  获取周边服务
 *
 *  @param type      服务类型
 *  @param driverid  用户id
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param callback
 */
-(void)getPeripheralServicesWithType:(int)type WithDriverid:(int)driverid WithLongitude:(float)longitude WithLatitude:(float)latitude callback:(void(^)(NSMutableArray *arrInfo))callback;
/**
 *  故障报警
 *
 *  @param billid        运单ID
 *  @param reportcontent 故障内容
 *  @param driverid      用户ID
 *  @param type          0 报警  1 解除
 *  @param callback
 */
-(void)submitFailureWithBillid:(NSString *)billid WithReportcontent:(NSString *)reportcontent WithDriverid:(NSString *)driverid WithType:(int )type WithWaybillCarrierId:(NSString *)waybillCarrierId callback:(void(^)())callback;
@end
