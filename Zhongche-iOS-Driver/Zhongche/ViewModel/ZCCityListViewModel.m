//
//  ZCCityListViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCityListViewModel.h"
#import "CityModel.h"

@implementation ZCCityListViewModel
/**
 *  拉取城市列表
 *
 *  @param callback
 */
-(void)getCityListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getCityList" forKey:@"method"];
    [self.dicHead setValue:type forKey:@"action"];
    
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
                [[Toast shareToast]makeText:@"拉取列表成功" aDuration:1];
                NSMutableArray * cityArray = [[NSMutableArray alloc]init];
                CityModel  * model;
                NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"cityList"];
                for (NSDictionary * city in cityArr)
                {
                    model = [CityModel yy_modelWithJSON:city];
                    [cityArray addObject:model];
                }
                callback(cityArray);
                
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
