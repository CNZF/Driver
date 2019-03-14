//
//  GetGeographicalPosition.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/17.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "GetGeographicalPosition.h"
#import "UploadPositionViewModel.h"
#import "UserInfoModel.h"
#import "MyFilePlist.h"
//定义一个静态变量用于接收实例对象，初始化为nil
static GetGeographicalPosition *getGeographical=nil;
@interface GetGeographicalPosition()<CLLocationManagerDelegate>

@property (nonatomic, strong)  CLLocationManager *locationManager;

@end

@implementation GetGeographicalPosition

#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsIOS7Later                         !(IOSVersion < 7.0)
#define IsIOS8Later                         !(IOSVersion < 8.0)
+(GetGeographicalPosition *)shareGetGeographicalPosition{
    @synchronized(self){//线程保护，增加同步锁
        if (getGeographical==nil) {
            getGeographical=[[self alloc] init];
        }
    }
    return getGeographical;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        }
        _locationManager = [[CLLocationManager alloc]init];
        //如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined &&IsIOS8Later){
            [_locationManager requestWhenInUseAuthorization];
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = 5.0;
        }
    }
    return self;
}
- (void)start
{
    [_locationManager startUpdatingLocation];
}
- (void)stop
{
    [_locationManager stopUpdatingLocation];
}
-(void)getGeographicalPosition:(void (^)(CLLocation * location))block
{
//    self.castPosition = block;
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    UserInfoModel * user = USER_INFO;
    [[[UploadPositionViewModel alloc]init]uploadPositionWithUserID:[NSString stringWithFormat:@"%d",user.iden] WithLocation:[NSString stringWithFormat:@"[%f,%f]",coordinate.longitude,coordinate.latitude] WithTimeStamp:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000] callback:^(BOOL success) {
        
    }];
}
@end
