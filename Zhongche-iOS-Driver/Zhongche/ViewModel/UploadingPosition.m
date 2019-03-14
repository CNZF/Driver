//
//  UploadingPosition.m
//  Zhongche
//
//  Created by 中车_LL_iMac on 16/8/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "UploadingPosition.h"

@implementation UploadingPosition
-(void)uploadWithDate:(NSDate *)date WithUserID:(NSString *)userId WithGps:(NSString *)gps callback:(void(^)(BOOL success))callback {
    
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:gps forKey:@"location"];
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]] forKey:@"timeStamp"];
    [dict setValue:userId forKey:@"userId"];
    NSArray * arr = [NSArray arrayWithObject:dict];
    [params setValue:arr forKey:@"gps"];
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"positionUpdate" forKey:@"method"];
    [self.dicHead setValue:@"position" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    
    [[self POST:CHILEDURL Param:@{@"data":st}] subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            callback(YES);
    }
    }error:^(NSError *error) {
    }];
}
@end
