//
//  AppDelegate+Share.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/6/4.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "AppDelegate.h"
#import <GTSDK/GeTuiSdk.h>
@interface AppDelegate (Share)<GeTuiSdkDelegate>

- (void)setShareSDKInfomation;
- (void)setGeTuiSDKInfomation;
- (void)registerRemoteNotification;
@end
