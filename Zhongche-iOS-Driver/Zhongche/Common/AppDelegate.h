//
//  AppDelegate.h
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "NSObject+YYModel.h"
#import <GTSDK/GeTuiSdk.h>
#import "PushModel.h"
#import "PushOrderView.h"
#import "UserOrderSqlite.h"
#import "PushEvaluateModel.h"
#import "EvaluateResultView.h"
#import "GetGeographicalPosition.h"
#import "UserInfoModel.h"
#import "CarInfoModel.h"
#import "UserInfoViewModel.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCEWCodeViewController.h"
#import "UserOrderSqlite.h"
#import "ZCMapViewController.h"
#import "LXYSoundPlayer.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "CheckInfo.h"
#import <SMS_SDK/SMSSDK.h>
#import "UMMobClick/MobClick.h"
#import "SendBreakdownView.h"
#import "ZCChangePayPWDViewController.h"
#import "PayPWDView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MLNavigationController *nav;
@property (nonatomic, assign) NSInteger index;//自定义Tabbar用来做页面改变时的状态变换
@property (nonatomic, assign) BOOL DeBug;
@end

