//
//  PeripheralServicesViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PeripheralServicesViewModel.h"
#import "PlaceDetailsModel.h"

@implementation PeripheralServicesViewModel
/**
 *  获取周边服务
 *
 *  @param type      服务类型
 *  @param driverid  用户id
 *  @param longitude 经度
 *  @param latitude  纬度
 *  @param callback
 */
-(void)getPeripheralServicesWithType:(int)type WithDriverid:(int)driverid WithLongitude:(float)longitude WithLatitude:(float)latitude callback:(void(^)(NSMutableArray *arrInfo))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];


    //  [params setValue:[NSString stringWithFormat:@"%i",model.waybillId]  forKey:@"waybillId"];
    [params setValue:[NSString stringWithFormat:@"%i",type]  forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%f",longitude]  forKey:@"longitude"];
    [params setValue:[NSString stringWithFormat:@"%f",latitude]  forKey:@"latitude"];

//    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
//    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getNearServiceStation" forKey:@"method"];
    [self.dicHead setValue:@"poi" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];


    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]){

                NSString *stdata = result[@"data"];
                NSDictionary *dicdata = [self dictionaryWithJsonString:stdata];
                NSArray *data = dicdata[@"poi"];
                NSMutableArray *arrInfo = [NSMutableArray array];
                for (NSDictionary *dic in data) {
                    PlaceDetailsModel *info = [PlaceDetailsModel yy_modelWithJSON:dic];
                    [arrInfo addObject:info];
                }
                if (arrInfo.count == 0) {
                    [[Toast shareToast]makeText:@"附近无服务网点" aDuration:1];
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
 *  故障报警
 *
 *  @param billid        运单ID
 *  @param reportcontent 故障内容
 *  @param driverid      用户ID
 *  @param type          0 报警  1 解除
 *  @param callback
 */
-(void)submitFailureWithBillid:(NSString *)billid WithReportcontent:(NSString *)reportcontent WithDriverid:(NSString *)driverid WithType:(int )type WithWaybillCarrierId:(NSString *)waybillCarrierId callback:(void(^)())callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:waybillCarrierId forKey:@"waybillCarrierId"];
    [params setValue:driverid forKey:@"driverId"];
    [params setValue:[NSString stringWithFormat:@"%i",type] forKey:@"status"];
    [params setValue:reportcontent forKey:@"warningTypeCode"];
    
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"faultAlarm" forKey:@"method"];
    [self.dicHead setValue:@"waybill" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]){
                if (type == 0) {
                      [[Toast shareToast]makeText:@"已报警成功" aDuration:1];
                }else {

                    [[Toast shareToast]makeText:@"已解除报警" aDuration:1];


                }




                callback();


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
