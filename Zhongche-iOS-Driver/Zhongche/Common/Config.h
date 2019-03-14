//
//  Header.h
//  Leyijia
//
//  Created by Apple on 16/6/6.
//  Copyright © 2016年 shengtaiquan. All rights reserved.
//

#ifndef Header_h

#import "HelperUtil.h"

/**
 *  输出测试
 */
#ifdef DEBUG
#define NSLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NSLog(s, ... )
#endif

#define Header_h


#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W_COEFFICIENT [UIScreen mainScreen].bounds.size.width / 414
#define SCREEN_H_COEFFICIENT [UIScreen mainScreen].bounds.size.height / 736


//////////////////////////////////////////////////////////////////////////////////////////////////
// 服务
//////////////////////////////////////////////////////////////////////////////////////////////////


#define APP_CUSTOMER_SERVICE                      @"4009006667"


//////////////////////////////////////////////////////////////////////////////////////////////////
// 颜色
//////////////////////////////////////////////////////////////////////////////////////////////////

#define APP_COLOR_WHITEBG                       [HelperUtil colorWithHexString:@"F5F5F5"]       //白色背景


#define APP_COLOR_BLUE                          [HelperUtil colorWithHexString:@"1cb0ee"]       //蓝色背景

#define APP_COLOR_GRAY_TEXT                     [HelperUtil colorWithHexString:@"9e9e9e"]       //灰色字体背景
#define APP_COLOR_GRAY_TEXT1                     [HelperUtil colorWithHexString:@"c2c2c2"]       //灰色字体背景

#define APP_COLOR_GRAY_LINE                     [HelperUtil colorWithHexString:@"e8e8e8"]       //灰色字体背景
#define APP_COLOR_ORANGR                        [HelperUtil colorWithHexString:@"fb711e"]       //橘黄色
#define APP_COLOR_ORANGR1                       [HelperUtil colorWithHexString:@"dcb285"]       //橘黄色
#define APP_COLOR_ORANGR2                       [HelperUtil colorWithHexString:@"ce9032"]       //橘黄色
#define APP_COLOR_PURPLE                        [HelperUtil colorWithHexString:@"2c3e61"]       //紫色
#define APP_COLOR_PURPLE1                       [HelperUtil colorWithHexString:@"202f4d"]       //紫色
#define APP_COLOR_PHOTOGRAY                     [HelperUtil colorWithHexString:@"EEEFF0"]       //灰色
#define APP_COLOR_ALERTE                        [HelperUtil colorWithHexString:@"E9E9E9"]       //弹框



//////////////////////////////////////////////////////////////////////////////////////////////////
// 网络配置
//////////////////////////////////////////////////////////////////////////////////////////////////

#define RETRIES     0
#define INTERVAL    1000000000
#define IMGINTERVAL 1000000000

#define MESSAGE_APP_KEY @"1784a8e6e4af4"
#define MESSAGE_APP_SECRET @"04afbd463ebc50c7e933bf3cb4396048"

#define YMKEY     @"57eb655967e58ea5ae000c5e"


#define LOADING     @"加载中..."
#define BUSY        @"服务器繁忙..."

//网络请求状态码
#define REQUESTSUCCESS        @"10000"



// 测试打包环境
#define BASEURL        @"http://192.168.1.220:8088"
#define BASEIMGURL     @"http://192.168.1.220:8082"



//#define BASEURL     @"http://192.168.1.126:8080"
//#define BASEURL     @"http://192.168.1.111:8080"


//#define BASEURL      @"http://www.unitransdata.com:8088"
//#define BASEIMGURL     @"http://www.unitransdata.com:8082"



//57eb655967e58ea5ae000c5e


#define CHILEDURL   @"/apprest/exec/"
////////////////////////////////////////////////////////////////////////////////////////////////
// 通知中心
///////////////////////////////////////////////////////////////////////////////////////////////////
#define NOTIFICATION_SYSTEM_VIEW_LOADDATA @"systemServerNotification"

//////////////////////////////////////////////////////////////////////////////////////////////////
// 对象归档
//////////////////////////////////////////////////////////////////////////////////////////////////

#define USER_INFO (UserInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]]
#define CAR_INFO (CarInfoModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]]

/**
 *  weakself
 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;



#endif /* Header_h */
