//
//  OrderDetailsHomeViewController.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "PushModel.h"
#import "ZCTransportOrderModel.h"

@interface OrderDetailsHomeViewController : BaseViewController
@property (nonatomic, strong) NSString  *willId;
@property (nonatomic, strong) NSString  *waybillStatus;
@property (nonatomic, strong) PushModel *pInfo;
@property (nonatomic, strong) ZCTransportOrderModel * model;
@property (nonatomic, assign) int       type;

@end
