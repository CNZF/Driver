//
//  personHomeHeadView.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface personHomeHeadView : UIView

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UserInfoModel *info;

- (void)getControllerWith:(id)target;

@end
