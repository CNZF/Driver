//
//  CapacityViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "CapacityViewModel.h"
#import "CapacityModel.h"

@implementation CapacityViewModel
/**
 *  订单查询
 *
 *  @param tag     类型
 *  @param driverid 用户ID
 *  @param callback 订单对象数组
 */
-(void)selectCapacityWithType:(int)tag WithDriverid:(int)driverid callback:(void(^)(NSMutableArray *arrInfo))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",tag] forKey:@"tag"];
    [params setValue:[NSString stringWithFormat:@"%i",driverid] forKey:@"driverid"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"transeList" forKey:@"method"];
    [self.dicHead setValue:@"sellTranse" forKey:@"requestPath"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"00"]) {
                NSArray *data = result[@"data"];
                
                NSMutableArray *arrInfo = [NSMutableArray array];
                for (NSDictionary *dic in (data[0][@"list"])) {
                    CapacityModel *info = [CapacityModel yy_modelWithJSON:dic];
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
@end
