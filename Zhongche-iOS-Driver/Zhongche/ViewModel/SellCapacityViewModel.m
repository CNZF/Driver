//
//  SellCapacityViewModel.m
//  Zhongche
//
//  Created by lxy on 16/9/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "SellCapacityViewModel.h"
#import "UserInfoModel.h"
#import "MyFilePlist.h"


@implementation SellCapacityViewModel
/**
 *  出售运力接口
 *
 */
- (void)sellCapacityWith:(ZCTransportationModel *)model callback:(void(^)())callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:model.price forKey:@"price"];
    [params setValue:[NSNumber numberWithInt:[self.userInfo.driverId intValue]] forKey:@"driverId"];
    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
    [params setValue:[NSNumber numberWithInt:model.carInfo.vehicle_id] forKey:@"vehicleId"];
    [params setValue:model.startRegionCode forKey:@"startRegionCode"];
    [params setValue:model.endRegionCode forKey:@"endRegionCode"];
    [params setValue:model.startTime forKey:@"startTime"];
    [params setValue:[NSNumber numberWithInt:model.carInfo.support_40gp] forKey:@"suport40"];
    [params setValue:model.carInfo.code forKey:@"vehiclecode"];
    [params setValue:model.carInfo.vehicle_type_code forKey:@"vehicleType"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"sellTransportCapacity" forKey:@"method"];
    [self.dicHead setValue:@"transportCapacity" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    NSLog(@"%@",st);
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];


//            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
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

/**
 *  运力交易记录
 */

- (void)selectCapacityWith:(int )tab callback:(void (^)(NSArray * recordList))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"currentPage"];
    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];
    [params setValue:[NSString stringWithFormat:@"%i",tab] forKey:@"tab"];
    [params setValue:@"10" forKey:@"pageSize"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getTransportCapacityList" forKey:@"method"];
    [self.dicHead setValue:@"transportCapacity" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    NSLog(@"%@",st);
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
        
            //            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                NSDictionary *dicresult = response[@"result"];

                NSString *data = dicresult[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arrRecord = dicData[@"transportCapacityList"];
                NSMutableArray *arrRecords = [NSMutableArray array];
                for (NSDictionary *dic in arrRecord) {
                    ZCTransportationModel *model = [ZCTransportationModel yy_modelWithJSON:dic];
                    model.vehicleCode = dic[@"vehicleCode"];
                    model.iden = [dic[@"id"]intValue];
                    [arrRecords addObject:model];
                }

                callback(arrRecords);


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
 *  运力详情
 *
 *  @param capacityId 运力号
 *  @param info       运力详情
 */

- (void)selectCapacityDetailWith:(int)capacityId callback:(void (^)(ZCTransportationModel * info))callback{

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",capacityId] forKey:@"capacityId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getTransportCapcityDetail" forKey:@"method"];
    [self.dicHead setValue:@"transportCapacity" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    NSLog(@"%@",st);
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];


            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                NSDictionary *dicresult = response[@"result"];
                NSString *data = dicresult[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSDictionary *dicInfo = dicData[@"transportCapacityDetail"];

                ZCTransportationModel *model = [ZCTransportationModel yy_modelWithJSON:dicInfo];
                model.vehicleCode = dic[@"vehicleCode"];
                model.iden = [dic[@"id"]intValue];

                callback(model);



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
 *  更改价格
 *
 *  @param capacityId 运力号
 *  @param price      价格
 */

- (void)changePriceWith:(int)capacityId WithPrice:(NSString *)price callback:(void(^)())callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",capacityId] forKey:@"vehicleInfoId"];
    [params setValue:price forKey:@"price"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"updatePrice" forKey:@"method"];
    [self.dicHead setValue:@"transportCapacity" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    NSLog(@"%@",st);
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];


            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

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


/**
 *  取消运力
 *
 *  @param capacityId 运力号
 */

- (void)cancleWith:(int)capacityId callback:(void(^)())callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",capacityId] forKey:@"vehicleInfoId"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"cancle" forKey:@"method"];
    [self.dicHead setValue:@"transportCapacity" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    NSLog(@"%@",st);
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
         


            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

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
