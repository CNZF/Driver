//
//  ZCTransportOrderModel.h
//  Zhongche
//
//  Created by lxy on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface ZCTransportOrderModel : BaseModel

/**
 {
 "billDetail": {
 "containerType": "20英尺通用集装箱",
 "end_region_code": "370100",
 "start_address": "广东省广州市越秀区广州火车站",
 "status": 3,
 "end_address": "山东省济南市天桥区济南火车站",
 "start_contacts_phone": "13341195865",
 "start_region_code": "440100",
 "end_contacts": "李先生",
 "goods_name": "无烟块煤",
 "end_contacts_phone": "15350708905",
 "start_contacts": "王先生",
 "order_id": 55,
 "type": 2,
 "endTime": 1473714000000,
 "startTime": 1473696000000,
 "end_region_name": "济南",
 "isWarning": 0,
 "will_id": 1363,
 "start_region_name": "广州"
 }
 }



 */

@property (nonatomic, assign) int      status;
@property (nonatomic, assign) int      type;
@property (nonatomic, assign) int      carrierStatus; //2正常  1 ，已经报警
@property (nonatomic, assign) float      price;
@property (nonatomic, assign) int      is_accept;
@property (nonatomic, assign) float    start_region_center_lat;
@property (nonatomic, assign) float    start_region_center_lng;
@property (nonatomic, assign) float    end_region_center_lat;
@property (nonatomic, assign) float    end_region_center_lng;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *order_code;
@property (nonatomic, strong) NSString *parentCode;




@property (nonatomic, strong  ) NSString * end_region_code;
@property (nonatomic, strong  ) NSString * start_address;
@property (nonatomic, strong  ) NSString *end_address;
@property (nonatomic, strong  ) NSString *start_contacts_phone;
@property (nonatomic, strong  ) NSString *start_region_code;
@property (nonatomic, strong  ) NSString *end_contacts;
@property (nonatomic, strong  ) NSString *end_contacts_phone;
@property (nonatomic, strong  ) NSString *start_contacts;
@property (nonatomic, strong  ) NSString *end_region_name;
@property (nonatomic, strong  ) NSString *waybill_id;
@property (nonatomic, strong  ) NSString *waybill_code;
@property (nonatomic, strong  ) NSString *start_region_name;
@property (nonatomic, strong  ) NSString *containerType;
@property (nonatomic, strong  ) NSString *goods_name;
@property (nonatomic, strong  ) NSString *container_code;
@property (nonatomic, strong  ) NSString *order_id;
@property (nonatomic, strong  ) NSString *waybill_carrier_id;



//调试用
@property (nonatomic, copy) NSString *startpoint;
@property (nonatomic, copy) NSString *endPoint;

//调试用
@property (nonatomic, strong) NSString *start_lat;
@property (nonatomic, strong) NSString *start_lng;
@property (nonatomic, strong) NSString *end_lat;
@property (nonatomic, strong) NSString *end_lng;





@end
