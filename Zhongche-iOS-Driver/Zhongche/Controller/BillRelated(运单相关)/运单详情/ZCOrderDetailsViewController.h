//
//  ZCOrderDetailsViewController.h
//  Zhongche
//
//  Created by lxy on 16/9/1.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "PushModel.h"

@interface ZCOrderDetailsViewController : BaseViewController

@property (nonatomic, strong) NSString  *willId;
@property (nonatomic, strong) NSString  *waybillStatus;
@property (nonatomic, strong) PushModel *pInfo;
@property (nonatomic, assign) int       type;

@end
