//
//  UploadPositionViewModel.m
//  Zhongche
//
//  Created by 中车_LL_iMac on 16/8/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "UploadPositionViewModel.h"

@implementation UploadPositionViewModel
/**
 *  上传定位信息
 *
 *  @param userId    用户ID
 *  @param location  位置坐标  格式 [aaa,bbb]
 *  @param timeStamp 时间转换成秒
 *  @param callback  回调
 */
-(void)uploadPositionWithUserID:(NSString *)userId WithLocation:(NSString *)location WithTimeStamp:(NSString *)timeStamp  callback:(void(^)(BOOL success))callback {
    
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    NSMutableDictionary * gps = [NSMutableDictionary dictionary];
    [gps setObject:userId forKey:@"userId"];
    [gps setObject:location forKey:@"location"];
    [gps setObject:timeStamp forKey:@"timeStamp"];
    
    NSArray * array = [NSArray arrayWithObject:gps];
    
    [params setObject:array forKey:@"gps"];
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];
    
    [self.dicHead setValue:@"positionUpdate" forKey:@"method"];
    [self.dicHead setValue:@"position" forKey:@"requestPath"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData)
        {
            callback(YES);
        }
        
    }error:^(NSError *error) {
        
    }];
}

@end
