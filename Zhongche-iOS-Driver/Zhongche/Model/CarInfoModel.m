//
//  CarInfoModel.m
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "CarInfoModel.h"

@implementation CarInfoModel

-(instancetype)init {

    self.dic = @{@"0":@"未提交材料",@"1":@"注册完成",@"2":@"车辆认证完成",@"3":@"车辆认证未通过"};
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //调用NSCoder的方法归档该对象的每一个属性


    [aCoder encodeInt: _status forKey:@"_status"];
    [aCoder encodeInt: _baseid forKey:@"_baseid"];
    [aCoder encodeInt: _auth_status forKey:@"_auth_status"];
    [aCoder encodeInt: _isActivite forKey:@"_isActivite"];
    [aCoder encodeInt: _vehicle_id forKey:@"_vehicle_id"];
    [aCoder encodeInt: _support_40gp forKey:@"_support_40gp"];



    [aCoder encodeObject:_name forKey:@"_name"];
    [aCoder encodeObject:_code forKey:@"_code"];
    [aCoder encodeObject:_vehicle_type forKey:@"_vehicle_type"];
    [aCoder encodeObject:_driver_id forKey:@"_driver_id"];
    [aCoder encodeObject:_vehicle_type_code forKey:@"_vehicle_type_code"];


}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        //        //使用NSCoder的方法从归档中依次恢复该对象的每一个属性
        _status = [aDecoder decodeIntForKey:@"_status"];
        _baseid = [aDecoder decodeIntForKey:@"_baseid"];
        _auth_status = [aDecoder decodeIntForKey:@"_auth_status"];
        _isActivite =[aDecoder decodeIntForKey:@"_isActivite"];
        _vehicle_id =[aDecoder decodeIntForKey:@"_vehicle_id"];
        _support_40gp =[aDecoder decodeIntForKey:@"_support_40gp"];


        _name=[[aDecoder decodeObjectForKey:@"_name"] copy];
        _code=[[aDecoder decodeObjectForKey:@"_code"] copy];
        _vehicle_type=[[aDecoder decodeObjectForKey:@"_vehicle_type"] copy];
        _driver_id=[[aDecoder decodeObjectForKey:@"_driver_id"] copy];
         _vehicle_type_code=[[aDecoder decodeObjectForKey:@"_vehicle_type_code"] copy];

    
    }
    return self;
}

@end
