//
//  PreferLineViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PreferLineViewModel.h"

@implementation PreferLineViewModel
/**
 *  拉取偏爱路线
 *
 *  @param driverid uid
 *  @param callback
 */
-(void)getCapacityDetailsWithDriverId:(int)driverid callback:(void(^)(NSMutableArray * info))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",driverid] forKey:@"driverid"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getDriverPreferLine" forKey:@"method"];
    [self.dicHead setValue:@"transeLine" forKey:@"requestPath"];
    
    
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
                NSArray * citylist = result[@"data"][0][@"citylist"];
                NSMutableArray * infoArr = [NSMutableArray array];
                LineModel * model;
                for (NSDictionary * dic in citylist)
                {
                    model = [LineModel yy_modelWithJSON:dic];
                    [infoArr addObject:model];
                }
                callback(infoArr);
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
 *  删除偏爱路线
 *
 *  @param driverid uid
 *  @param lines    id 数组
 *  @param callback
 */
-(void)deleteCapacityDetailsWithDriverId:(int)driverid Withlines:(NSArray *)lines callback:(void(^)(BOOL isOk))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",driverid] forKey:@"driverid"];
    [params setValue:lines forKey:@"lines"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"deleteFavourRotes" forKey:@"method"];
    [self.dicHead setValue:@"personCenter" forKey:@"requestPath"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
//            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"00"]) {
                callback(YES);
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
 *  添加偏爱路线
 *
 *  @param driverid uid
 *  @param lines    id 数组
 *  @param callback
 */
-(void)addCapacityDetailsWithDriverId:(int)driverid Withlines:(NSArray *)lines callback:(void(^)(BOOL isOk))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",driverid] forKey:@"driverid"];
    [params setValue:lines forKey:@"lines"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"addFavourRotes" forKey:@"method"];
    [self.dicHead setValue:@"personCenter" forKey:@"requestPath"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
//            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"00"]) {
                callback(YES);
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
 *  依据起点城市拉取路线列表
 *
 *  @param startPositionCode 起点城市code
 *  @param callback
 */
-(void)getCapacityDetailsWithStartPositionCode:(int)startPositionCode callback:(void(^)(NSMutableArray * info))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",startPositionCode] forKey:@"startPositionCode"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getPathList" forKey:@"method"];
    [self.dicHead setValue:@"path" forKey:@"action"];
    
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
                NSArray * citylist = [self dictionaryWithJsonString:result[@"data"]][@"pathList"];
                NSMutableArray * infoArr = [NSMutableArray array];
                LineModel * model;
                for (NSDictionary * dic in citylist)
                {
                    model = [LineModel yy_modelWithJSON:dic];
                    [infoArr addObject:model];
                }
                callback(infoArr);
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
