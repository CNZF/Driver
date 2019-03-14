//
//  AppDelegate.h
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "UIView+Frame.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImageView+WebCache.h"
#import "MyFilePlist.h"
#import "UserInfoModel.h"
#import "UserInfoViewModel.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "YMTextView.h"
#import "UIImage+getImage.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "KeyboardToolBar.h"
#import "UINavigationController+StackManager.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) NSString *stTelephone;
@property (nonatomic ,strong) MenuView               *menu;
@property (nonatomic, strong) LeftMenuViewDemo       *demo;
   
- (void)bindView;
- (void)bindModel;
- (void)bindAction;
- (void)onBackAction;
- (void)onRightAction;


//打电话
- (void)callAction;

- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//时间戳转时间格式字符串
- (NSString *)stDateToString:(NSString *)stDate;
//时间戳转时间格式字符串
- (NSString *)stDateToString1:(NSString *)stDate;
//时间戳转时间格式字符串
- (NSString *)stDateToString2:(NSString *)stDate;

//时间戳转时间格式字符串
- (NSString *)stDateAndTimToString:(NSString *)stDate;

//检查手机号
- (BOOL)checkPhoneWithPhone:(NSString *)Phone;

- (void) showAlertViewWithTitle:(NSString *)title WithMessage:(NSString *)message;

//计算两个坐标距离
- (float)distanceWithStartlat:(float)startlat WithStartlng:(float)startlng WithEndlat:(float)endlat WithEndlng:(float)endlng;

@end
