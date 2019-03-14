//
//  UserInfoModel.h
//  Zhongche
//
//  Created by lxy on 16/7/13.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property (nonatomic, assign) int      userPoints;
@property (nonatomic, assign) int      iden;
@property (nonatomic, assign) int      userStatus;
@property (nonatomic, assign) int      driverStatus;
@property (nonatomic, assign) int      identStatus;//身份认证状态
@property (nonatomic, assign) int      type;//
@property (nonatomic, assign) int      quaStatus;//资质认证状态
@property (nonatomic, assign) int      userType;//1或者2查询车辆列表传organization_id
@property (nonatomic, assign) int      organization_id;

@property (nonatomic, strong) NSString *login_name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *id_card_num;
@property (nonatomic, strong) NSString *id_card_url;
@property (nonatomic, strong) NSString *id_card_back_url;
@property (nonatomic, strong) NSString *region_code;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *driver_license_url;
@property (nonatomic, strong) NSString *certificate_url;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *driverBaseName;
@property (nonatomic, strong) NSString *vehicle_code;
@property (nonatomic, strong) NSString *driverId;
@property (nonatomic, strong) NSString *auth_type;
@property (nonatomic, strong) NSString *organization_name;//用户信息添加公司名称
@property (nonatomic, strong) NSString *region_name;
@property (nonatomic, strong) NSString *hasPayPassword;
@property (nonatomic, strong) NSString *company_id;

/**
 *  '0真实姓名
 1身份证正面照
 2身份证反面照 ',
 */
/**
 *  '1驾驶证
 2货运从业资格证', 3货车合影
 */

// 1 : 注册完成2 : 车辆认证完成 3 : 车辆认证未通过
/**
 *  '0真实姓名
 1身份证正面照
 2身份证反面照 ',
 */
@property (nonatomic, strong) NSString *identFailReson;//身份认证失败原因s
@property (nonatomic, strong) NSString *quaFailReson;//资质认证失败原因


/**
 *  driverBaseName
 vehicle_code;
 userPoints
 */




@end
