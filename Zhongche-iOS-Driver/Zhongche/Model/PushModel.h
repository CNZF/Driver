//
//  PushModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/8/9.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface PushModel : BaseModel

/**
 *   "containerType": "20英尺通用集装箱",
 "capacity_apply_order_id": 37,
 "end_region_code": "370100",
 "start_address": "广东省广州市越秀区广州火车站",
 "end_address": "山东省济南市天桥区济南火车站",
 "start_contacts_phone": "13341195865",
 "start_region_code": "440100",
 "end_contacts": "李先生",
 "goods_name": "无烟块煤",
 "end_contacts_phone": "15350708905",
 "start_region": "广州",
 "start_contacts": "王先生",
 "endTime": 1473714000000,
 "type": 2, 1. 派单; 2. 抢单 ; 3. 外采',
 "waybill_group_id": 483,
 "waybillId": 1367,
 "startTime": 1473696000000,
 "end_region": "济南"
 "end_region_center_lat" = "39.084158";
 "end_region_center_lng" = "117.200983";
 "start_region_center_lat" = "39.90403";
 "start_region_center_lng" = "116.407526";
 */


@property (nonatomic, assign  ) int      capacity_apply_order_id;
@property (nonatomic, assign  ) int      type;// 1. 派单; 2. 抢单 ; 3. 外采',
@property (nonatomic, assign  ) int      waybillId;
@property (nonatomic, assign  ) int      waybill_group_id;
@property (nonatomic, assign  ) int      price;
@property (nonatomic, assign  ) float    start_region_center_lat;
@property (nonatomic, assign  ) float    start_region_center_lng;
@property (nonatomic, assign  ) float    end_region_center_lat;
@property (nonatomic, assign  ) float    end_region_center_lng;
@property (nonatomic, assign  ) float    distance;
@property (nonatomic, strong  ) NSString *containerType;
@property (nonatomic, strong  ) NSString *endTime;
@property (nonatomic, strong  ) NSString *end_address;
@property (nonatomic, strong  ) NSString *end_contacts;
@property (nonatomic, strong  ) NSString *end_contacts_phone;
@property (nonatomic, strong  ) NSString *end_region;
@property (nonatomic, strong  ) NSString *end_region_code;
@property (nonatomic, strong  ) NSString *goods_name;//2016-05-06
@property (nonatomic, strong  ) NSString *startTime;//2016-05-06
@property (nonatomic, strong  ) NSString *start_address;
@property (nonatomic, strong  ) NSString *start_contacts;
@property (nonatomic, strong  ) NSString *start_contacts_phone;
@property (nonatomic, strong  ) NSString *start_region;//新加字段 货物名称
@property (nonatomic, strong  ) NSString *start_region_code;//新加字段 货物尺寸


//调试用
//@property (nonatomic, copy) NSString *startpoint;
//@property (nonatomic, copy) NSString *endPoint;

@end
