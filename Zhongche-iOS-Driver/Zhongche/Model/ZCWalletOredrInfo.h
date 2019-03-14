//
//  ZCWalletOredrInfo.h
//  Zhongche
//
//  Created by lxy on 2016/11/7.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface ZCWalletOredrInfo : BaseModel

/**
 *   
 "accountting_type" = T111;
 "after_trade_amount" = 500;
 "before_trade_amount" = 0;
 "create_date" = 1478499257000;
 "customer_account" = C0000000081;
 "customer_account_id" = 120;
 id = 1;
 remark = "\U5c0f\U80d6\U624e";
 seq = 1;
 "trade_amount" = 500;
 "trade_date" = 1478499216000;
 "trade_order_no" = BON2016110713515441200099;
 "update_time" = 1478499261000;

 */

@property (nonatomic, strong) NSString *accountting_type;
@property (nonatomic, strong) NSString *after_trade_amount;
@property (nonatomic, strong) NSString *before_trade_amount;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *customer_account;
@property (nonatomic, strong) NSString *customer_account_id;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *seq;
@property (nonatomic, strong) NSString *trade_amount;
@property (nonatomic, strong) NSString *trade_date;
@property (nonatomic, strong) NSString *trade_order_no;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *ID;

@end
