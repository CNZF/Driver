//
//  ZCWalletViewModel.m
//  Zhongche
//
//  Created by lxy on 2016/10/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCWalletViewModel.h"
#import "ZCWalletOredrInfo.h"


@implementation ZCWalletViewModel

/**
 *  绑定钱包
 *
 *  @param userName     用户名
 *  @param bankCardNum  银行卡号
 *  @param verifyCode   验证码
 *  @param bankCardName 银行
 *  @param bankCardCode 银行卡code
 */


-(void)bindWalletWithUserName:(NSString *)userName WithBankCardNum:(NSString *)bankCardNum WithVerifyCode:(NSString *)verifyCode WithBankCardName:(NSString *)bankCardName WithBankCardCode:(NSString *)bankCardCode callback:(void(^)(NSString *st))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    UserInfoModel *userInfo = USER_INFO;
    if (userInfo) {
        NSString *stId  = [NSString stringWithFormat:@"%@",userInfo.driverId];
        [params setValue:[NSString stringWithFormat:@"%@",stId] forKey:@"driverId"];

    }

     [params setValue:userName forKey:@"userName"];
     [params setValue:verifyCode forKey:@"verifyCode"];
     [params setValue:bankCardNum forKey:@"bankCardNum"];
     [params setValue:bankCardName forKey:@"bankCardName"];
     [params setValue:bankCardCode forKey:@"bankCardCode"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"bindingBankCard" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"绑定成功" aDuration:1];

                callback(status);



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
 *  获得银行卡信息
 *
 *  @param bankCardNum 银行卡号
 *  @param callback    银行卡信息对象
 */
-(void)getBankRelativeWithBankCardNum:(NSString *)bankCardNum callback:(void(^)(ZCBankCardModel *info))callback {

       [SVProgressHUD showWithStatus:LOADING];
        NSMutableDictionary *params= [NSMutableDictionary dictionary];
         [params setValue:bankCardNum forKey:@"bankCardNum"];

        [self.dicRequest setObject:params forKey:@"params"];
    
        [self.dicHead setValue:@"getBankRelative" forKey:@"method"];
        [self.dicHead setValue:@"wallet" forKey:@"action"];
        [self.dicHead setValue:@"0" forKey:@"zip"];
        [self.dicHead setValue:@"0" forKey:@"encrpy"];
    
        NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };
    
        NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
        NSString *st = [self dictionaryToJson:dic];

        [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
            id responseData = [self getResponseData:tuple];
            if (responseData) {
                NSDictionary *response = responseData[@"response"];
                NSDictionary *result = response[@"result"];
                NSString *status = response[@"status"];
                NSString *message = response[@"message"];
                if ([status isEqualToString:@"10000"]) {
                    NSString *stInfo = result[@"data"];
                    NSDictionary *dicInfo= [self dictionaryWithJsonString:stInfo];
                    NSDictionary *dicUser = dicInfo[@"RelativeInfo"];
                    ZCBankCardModel *info = [ZCBankCardModel yy_modelWithJSON:dicUser];

                    callback(info);

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
 *  绑定银行卡获取验证码
 */

- (void)getRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getBindSms" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"验证码发送成功,请等待" aDuration:1];

                callback (status);


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
 *  设置支付密码获取验证码
 */

- (void)getPayPWDRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getPaySms" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"验证码发送成功,请等待" aDuration:1];

                callback (status);


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
 *  获取钱包信息
 */
- (void)getWalletInfocallback:(void(^)(ZCWalletInfo *info))callback  {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getWalletInfo" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            NSDictionary *result = response[@"result"];
            if ([status isEqualToString:@"10000"]) {

                NSString *stInfo = result[@"data"];
                NSDictionary *dicInfo= [self dictionaryWithJsonString:stInfo];
                ZCWalletInfo *info = [ZCWalletInfo yy_modelWithJSON:dicInfo];

                callback(info);



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
 *  获取钱包银行卡信息
 */
- (void)getgetBindingBankCardcallback:(void(^)(ZCBankCardMessageInfo *info))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getBindingBankCard" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            NSDictionary *result = response[@"result"];
            if ([status isEqualToString:@"10000"]) {

                NSString *stInfo = result[@"data"];
                NSDictionary *dicInfo= [self dictionaryWithJsonString:stInfo];
                ZCBankCardMessageInfo *info = [ZCBankCardMessageInfo yy_modelWithJSON:dicInfo];

                callback(info);



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
 *  设置支付密码
 *
 *  @param idCard     身份证号
 *  @param password   密码
 *  @param verifyCode 验证码
 */
- (void)setPayPWDWithIdCard:(NSString *)idCard WithPassword:(NSString *)password WithVerifyCode:(NSString *)verifyCode callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:idCard forKey:@"idCard"];

    NSString *stMd5 = [self stringWithMd5:password];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];
    [params setValue:verifyCode forKey:@"verifyCode"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"setPayPassword" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];

            if ([status isEqualToString:@"10000"]) {

                callback (status);





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
 *  查询账单
 *
 *  @param callback 账单数组
 */
- (void)selectWalletMoneyOrderListcallback:(void(^)(NSMutableArray *arrInfo))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:self.userInfo.driverId forKey:@"driverId"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getAccountBalanceList" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
         if (responseData) {
        NSDictionary *response = responseData[@"response"];
        NSDictionary *result = response[@"result"];
        NSString *status = response[@"status"];
        NSString *message = response[@"message"];
        if ([status isEqualToString:@"10000"]) {
            NSString *stInfo = result[@"data"];
            NSDictionary *dicInfo= [self dictionaryWithJsonString:stInfo];
            NSArray *data = dicInfo[@"accountBalanceList"];

            NSMutableArray *arrInfo = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                ZCWalletOredrInfo *info = [ZCWalletOredrInfo yy_modelWithJSON:dic];
                [arrInfo addObject:info];
            }

            callback(arrInfo);


            //ZCBankCardModel *info = [ZCBankCardModel yy_modelWithJSON:dicUser];

            //callback(info);

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
 *  解绑银行卡
 *
 *  @param pwd 支付密码
 */
- (void)unBindingBankCardWithPWD:(NSString *)pwd callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    NSString *stMd5 = [self stringWithMd5:pwd];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"payPassword"];
  


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"unBindingBankCard" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
//            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                callback (status);


            }else{
                 callback (status);
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
 *  修改支付密码
 *
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *  @param verifyCode  验证码
 *  @param callback    返回状态
 */

- (void)setPayPWDWithOldPassword:(NSString *)oldPassword WithNewPassword:(NSString *)newPassword WithVerifyCode:(NSString *)verifyCode callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
     NSString *stMd51 = [self stringWithMd5:oldPassword];
    [params setValue:[self stringWithMd5:stMd51] forKey:@"oldPassword"];

    NSString *stMd5 = [self stringWithMd5:newPassword];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"newPassword"];
    [params setValue:verifyCode forKey:@"verifyCode"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"changePayPassword" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];

            if ([status isEqualToString:@"10000"]) {

                callback (status);





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
 *  提现
 *
 *  @param amount      金额
 *  @param payPassword 支付密码
 *  @param callback    返回
 */
- (void)withdrawMoneyWithAmount:(NSString *)amount WithPayPassword:(NSString *)payPassword callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    [params setValue:amount forKey:@"amount"];

    NSString *stMd5 = [self stringWithMd5:payPassword];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"payPassword"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"withdraw" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];

            if ([status isEqualToString:@"10000"]) {

                callback (status);





            }else{

                callback (status);
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
 *  检验支付密码
 *
 *  @param pwd 支付密码
 */
- (void)checkWithPWD:(NSString *)pwd callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    self.userInfo = USER_INFO;
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    NSString *stMd5 = [self stringWithMd5:pwd];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"payPassword"];



    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"checkPayPassword" forKey:@"method"];
    [self.dicHead setValue:@"wallet" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            //            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                callback (status);


            }else{
                callback (status);
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
