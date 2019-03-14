//
//  CarInfoModel.h
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface CarInfoModel : BaseModel
/**
 *  
 "id": 6,
 "vehicle_type": "牵引车",
 "vehicle_type_code": "TRUCK_TYPE_TRACTOR",
 "driver_id": 254,
 "code": "158",
 "isActivite": 0,
 "vehicle_id": 6


 */
@property (nonatomic, assign) int      baseid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *vehicle_type;
@property (nonatomic, strong) NSString *driver_id;
@property (nonatomic, assign) int      isActivite;
@property (nonatomic, assign) int      vehicle_id;
@property (nonatomic, assign) int      support_40gp;
@property (nonatomic, strong) NSString *formCode;
@property (nonatomic, strong) NSArray  *boxType;
@property (nonatomic, strong) NSString *carWeight;
@property (nonatomic, strong) NSString *carLenth;
@property (nonatomic, assign) int      selected;
@property (nonatomic, assign) int      status;
@property (nonatomic, assign) int      auth_status;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSString *vehicle_type_code;


@end
