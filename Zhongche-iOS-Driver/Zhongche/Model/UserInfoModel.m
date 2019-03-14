//
//  UserInfoModel.m
//  Zhongche
//
//  Created by lxy on 16/7/13.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //调用NSCoder的方法归档该对象的每一个属性


    [aCoder encodeInt: _iden forKey:@"_iden"];
    [aCoder encodeInt: _userStatus forKey:@"_userStatus"];
    [aCoder encodeInt: _driverStatus forKey:@"_driverStatus"];
    [aCoder encodeInt: _identStatus forKey:@"_identStatus"];
    [aCoder encodeInt: _quaStatus forKey:@"_quaStatus"];
    [aCoder encodeInt: _userType forKey:@"_userType"];
    [aCoder encodeInt:_organization_id forKey:@"_organization_id"];
    



    [aCoder encodeObject:_login_name forKey:@"_login_name"];
    [aCoder encodeObject:_real_name forKey:@"_real_name"];
    [aCoder encodeObject:_phone forKey:@"_phone"];
    [aCoder encodeObject:_id_card_num forKey:@"_id_card_num"];
    [aCoder encodeObject:_id_card_url forKey:@"_id_card_url"];
    [aCoder encodeObject:_id_card_back_url forKey:@"_id_card_back_url"];
    [aCoder encodeObject:_region_code forKey:@"_region_code"];
    [aCoder encodeObject:_password forKey:@"_password"];
    [aCoder encodeObject:_driver_license_url forKey:@"_driver_license_url"];
    [aCoder encodeObject:_certificate_url forKey:@"_certificate_url"];
    [aCoder encodeObject:_token forKey:@"_token"];
    [aCoder encodeObject:_driverId forKey:@"_driverId"];
    [aCoder encodeObject:_auth_type forKey:@"_auth_type"];
    //icon  region_name
    [aCoder encodeObject:_region_name forKey:@"_region_name"];
    [aCoder encodeObject:_organization_name forKey:@"_organization_name"];
    [aCoder encodeObject:_icon forKey:@"_icon"];
    [aCoder encodeObject:_hasPayPassword forKey:@"_hasPayPassword"];
    [aCoder encodeObject:_company_id forKey:@"_company_id"];
    //hasPayPassword


}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
//        //使用NSCoder的方法从归档中依次恢复该对象的每一个属性
        _iden=[aDecoder decodeIntForKey:@"_iden"];
        _userStatus=[aDecoder decodeIntForKey:@"_userStatus"];
        _driverStatus=[aDecoder decodeIntForKey:@"_driverStatus"];
        _identStatus=[aDecoder decodeIntForKey:@"_identStatus"];
        _quaStatus=[aDecoder decodeIntForKey:@"_quaStatus"];
        _userType=[aDecoder decodeIntForKey:@"_userType"];
        _organization_id=[aDecoder decodeIntForKey:@"_organization_id"];


        _login_name=[[aDecoder decodeObjectForKey:@"_login_name"] copy];
        _real_name=[[aDecoder decodeObjectForKey:@"_real_name"] copy];
        _phone=[[aDecoder decodeObjectForKey:@"_phone"] copy];
        _id_card_num=[[aDecoder decodeObjectForKey:@"_id_card_num"] copy];
        _id_card_url=[[aDecoder decodeObjectForKey:@"_id_card_url"] copy];
        _id_card_back_url=[[aDecoder decodeObjectForKey:@"_id_card_back_url"] copy];
        _region_code=[[aDecoder decodeObjectForKey:@"_region_code"] copy];
        _password=[[aDecoder decodeObjectForKey:@"_password"] copy];
        _driver_license_url=[[aDecoder decodeObjectForKey:@"_driver_license_url"] copy];
        _certificate_url=[[aDecoder decodeObjectForKey:@"_certificate_url"] copy];
        _token=[[aDecoder decodeObjectForKey:@"_token"] copy];
        _driverId=[[aDecoder decodeObjectForKey:@"_driverId"] copy];
        _auth_type=[[aDecoder decodeObjectForKey:@"_auth_type"] copy];
        _organization_name=[[aDecoder decodeObjectForKey:@"_organization_name"] copy];
        _icon=[[aDecoder decodeObjectForKey:@"_icon"] copy];
        _region_name = [[aDecoder decodeObjectForKey:@"_region_name"] copy];
        _hasPayPassword = [[aDecoder decodeObjectForKey:@"_hasPayPassword"] copy];
        _company_id = [[aDecoder decodeObjectForKey:@"_company_id"] copy];
        //_company_id



    }
    return self;
}



@end
