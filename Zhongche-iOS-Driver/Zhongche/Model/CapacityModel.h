//
//  CapacityModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface CapacityModel : BaseModel
@property (nonatomic, assign) int award_price;
@property (nonatomic, copy) NSString * dispatch_end_time;
@property (nonatomic, copy) NSString * dispatch_start_time;
@property (nonatomic, assign) int driver_id;
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int standard_price;
@property (nonatomic, assign) int start_position_code;
@property (nonatomic, copy) NSString * start_position_name;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int truck_id;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int end_position_code;
@property (nonatomic, copy) NSString * end_position_name;
@property (nonatomic, assign) int awardPrice;
@property (nonatomic, copy) NSString *batchSequence;
@property (nonatomic, copy) NSString *buyTime;
@property (nonatomic, assign) int buyUserId;
@property (nonatomic, assign) int carrierUserId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *dispatchEndTime;
@property (nonatomic, copy) NSString *dispatchStartTime;
@property (nonatomic, assign) int driverId;
@property (nonatomic, copy) NSString * endPosition;
@property (nonatomic, assign) int isSamecity;
@property (nonatomic, copy) NSString *rejectReason;
@property (nonatomic, assign) int standardPrice;
@property (nonatomic, copy) NSString *startPosition;
@property (nonatomic, assign) int truckId;
@property (nonatomic, copy) NSString *line;
@end
