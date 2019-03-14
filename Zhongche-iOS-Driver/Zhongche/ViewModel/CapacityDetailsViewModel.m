//
//  CapacityDetailsViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "CapacityDetailsViewModel.h"

@implementation CapacityDetailsViewModel

/**
 *  获取定订单详情
 *
 *  @param poolid   订单id
 *  @param callback
 */
-(void)getCapacityDetailsWithPoolid:(int)poolid callback:(void(^)(CapacityModel *info))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",poolid] forKey:@"poolid"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"transedetail" forKey:@"method"];
    [self.dicHead setValue:@"transeDetail" forKey:@"requestPath"];
    
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
                NSDictionary * dic = result[@"data"][0][@"list"];
                CapacityModel * model = [CapacityModel yy_modelWithJSON:dic];
                model.line = result[@"data"][0][@"line"];
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
 *  接受拒绝订单
 *
 *  @param username     用户ID
 *  @param poolid       订单ID
 *  @param type         1接受  2拒绝
 *  @param rejectReason 拒绝原因
 *  @param callback
 */
-(void)agreeCapacityWithUsername:(int)username WithPoolid:(int)poolid WithType:(int)type WithRejectReason:(NSString *)rejectReason callback:(void(^)(BOOL info))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",username] forKey:@"username"];
    [params setValue:[NSString stringWithFormat:@"%i",poolid] forKey:@"poolid"];
    [params setValue:[NSString stringWithFormat:@"%i",type] forKey:@"type"];
    [params setValue:rejectReason forKey:@"rejectReason"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"acceprice" forKey:@"method"];
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
                int type = [result[@"data"][0][@"type"] intValue];
                if (type == 1) {
                    callback(YES);
                }
                else if (type == 2)
                {
                    callback(NO);
                }
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
