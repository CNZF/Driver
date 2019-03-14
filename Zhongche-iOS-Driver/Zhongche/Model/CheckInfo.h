//
//  CheckInfo.h
//  Zhongche
//
//  Created by lxy on 2016/9/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface CheckInfo : BaseModel

/**
 *  {
 \"code\": \"2\",
 \"createTime\": 1475045790000,
 \"createUserId\": 1,
 \"id\": 2,
 \"isForce\": 0,
 \"name\": \"1.2\",
 \"platform\": 1,
 \"remark\": \"\U6d4b\U8bd5\U66f4\U65b0\",
 \"status\": 0,
 \"updateContent\": \"\U4fee\U590d\U4e86\U8d85\U7ea7\U591a\U7684bug\",
 \"updateTime\": 1475045794000,
 \"updateUserId\": 1
 }
 */

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *createUserId;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *isForce;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *platform;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *updateContent;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *updateUserId;
@property (nonatomic, strong) NSString *url;



@end
