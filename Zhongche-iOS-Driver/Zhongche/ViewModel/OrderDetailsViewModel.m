//
//  OrderDetailsViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "OrderDetailsViewModel.h"

@implementation OrderDetailsViewModel
/**
 *  运单详情
 *
 *  @param uid      用户id
 *  @param billid   订单id
 *  @param callback
 */
-(void)selectOrderWithUserId:(int)uid WithBillid:(int)billid callback:(void(^)(ZCTransportOrderModel *info))callbac {
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",uid] forKey:@"userid"];
    [params setValue:[NSString stringWithFormat:@"%i",billid] forKey:@"billid"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"billdetail" forKey:@"method"];
    [self.dicHead setValue:@"billdetail" forKey:@"requestPath"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"00"])
            {
                NSArray *data = result[@"data"];
                NSDictionary *dic  = data[0][@"billinfo"];
                ZCTransportOrderModel *info = [ZCTransportOrderModel yy_modelWithJSON:dic];
                callbac(info);
                
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
