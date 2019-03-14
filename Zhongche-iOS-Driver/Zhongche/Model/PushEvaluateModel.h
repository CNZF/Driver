//
//  PushEvaluateModel.h
//  Zhongche
//
//  Created by lxy on 16/8/10.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface PushEvaluateModel : BaseModel

/**
 *   awardPrice = 10;
 batchSequence = "";
 buyTime = "2016-08-10 13:50:55";
 buyUserId = 1;
 carrierUserId = 0;
 createTime = "2016-07-28 09:48:02";
 dispatchEndTime = "2016-07-28 00:00:00";
 dispatchStartTime = "2016-07-28 00:00:00";
 driverId = 27;
 endPosition = "";
 id = 269;
 isSamecity = 0;
 rejectReason = "";
 standardPrice = 200;
 startPosition = 110100;
 status = 2;
 truckId = 31;
 type = 1;
 */

@property (nonatomic, assign) int      awardPrice;
@property (nonatomic, strong) NSString *batchSequence;
@property (nonatomic, strong) NSString *buyTime;
@property (nonatomic, assign) int      buyUserId;
@property (nonatomic, assign) int      carrierUserId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *dispatchEndTime;
@property (nonatomic, strong) NSString *dispatchStartTime;
@property (nonatomic, assign) int      driverId;
@property (nonatomic, strong) NSString *endPosition;
@property (nonatomic, assign) int      iden;
@property (nonatomic, assign) int      isSamecity;
@property (nonatomic, strong) NSString *rejectReason;
@property (nonatomic, assign) int      standardPrice;
@property (nonatomic, assign) int      startPosition;
@property (nonatomic, assign) int      status;
@property (nonatomic, assign) int      truckId;
@property (nonatomic, assign) int      type;


@end
