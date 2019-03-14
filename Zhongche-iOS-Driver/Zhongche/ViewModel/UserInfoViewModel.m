//
//  UserInfoViewModel.m
//  Zhongche
//
//  Created by lxy on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "UserInfoViewModel.h"
#import "UserInfoModel.h"
#import "BoxInfoModel.h"
#import "CarInfoModel.h"
#import "MyFilePlist.h"



@implementation UserInfoViewModel
/**
 *  登录
 *
 *  @param telephoneNumber 手机号
 *  @param passWord        密码
 *  @param callback        登录用户对象
 */
-(void)loginWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord callback:(void(^)(UserInfoModel *userInfo))callback {
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:telephoneNumber forKey:@"username"];
    NSString *stMd5 = [self stringWithMd5:passWord];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];
    //e326abb7637cc0ac565e8c201e6008e0
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"login" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
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
                [[Toast shareToast]makeText:@"登录成功" aDuration:1];
                NSString *stInfo = result[@"data"];
                NSDictionary *dicInfo= [self dictionaryWithJsonString:stInfo];
                 NSDictionary *dicUser = dicInfo[@"userInfo"];
                UserInfoModel *info = [UserInfoModel yy_modelWithJSON:dicUser];

                info.iden = [dicUser[@"id"]intValue];
                info.token = dicInfo[@"token"];

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
 *  获取用户信息
 */

-(void)getUserInfoWithUserId:(void(^)(UserInfoModel *userInfo))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    UserInfoModel *userInfo = USER_INFO;
    if (userInfo) {
        NSString *stId  = [NSString stringWithFormat:@"%i",userInfo.iden];
        [params setValue:[NSString stringWithFormat:@"%@",stId] forKey:@"userId"];

    }

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getUserInfo" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
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
                NSDictionary *dicUser = dicInfo[@"userInfo"];
                UserInfoModel *info = [UserInfoModel yy_modelWithJSON:dicUser];
                info.iden = [dicUser[@"id"]intValue];
                info.token = dicInfo[@"token"];


                callback(info);

            }else{
                callback(nil);
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {


        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];

         callback(nil);
    }];


}

/**
 *  更改手机号
 */

- (void)changePhoneWithPhone:(NSString *)phone WithVerifyCode:(NSString *)verifyCode WithPassword:(NSString *)password callback:(void(^)(NSString *st))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"newPhone"];
    [params setValue:verifyCode forKey:@"verifyCode"];
    NSString *stMd5 = [self stringWithMd5:password];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"updatePhone" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

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
 *  获取验证码
 */

- (void)getRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getSms" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

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
 *  完善司机信息
 *
 *  @param driverid 司机ID
 *  @param type     0
 *  @param realname 真实姓名
 *  @param idnumber 身份证号
 *  @param info     图片对象
 *  @param callback 返回结果
 */

-(void)perfectDriverInformation:(int)userId WithType:(int)type WithRealname:(NSString *)realName WithIdnumber:(NSString *)idCard
                       WithUserImgInfo:(UserImgInfo *)info callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:idCard forKey:@"idCard"];
    [params setValue:realName forKey:@"realName"];
    NSString *stId = [NSString stringWithFormat:@"%i",userId];
    [params setValue:idCard forKey:@"idCard"];
    [params setValue:stId forKey:@"userId"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"improvedUserInfo" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        if (info.idimagefront) {

            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.idimagefront,0.1)
                                        name:@"idCardImageFront"
                                    fileName:[self imgNameWith:@"idCardImageFront"]
                                    mimeType:@"image/jpg"];
        }

        if (info.idimageback) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.idimageback,0.1)
                                        name:@"idCardImageBack"
                                    fileName:[self imgNameWith:@"idCardImageBack"]
                                    mimeType:@"image/jpg"];
        }


        if (info.drivelicensefront) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.drivelicensefront,0.1)
                                        name:@"driverLicenseImage"
                                    fileName:[self imgNameWith:@"driverLicenseImage"]
                                    mimeType:@"image/jpg"];
        }

        if (info.certifiedfront) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.certifiedfront,0.1)
                                        name:@"certifiedImage"
                                    fileName:[self imgNameWith:@"certifiedImage"]
                                    mimeType:@"image/jpg"];
        }





    }] subscribeNext:^(id tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                self.userInfo.driverStatus = 1;

                [NSKeyedArchiver archiveRootObject:self.userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
                [[Toast shareToast]makeText:@"提交成功，等待审核" aDuration:1];
                callback(status);
            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
            [SVProgressHUD dismiss];

        }
    } error:^(NSError *error) {
        [[Toast shareToast]makeText:@"网络不好，上传超时，请删除大照片重试" aDuration:1];
        [SVProgressHUD dismiss];
        callback(nil);
    }];

}


/**
 *  拉取车辆类型
 *
 *  @param callback
 */
- (void)getCarMessagecallback:(void(^)(NSDictionary *dic))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getCarBasicData" forKey:@"method"];
    [self.dicHead setValue:@"vehicle" forKey:@"action"];

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
                    NSString *stdic = result[@"data"];
                    NSDictionary *dic = [self dictionaryWithJsonString:stdic];
                    NSArray *containerTypeList = dic[@"boxTypeMap"];
                    NSMutableArray *arrBox = [NSMutableArray new];
                    for (NSDictionary * dicInfo in containerTypeList) {
                        BoxInfoModel * info = [BoxInfoModel yy_modelWithJSON:dicInfo];
                        info.iden = [dicInfo[@"id"]intValue];
                        [arrBox addObject:info];
                    }
                    NSMutableArray *arrTruck = [NSMutableArray new];
                    NSArray *truckTypeList = dic[@"carTypeMap"];
                    for (NSDictionary * dicInfo in truckTypeList) {
                        CarInfoModel * info = [CarInfoModel yy_modelWithJSON:dicInfo];
                        info.baseid = [dicInfo[@"id"]intValue];
                        [arrTruck addObject:info];
                    }

                    NSMutableArray *arrTrainler = [NSMutableArray new];
                    NSArray *trainlerTypeList = dic[@"linkTypeMap"];
                    for (NSDictionary * dicInfo in trainlerTypeList) {
                        CarInfoModel * info = [CarInfoModel yy_modelWithJSON:dicInfo];
                        [arrTrainler addObject:info];
                    }

                    NSDictionary *dicmodel;
                    dicmodel  = @{@"trainlerTypeList":arrTrainler,@"truckTypeList":arrTruck,@"containerTypeList":arrBox};
                    callback(dicmodel);


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
 *  上传头像
 *
 *  @param driverid 用户ID
 *  @param avatar   头像图片
 *  @param callback 回调信息
 */

- (void)upUserAvatarwithId:(int)driverid withAvatar:(UIImage *)avatar callback:(void(^)(NSString *st))callback {
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    NSString *stId  = [NSString stringWithFormat:@"%i",driverid];
    [params setValue:[NSString stringWithFormat:@"%@",stId] forKey:@"userId"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"changeAvatar" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {


        if (avatar) {

            NSString *fileName = [NSString stringWithFormat:@"%@avatorImage",stId];
            NSData *data =[fileName dataUsingEncoding:NSUTF8StringEncoding];
            NSString *filejpgName = [NSString stringWithFormat:@"%@.jpg",data.base64Encoding];
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(avatar,0.1)
                                        name:@"avatorImage"
                                    fileName:filejpgName
                                    mimeType:@"image/jpg"];
        }
    }] subscribeNext:^(id tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                callback(status);
            }else {
                [[Toast shareToast]makeText:message aDuration:1];

            }

            [SVProgressHUD dismiss];

        }
    } error:^(NSError *error) {
        [[Toast shareToast]makeText:@"网络不好，上传超时，请删除大照片重试" aDuration:1];
        [SVProgressHUD dismiss];
        callback(nil);
    }];


}

/**
 *  注册
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        密码
 *  @param verifycode      验证码
 *  @param userbase        基地
 *  @param callback        抛出
 */
-(void)registerWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithUserbase:(NSString *)userbase callback:(void(^)(NSString *status))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:telephoneNumber forKey:@"phone"];
    [params setValue:verifycode forKey:@"verifycode"];
    [params setValue:userbase forKey:@"userbase"];

     NSString *stMd5 = [self stringWithMd5:passWord];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"register" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];




    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    NSLog(@"%@",st);
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        NSLog(@"%@",responseData);
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                [[Toast shareToast]makeText:@"注册成功" aDuration:1];
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
 *  重置密码
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        新密码
 *  @param verifycode      验证码
 *  @param idnumber        身份证号码
 *  @param callback        抛出
 */
-(void)resetPasswordWithPhone:(NSString *)telephoneNumber WithNewPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithIdnumber:(NSString *)idnumber callback:(void (^)(NSString *status))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:telephoneNumber forKey:@"phone"];
    [params setValue:verifycode forKey:@"verifyCode"];
    NSString *stMd5 = [self stringWithMd5:passWord];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"newPassword"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"resetPassword" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                [[Toast shareToast]makeText:@"修改密码成功" aDuration:1];
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
 *  添加车辆
 *
 *  @param model    车辆 model
 *  @param info     图片 info
 *  @param callback 返回状态
 */

-(void)perfectCarInformationWithCar:(CarInfoModel *)model WithUserImgInfo:(CarImgInfo *)info callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:model.code forKey:@"carNumber"];
    [params setValue:model.vehicle_type forKey:@"carType"];
    [params setValue:model.formCode forKey:@"tractorType"];
    [params setValue:model.boxType forKey:@"boxType"];
    [params setValue:model.carLenth forKey:@"vehicle_length"];
    //vehicleId
    [params setValue:@0 forKey:@"saveOrUpdate"];
    [params setValue:model.carWeight forKey:@"total_mass_trailer"];
    [params setValue:[NSString stringWithFormat:@"%i",self.userInfo.iden] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];


    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"addVehicle" forKey:@"method"];
    [self.dicHead setValue:@"vehicle" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        if (info.carlicensefront) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.carlicensefront,0.1)
                                        name:@"carLicenseFront"
                                    fileName:@"carLicense.jpg"
                                    mimeType:@"image/jpg"];
        }

        if (info.groupphoto) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.groupphoto,0.1)
                                        name:@"groupPhoto"
                                    fileName:@"groupPhoto.jpg"
                                    mimeType:@"image/jpg"];
        }


        if (info.truckoperator) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.truckoperator,0.1)
                                        name:@"truckOperator"
                                    fileName:@"truckOperator.jpg"
                                    mimeType:@"image/jpg"];
        }

    }] subscribeNext:^(id tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                [[Toast shareToast]makeText:@"已添加，请等待审核" aDuration:1];
                callback(@"成功");

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }

        }

        [SVProgressHUD dismiss];


    } error:^(NSError *error) {
        [[Toast shareToast]makeText:@"网络不好，上传超时，请删除大照片重试" aDuration:1];
        [SVProgressHUD dismiss];
        callback(nil);
    }];
}


/**
 *  获取车辆表
 *
 *  @param UserId 用户ID
 */

- (void)getCarListWithUserId:(int)UserId callback:(void(^)(NSArray *arr))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",UserId] forKey:@"userId"];

    UserInfoModel *us = USER_INFO;

    [params setValue:self.userInfo.driverId forKey:@"driverId"];
    if (us.userType == 1 || us.userType == 2) {

        [params setValue:us.company_id forKey:@"driverId"];
        
    }
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getVehicleList" forKey:@"method"];
    [self.dicHead setValue:@"vehicle" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                NSDictionary *result = response[@"result"];
                NSString *stdic = result[@"data"];
                NSDictionary *dic = [self dictionaryWithJsonString:stdic];
                NSArray *arrCar = dic[@"vehicleList"];
                NSMutableArray *callbackArr = [NSMutableArray array];
                for (NSDictionary *dicInfo in arrCar) {

                    CarInfoModel *model = [CarInfoModel yy_modelWithJSON:dicInfo];
                    NSString *basid = dicInfo[@"id"];
                    model.baseid = [basid intValue];
                    [callbackArr addObject:model];
                    
                }
                callback(callbackArr);

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
 *  绑定车辆
 *
 *  @param UserId 用户ID
 */

- (void)bindCarListWithUserId:(int)UserId withVehicleId:(int)vehicleId callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",UserId] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];
    [params setValue:[NSString stringWithFormat:@"%i",vehicleId] forKey:@"vehicleId"];
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"bindVehicle" forKey:@"method"];
    [self.dicHead setValue:@"vehicle" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

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
 *  获取绑定车辆
 *
 *  @param UserId 用户ID
 */

- (void)getBindCarListWithUserId:(int)UserId callback:(void(^)(CarInfoModel *info))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%i",UserId] forKey:@"userId"];
    [params setValue:self.userInfo.driverId forKey:@"driverId"];

    UserInfoModel *us = USER_INFO;
    if (us.userType == 1 || us.userType == 2) {

        [params setValue:us.company_id forKey:@"driverId"];

    }
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"getBindVehicle" forKey:@"method"];
    [self.dicHead setValue:@"vehicle" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                NSDictionary *result = response[@"result"];
                NSString *stdic = result[@"data"];
                NSDictionary *dic = [self dictionaryWithJsonString:stdic];
                NSDictionary *dicInfo = dic[@"vehicleInfo"];
                CarInfoModel *model = [CarInfoModel yy_modelWithJSON:dicInfo];
                NSString *basid = dicInfo[@"id"];
                model.baseid = [basid intValue];

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
 *  删除车辆
 *
 *  @param vehicleIds 车辆ID数组
 *  @param callback   返回状态
 */

- (void)delateCarWith:(NSArray *)vehicleIds callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:vehicleIds forKey:@"vehicleIds"];
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"deleteVehicle" forKey:@"method"];
    [self.dicHead setValue:@"vehicle" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

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
 *  检查更新
 *
 *  @param callback 返回结果
 */
-(void) checkEdition:(void(^)(CheckInfo *info))callback { 


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"versionCode"];
    [params setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"versionName"];
    [params setValue:@"1" forKey:@"platform"];
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"get_newVersion" forKey:@"method"];
    [self.dicHead setValue:@"checkVersion" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            //NSString *st1 = [self dictionaryToJson:response];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                NSDictionary *result = response[@"result"];
                NSString *stdic = result[@"data"];
                NSDictionary *dic = [self dictionaryWithJsonString:stdic];
                //NSString *hasNewVersion = dic[@"hasNewVersion"];
                NSDictionary *dicInfo = dic[@"versionInfo"];
                CheckInfo *info = [CheckInfo yy_modelWithJSON:dicInfo];
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
 *  更改基地
 *
 *  @param regionCode 城市code
 *  @param callback   返回结果
 */
-(void)resetRegionWith:(NSString *)regionCode callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:regionCode forKey:@"regionCode"];
    [self.dicHead setValue:@"resetRegion" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
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
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(status);
                [[Toast shareToast]makeText:@"修改成功" aDuration:1];
            }else{

                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

@end
