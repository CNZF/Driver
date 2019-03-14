//
//  UserInfoViewModel.h
//  Zhongche
//
//  Created by lxy on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "UserInfoModel.h"
#import "UserImgInfo.h"
#import "CarImgInfo.h"
#import "CarInfoModel.h"
#import "CheckInfo.h"

@interface UserInfoViewModel : BaseViewModel


/**
 *  登录
 *
 *  @param telephoneNumber 手机号
 *  @param passWord        密码
 *  @param callback        登录用户对象
 */

-(void)loginWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord callback:(void(^)(UserInfoModel *userInfo))callback;


/**
 *  获取用户信息
 */

-(void)getUserInfoWithUserId:(void(^)(UserInfoModel *userInfo))callback;

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
-(void)perfectDriverInformation:(int)driverid WithType:(int)type WithRealname:(NSString *)realname WithIdnumber:(NSString *)idnumber
                WithUserImgInfo:(UserImgInfo *)info callback:(void(^)(NSString *st))callback;

/**
 *  更改手机号
 */

- (void)changePhoneWithPhone:(NSString *)phone WithVerifyCode:(NSString *)verifyCode WithPassword:(NSString *)password callback:(void(^)(NSString *st))callback;

/**
 *  获取验证码
 */

- (void)getRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback;

/**
 *  添加车辆
 *
 *  @param model    车辆 model
 *  @param info     图片 info
 *  @param callback 返回状态
 */
-(void)perfectCarInformationWithCar:(CarInfoModel *)model WithUserImgInfo:(CarImgInfo *)info callback:(void(^)(NSString *st))callback;

/**
 *  车辆信息--车辆类型，拖挂类型，箱型箱类
 */
- (void)getCarMessagecallback:(void(^)(NSDictionary *dic))callback;

/**
 *  上传头像
 *
 *  @param driverid 用户ID
 *  @param avatar   头像图片
 *  @param callback 回调信息
 */

- (void)upUserAvatarwithId:(int)driverid withAvatar:(UIImage *)avatar callback:(void(^)(NSString *st))callback;

/**
 *  注册
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        密码
 *  @param verifycode      验证码
 *  @param userbase        基地
 *  @param callback        抛出
 */
-(void)registerWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithUserbase:(NSString *)userbase callback:(void(^)(NSString *status))callback;

/**
 *  重置密码
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        新密码
 *  @param verifycode      验证码
 *  @param idnumber        身份证号码
 *  @param callback        抛出
 */
-(void)resetPasswordWithPhone:(NSString *)telephoneNumber WithNewPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithIdnumber:(NSString *)idnumber callback:(void (^)(NSString *status))callback;

/**
 *  获取车辆表
 *
 *  @param UserId 用户ID
 */

- (void)getCarListWithUserId:(int)UserId callback:(void(^)(NSArray *arr))callback;

/**
 *  绑定车辆
 *
 *  @param UserId 用户ID
 */

- (void)bindCarListWithUserId:(int)UserId withVehicleId:(int)vehicleId callback:(void(^)(NSString *st))callback;

/**
 *  获取绑定车辆表
 *
 *  @param UserId 用户ID
 */

- (void)getBindCarListWithUserId:(int)UserId callback:(void(^)(CarInfoModel *info))callback;

/**
 *  删除车辆
 *
 *  @param vehicleIds 车辆ID数组
 *  @param callback   返回状态
 */

- (void)delateCarWith:(NSArray *)vehicleIds callback:(void(^)(NSString *st))callback;

/**
 *  检查更新
 *
 *   @param callback   返回结果
 */

-(void) checkEdition:(void(^)(CheckInfo *info))callback;


/**
 *  更改基地
 *
 *  @param regionCode 城市code
 *  @param callback   返回结果
 */
-(void)resetRegionWith:(NSString *)regionCode callback:(void(^)(NSString *st))callback;

@end
