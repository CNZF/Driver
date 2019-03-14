//
//  AppDelegate.m
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Share.h"
#import "UpCIDViewModel.h"
#import "AdView.h"
#import "ZCGuidePageView.h"
#define PUSHORDERVIEWTAG   100

//项目更改后采用StoryBoard搭建界面 --》别问为什么个人习惯

/// 需要使用个推回调时，需要添加"GeTuiSdkDelegate"
@interface AppDelegate ()<GeTuiSdkDelegate ,IFlySpeechSynthesizerDelegate,UIAlertViewDelegate,ZCGuidePageViewDelegate> {
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
}

@property (nonatomic, strong) PushModel *pushModel;
@property (nonatomic, strong) CheckInfo *checkInfo;
@property (nonatomic, assign) BOOL      isShow;
@property (nonatomic, strong) UIView    *viewBack;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     [NSThread sleepForTimeInterval:2.0];
    
    self.index = 0;
    self.DeBug = YES;
    //创建定位  申请定位权限
    [GetGeographicalPosition shareGetGeographicalPosition];
    
    _window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   
    LoginViewController * controller = [[UIStoryboard storyboardWithName:@"Person" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    _nav=[[MLNavigationController alloc] initWithRootViewController:controller];

    _nav.canDragBack = NO;
    
    //设置导航条背景图片
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <7.0)
    {
        [_nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [_nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //设置导航条字体颜色
    
    [_nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
  
    self.window.rootViewController = _nav;
    [_window makeKeyAndVisible];
    
    
    
    NSUserDefaults * appdict = [NSUserDefaults standardUserDefaults];
    if (![appdict objectForKey:@"bootRecordForVersion:1.0"])
    {
       ZCGuidePageView * gudiePageView = [[ZCGuidePageView alloc]init];
       gudiePageView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
       gudiePageView.delegate = self;
       [self.window addSubview:gudiePageView];
         [appdict setObject:@YES forKey:@"bootRecordForVersion:1.0"];
    }else{
        AdView * adView = [[AdView alloc] init];
        adView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self.window addSubview:adView];
    }
   
//    self.navigationController.navigationBar.hidden = YES;
//    ZCGuidePageView * gudiePageView = [[ZCGuidePageView alloc]init];
//    gudiePageView.delegate = self;
   
    
    if (USER_INFO) {
        [self refreshInfo];
    }
//三方配置
    [self setShareSDKInfomation];
    [self setGeTuiSDKInfomation];
    [self registerRemoteNotification];
    NSString *clientid = [GeTuiSdk clientId];
    [[NSUserDefaults standardUserDefaults] setObject:clientid forKey:@"GeTuiCID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    //语音云
    //Appid是应用的身份信息,具有唯一性,初始化时必须要传入Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"57dcf3b9"];
    [IFlySpeechUtility createUtility:initString];

    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate =self;

    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"1784a8e6e4af4"
             withSecret:@"04afbd463ebc50c7e933bf3cb4396048"];


    UMConfigInstance.appKey = YMKEY;
    UMConfigInstance.channelId = @"App Store";

    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！

    return YES;
}
- (void)guidePageViewEnd:(UIView *)guidePageView
{
    [guidePageView removeFromSuperview];
    AdView * adView = [[AdView alloc] init];
    adView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.window addSubview:adView];
    //    self.navigationController.navigationBar.hidden = NO;
   
}
//- (BOOL)application:(UIApplication *)application
//      handleOpenURL:(NSURL *)url {
//    return [ShareSDK handleOpenURL:url
//                        wxDelegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [ShareSDK handleOpenURL:url
//                 sourceApplication:sourceApplication
//                        annotation:annotation
//                        wxDelegate:self];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; // 标签
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",content);
    /**
     *  {
     data =     {
     "capacity_apply_order_id" = 25;
     containerType = "20\U82f1\U5c3a\U901a\U7528\U96c6\U88c5\U7bb1";
     endTime = 1473368400000;
     "end_address" = "\U5e7f\U4e1c\U7701\U6c55\U5934\U5e02\U9f99\U6e56\U533a\U5317\U706b\U8f66\U7ad9";
     "end_contacts" = "";
     "end_contacts_phone" = "";
     "end_region" = "\U6c55\U5934";
     "end_region_code" = 440500;
     "goods_name" = "\U70bc\U7126\U7cbe\U7164";
     startTime = 1473350400000;
     "start_address" = "\U5e7f\U4e1c\U7701\U97f6\U5173\U5e02\U6d48\U6c5f\U533a\U4e1c\U706b\U8f66\U7ad9";
     "start_contacts" = "";
     "start_contacts_phone" = "";
     "start_region" = "\U97f6\U5173";
     "start_region_code" = 440200;
     type = 2;
     waybillId = 1299;
     
     "end_region_center_lat" = "39.084158";
     "end_region_center_lng" = "117.200983";
     "start_region_center_lat" = "39.90403";
     "start_region_center_lng" = "116.407526";
     };
     type = 0;
     }
     */
   
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"BillHomeRefreshData" object:self userInfo:nil];
    
    PayPWDView *pview  = [PayPWDView sharePushOrderView];
    [pview removeFromSuperview];

    if (USER_INFO && !self.isShow) {

        NSDictionary *dicData = content[@"data"];
        if ([dicData[@"type"]intValue] == 2) {

            UIWindow *window = [UIApplication sharedApplication].keyWindow;

            self.pushModel = [PushModel yy_modelWithDictionary:content[@"data"]];
            float distance = [self distanceWithStartlat:self.pushModel.start_region_center_lat WithStartlng:self.pushModel.start_region_center_lng WithEndlat:self.pushModel.end_region_center_lat WithEndlng:self.pushModel.end_region_center_lng];
            

            self.pushModel.distance = distance;
            NSString * dayweather =[NSString stringWithFormat:@"收到抢单，起点%@，终点%@，出发时间%@",self.pushModel.start_region,self.pushModel.end_region,[self stDateAndTimToString:self.pushModel.startTime]];
            //
            //        LXYSoundPlayer *sound=[LXYSoundPlayer soundPlayerInstance];
            //
            //        [sound play:dayweather];

            //2.设置合成参数
            //设置在线工作方式
            [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                          forKey:[IFlySpeechConstant ENGINE_TYPE]];
            //音量,取值范围 0~100
            [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]]; //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
            [_iFlySpeechSynthesizer setParameter:@" vixq" forKey: [IFlySpeechConstant VOICE_NAME]]; //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
            [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
            //3.启动合成会话
            [_iFlySpeechSynthesizer startSpeaking: dayweather];



            PushOrderView *view = [PushOrderView sharePushOrderView];
            view.model = self.pushModel;
            view.tag = PUSHORDERVIEWTAG;
            view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);


            [window addSubview:view];
            self.isShow = YES;


            [view.btnOverLook addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [view.btnPlunder addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
            [view.btnCancle addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
            [view.btnCancle1 addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        }else{


            UIWindow *window = [UIApplication sharedApplication].keyWindow;

            self.pushModel = [PushModel yy_modelWithDictionary:content[@"data"]];
            float distance = [self distanceWithStartlat:self.pushModel.start_region_center_lat WithStartlng:self.pushModel.start_region_center_lng WithEndlat:self.pushModel.end_region_center_lat WithEndlng:self.pushModel.end_region_center_lng];

            self.pushModel.distance = distance;
            NSDictionary *dic = content[@"data"];
            self.pushModel.waybillId = [dic[@"waybill_id"]intValue];


            NSString * dayweather =[NSString stringWithFormat:@"收到任务，起点%@，终点%@，出发时间%@",self.pushModel.start_region,self.pushModel.end_region,[self stDateAndTimToString:self.pushModel.startTime]];
            //
            //        LXYSoundPlayer *sound=[LXYSoundPlayer soundPlayerInstance];
            //
            //        [sound play:dayweather];

            //2.设置合成参数
            //设置在线工作方式
            [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                          forKey:[IFlySpeechConstant ENGINE_TYPE]];
            //音量,取值范围 0~100
            [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]]; //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
            [_iFlySpeechSynthesizer setParameter:@" vixq" forKey: [IFlySpeechConstant VOICE_NAME]]; //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
            [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
            //3.启动合成会话
            [_iFlySpeechSynthesizer startSpeaking: dayweather];



            PushOrderView *view = [PushOrderView sharePushOrderView];
            view.model = self.pushModel;
            view.tag = PUSHORDERVIEWTAG;
            view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
            [view.btnPlunder setTitle:@"确认" forState:UIControlStateNormal];
            [view.btnOverLook setTitle:@"拒绝" forState:UIControlStateNormal];
            view.lbType.text = @"任务";
            view.ivStyle.image = [UIImage imageNamed:@"renwu"];
            view.lbPrice.hidden = YES;


            [window addSubview:view];
            self.isShow = YES;




            [view.btnOverLook addTarget:self action:@selector(refuseAction) forControlEvents:UIControlEventTouchUpInside];
            [view.btnPlunder addTarget:self action:@selector(btnCanterAction) forControlEvents:UIControlEventTouchUpInside];
            [view.btnCancle addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
            [view.btnCancle1 addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        }

    }
}

- (void)btnCanterAction {
//centerOrderWithIsAccept
    WS(ws);
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"BillHomeRefreshData" object:self userInfo:nil];
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    [vm centerOrderWithIsAccept:1 WithWaybillId:[NSString stringWithFormat:@"%i",self.pushModel.waybillId] callback:^(NSString *st) {

        UIViewController *vc = [self getCurrentVC];
        [vc.navigationController popToRootViewControllerAnimated:YES];
        [ws leftBtnAction];
    }];
}

- (void)refuseAction {
    [[Toast shareToast]makeText:@"无法拒绝，请联系管理员" aDuration:1];
    [self leftBtnAction];
}

- (void)rightAction {

    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UserInfoModel *userInfo = USER_INFO;
    if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {

        WS(ws);
        [vm receiveOrderWithPushModel:self.pushModel callback:^(NSString *st) {
            PushOrderView *view = [PushOrderView sharePushOrderView];
            [view removeFromSuperview];
              [_iFlySpeechSynthesizer stopSpeaking];
            ws.isShow = NO;

            if ([st isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"已抢单" aDuration:1];

            }

            
        }];

    }else {
        [[Toast shareToast]makeText:@"资料审核中，暂时无法抢单" aDuration:1];
    }

}

- (void)leftBtnAction {

    PushOrderView *view = [PushOrderView sharePushOrderView];
    [view removeFromSuperview];
    [_iFlySpeechSynthesizer stopSpeaking];
    self.isShow = NO;
}

- (void)saveAction {

    if(self.pushModel.type == 2) {

        UserOrderSqlite *model = [UserOrderSqlite shareUserOrderSqlite];
        [model increaseOneOrderData:self.pushModel];

    }

    [self leftBtnAction];
    
}

- (void)notifyTheChildViewsWithDictionary:(NSDictionary *)dict {
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SYSTEM_VIEW_LOADDATA object:nil userInfo:dict];
}


//拉取当前用户和车辆

- (void)refreshInfo {


    UserInfoModel *userinfo  = USER_INFO;
    UserInfoViewModel *vm = [UserInfoViewModel new];


    [vm getBindCarListWithUserId:[userinfo.driverId intValue] callback:^(CarInfoModel *info) {

        [NSKeyedArchiver archiveRootObject:info toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];

    }];



    [vm getUserInfoWithUserId:^(UserInfoModel *userInfo) {

        if (userInfo) {
            
            NSString * CID = [[NSUserDefaults standardUserDefaults] objectForKey:@"GeTuiCID"];
            if (CID) {
                [self upDateCIDWith:CID];
            }
             [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
        }else {


            UserInfoModel *us = nil;
            [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];

            CarInfoModel *car = nil;

            [NSKeyedArchiver archiveRootObject:car toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];

            UIViewController *vc = [self getCurrentVC];
            [vc.navigationController popToRootViewControllerAnimated:YES];
            [[Toast shareToast]makeText:@"用户登录过期，请重新登录" aDuration:1];
        }


    }];

  

    UserOrderSqlite *model = [UserOrderSqlite shareUserOrderSqlite];
    NSArray *arr = [model selectAllOrderData];

    for (PushModel *info in arr) {

        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[info.endTime longLongValue]/1000];
        NSDate *currentDate = [NSDate date];//获取当前时间，日期

        if ([date earlierDate:currentDate] == date) {

            [model deleteOneOrderData:info];
            NSArray *arr1 = [model selectAllOrderData];
            NSLog(@"%lu",(unsigned long)arr1.count);



        }
    }



}

//更新CID

- (void)upDateCIDWith:(NSString *)cid
{
    UpCIDViewModel * vm = [UpCIDViewModel new];
    [vm upDateCIDWith:cid];
}

//合成开始
- (void) onSpeakBegin{


}

//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{


}

- (void) onCompleted:(IFlySpeechError *) error{
}

- (void) onSpeakProgress:(int) progress{
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

}

//时间戳转时间格式字符串
- (NSString *)stDateAndTimToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日 hh时mm分"];
    return [outputFormatter stringFromDate:date];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.checkInfo.url]];

    }
    if (buttonIndex == 0) {
        if ([self.checkInfo.isForce intValue] == 0) {

            [self.viewBack removeFromSuperview];

        }
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {

    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

//计算两个坐标距离
- (float)distanceWithStartlat:(float)startlat WithStartlng:(float)startlng WithEndlat:(float)endlat WithEndlng:(float)endlng{

    CLLocation *orig=[[CLLocation alloc] initWithLatitude:startlat  longitude:startlng];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:endlat longitude:endlng];
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}

@end
