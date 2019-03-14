//
//  ConfirmLoadAlertController.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/7/6.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTransportOrderModel.h"

typedef void(^Completion)(BOOL success);

@interface ConfirmLoadAlertController : UIAlertController

@property (nonatomic, copy) Completion successBlock;

+ (instancetype)alertWithModel:(ZCTransportOrderModel *)model  target:(UIViewController *)target completion:(void(^)(BOOL success))completion;

@end
