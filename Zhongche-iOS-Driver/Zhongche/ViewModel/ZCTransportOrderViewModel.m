//
//  ZCTransportOrderViewModel.m
//  Zhongche
//
//  Created by lxy on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCTransportOrderViewModel.h"
#import "UserOrderSqlite.h"


@implementation ZCTransportOrderViewModel


/**
 *  运单查询
 *
 *  @param type     类型
 *  @param driverid 用户ID
 *  @param callback 订单对象数组
 */
- (void)selectOrderWithType:(int)type WithDriverid:(int)driverid callback:(void(^)(NSMutableArray *arrInfo))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",driverid] forKey:@"userId"];
    [params setValue:[NSString stringWithFormat:@"%i",driverid] forKey:@"driverId"];
  
    [params setValue:[NSString stringWithFormat:@"%i",type] forKey:@"tab"];

    if (self.userInfo.driverId) {

         [params setValue:self.userInfo.driverId forKey:@"driverId"];
    }


    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getWaybillList" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];


    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {


            NSDictionary *response = responseData[@"response"];

            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                NSString *stdata = result[@"data"];
                NSDictionary *dicdata = [self dictionaryWithJsonString:stdata];
                NSArray *data = dicdata[@"billList"];

                NSMutableArray *arrInfo = [NSMutableArray array];
                for (NSDictionary *dic in data) {
                    ZCTransportOrderModel *info = [ZCTransportOrderModel yy_modelWithJSON:dic];
                    [arrInfo addObject:info];
                }

                callback(arrInfo);

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

/**
 *  运单详情查询
 *
 *  @param willid 运单Id
 */


- (void)selectOrderDetailWithWillid:(NSString *)willid WithWaybillStatus:(NSString *)waybillStatus callback:(void(^)(ZCTransportOrderModel *info))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:willid forKey:@"waybillId"];
    [params setValue:waybillStatus forKey:@"waybillStatus"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getWaybillDetail" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];


    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];

        if (responseData) {

            NSDictionary *response = responseData[@"response"];

            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                NSString *stdata = result[@"data"];
                NSDictionary *dicdata = [self dictionaryWithJsonString:stdata];
                NSDictionary *data = dicdata[@"billDetail"];
                ZCTransportOrderModel *info = [ZCTransportOrderModel yy_modelWithJSON:data];
                callback(info);



            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }



        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];

}

/**
 *  抢单
 *
 *  @param model    抢单对象
 *  @param callback 返回
 */

- (void)receiveOrderWithPushModel:(PushModel *)model callback:(void(^)(NSString *st))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    /**
     *  Integer waybillId;
     Integer waybillGroupId;
     Integer capacityApplyOrderId;
     Integer userId;
     Integer support40GP;
     Integer vehicleId;
     */

    CarInfoModel *carInfo = CAR_INFO;

    
   //  [params setValue:[NSString stringWithFormat:@"%i",model.waybillId]  forKey:@"waybillId"];
     [params setValue:[NSString stringWithFormat:@"%i",model.waybill_group_id]  forKey:@"waybillGroupId"];
     [params setValue:[NSString stringWithFormat:@"%i",model.capacity_apply_order_id]  forKey:@"capacityApplyOrderId"];
     [params setValue:[NSString stringWithFormat:@"%i",carInfo.support_40gp]  forKey:@"support40GP"];
     [params setValue:[NSString stringWithFormat:@"%i",carInfo.vehicle_id]  forKey:@"vehicleId"];


    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"acceptWaybill" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];


    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];

            UserOrderSqlite *userSqlModel = [UserOrderSqlite shareUserOrderSqlite];
            [userSqlModel deleteOneOrderData:model];

            if ([status isEqualToString:@"10000"]) {

//                [[Toast shareToast]makeText:@"已接受派单" aDuration:1];
                callback(status);

            }else{

                callback(status);
                
                [[Toast shareToast]makeText:message aDuration:1];
            }



        }
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
}

/**
 *  确认订单
 *
 *  @param isAccept   0、取消 1、确认
 *  @param waybillId  运单号
 *  @param callback 返回
 */

- (void)centerOrderWithIsAccept:(int)isAccept WithWaybillId:(NSString *)waybillId callback:(void(^)(NSString *st))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];



    //  [params setValue:[NSString stringWithFormat:@"%i",model.waybillId]  forKey:@"waybillId"];
    [params setValue:[NSString stringWithFormat:@"%@",waybillId]  forKey:@"waybillId"];
    [params setValue:[NSString stringWithFormat:@"%i",isAccept]  forKey:@"isAccept"];



    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"confirmTask" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];


    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                
                callback(status);

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
                callback(@"");


            }



        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
}

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

- (void) finishShipmentWithType:(int)type WithQrcode:(NSString *)qrcode WithBillid:(NSString *)billid WithContainercode:(NSString *)containercode  callback:(void(^)(NSString *message))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",type] forKey:@"type"];
    [params setValue:billid forKey:@"waybillId"];
    [params setValue:@"55" forKey:@"qrcode"];
    [params setValue:containercode forKey:@"containerCode"];
    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
     [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"scanCode" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
      
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];


            if ([status isEqualToString:@"10000"]) {


                callback(status);

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

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

-(void)markeWithBillid:(int)billid WithShipperRate:(int)shipperRate WithShipperRateContent:(NSString *)shipperRateContent WithConsigneeRate:(int)consigneeRate WithConsignnerRateContent:(NSString *)consignnerRateContent  callback:(void(^)(NSString *message))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",shipperRate] forKey:@"shipperRate"];
    [params setValue:[NSString stringWithFormat:@"%i",consigneeRate] forKey:@"consigneeRate"];
    [params setValue:[NSString stringWithFormat:@"%i",billid] forKey:@"billid"];
    [params setValue:shipperRateContent forKey:@"shipperRateContent"];
    [params setValue:consignnerRateContent forKey:@"consignnerRateContent"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"appraise" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"requestPath"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"00"]) {


                callback(@"成功");

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

/**
 *  发现
 *
 *  @param type      0 加油站 1加气站 2维修站 3饭店
 *  @param longitude 经度
 *  @param latitude  纬度
 */
-(void)findWithTyp:(int)type Withlongitude: (int)longitude Withlatitude:(int)latitude callback:(void(^)(NSString *st))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];


    //  [params setValue:[NSString stringWithFormat:@"%i",model.waybillId]  forKey:@"waybillId"];
    [params setValue:[NSString stringWithFormat:@"%i",type]  forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%i",longitude]  forKey:@"longitude"];
    [params setValue:[NSString stringWithFormat:@"%i",latitude]  forKey:@"latitude"];

    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getNearServiceStation" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];


    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"已接受派单" aDuration:1];
                callback(status);

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }



        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];


}


@end
