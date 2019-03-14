//
//  UpCIDViewModel.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/7/17.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "UpCIDViewModel.h"

@implementation UpCIDViewModel

- (void)upDateCIDWith:(NSString *)cid
{
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [self.dicHead setValue:@"updateCid" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    [self.dicHead setValue:cid forKey:@"clientid"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO]};
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        NSLog(@"%@",responseData);

    }];
//        [SVProgressHUD dismiss];
}
@end
