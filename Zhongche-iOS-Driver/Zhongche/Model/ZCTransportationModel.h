//
//  ZCTransportationModel.h
//  Zhongche
//
//  Created by lxy on 16/9/5.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"
#import "CarInfoModel.h"

@interface ZCTransportationModel : BaseModel


@property (nonatomic, strong) NSString     *startRegionCode;
@property (nonatomic, strong) NSString     *startRegionName;
@property (nonatomic, strong) NSString     *endRegionCode;
@property (nonatomic, strong) NSString     *endRegionName;
@property (nonatomic, strong) CarInfoModel *carInfo;


/**
 code = "ec29391b-243b-4460-b289-11dbc3de28e3";
 endCode = 130600;
 endName = "\U6cb3\U5317\U7701\U4fdd\U5b9a\U5e02";
 id = 11;
 price = 1000;
 startCode = 520400;
 startName = "\U8d35\U5dde\U7701\U5b89\U987a\U5e02";
 startTime = 1473782400000;
 status = 0;
 vehicleCode = "\U4eac124578";
 */


/**
 "endCode": "130600",
 "startCode": "520400",
 "startTime": 1473782400000,
 "id": 11,
 "startName": "贵州省安顺市",
 "price": 1000,
 "status": 0,
 "vehicleCode": "京124578",
 "endName": "河北省保定市",
 "code": "ec29391b-243b-4460-b289-11dbc3de28e3"
 */

/**
 *  新版本
 */
@property (nonatomic, strong) NSString *endCode;
@property (nonatomic, strong) NSString *startCode;
@property (nonatomic, assign) int      iden;
@property (nonatomic, strong) NSString *startName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) int      status;
@property (nonatomic, strong) NSString *vehicleCode;
@property (nonatomic, strong) NSString *endName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *contacts_name;
@property (nonatomic, strong) NSString *contacts_phone;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) int order_status;//0-已发布，1-待付款，2-付款审核，3-待收货，4-已完成，5-待退款，6-已取消

@property (nonatomic, strong) NSString *vehicleType;


@end
