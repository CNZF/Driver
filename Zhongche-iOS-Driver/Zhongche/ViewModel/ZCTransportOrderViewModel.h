//
//  ZCTransportOrderViewModel.h
//  Zhongche
//
//  Created by lxy on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZCTransportOrderModel.h"
#import "PushModel.h"

@interface ZCTransportOrderViewModel : BaseViewModel


/**
 *  运单查询
 *
 *  @param type     类型
 *  @param driverid 用户ID
 *  @param callback 订单对象数组
 */
-(void)selectOrderWithType:(int)type WithDriverid:(int)driverid callback:(void(^)(NSMutableArray *arrInfo))callback;

/**
 *  运单详情查询
 *
 *  @param willid 运单Id
 */

- (void)selectOrderDetailWithWillid:(NSString *)willid WithWaybillStatus:(NSString *)waybillStatus callback:(void(^)(ZCTransportOrderModel *info))callback;


/**
 *  完成装载
 *
 *  @param type          0 装载扫描 1 抵达扫描
 *  @param qrcode        二维码信息
 *  @param billid        运单号
 *  @param orderid       订单号
 *  @param containercode 装箱码
 *  @param callback      请求结果
 */

-(void)finishShipmentWithType:(int)type WithQrcode:(NSString *)qrcode WithBillid:(NSString *)billid WithContainercode:(NSString *)containercode  callback:(void(^)(NSString *message))callback;

/**
 *  评价
 *
 *  @param billid                运单号
 *  @param shipperRate           发货人评价星级
 *  @param shipperRateContent    发货人评价
 *  @param consigneeRate         收货人评价星级
 *  @param consignnerRateContent 收货人评价
 *  @param callback              请求结果
 */

-(void)markeWithBillid:(int)billid WithShipperRate:(int)shipperRate WithShipperRateContent:(NSString *)shipperRateContent WithConsigneeRate:(int)consigneeRate WithConsignnerRateContent:(NSString *)consignnerRateContent  callback:(void(^)(NSString *message))callback;

/**
 *  抢单
 *
 *  @param model    抢单对象
 *  @param callback 返回
 */

- (void)receiveOrderWithPushModel:(PushModel *)model callback:(void(^)(NSString *st))callback;

/**
 *  确认订单
 *
 *  @param isAccept   0、取消 1、确认
 *  @param waybillId  运单号
 *  @param callback 返回
 */

- (void)centerOrderWithIsAccept:(int)isAccept WithWaybillId:(NSString *)waybillId callback:(void(^)(NSString *st))callback;

/**
 *  发现
 *
 *  @param type      0 加油站 1加气站 2维修站 3饭店
 *  @param longitude 经度
 *  @param latitude  纬度
 */
-(void)findWithTyp:(int)type Withlongitude: (int)longitude Withlatitude:(int)latitude callback:(void(^)(NSString *st))callback;


@end
