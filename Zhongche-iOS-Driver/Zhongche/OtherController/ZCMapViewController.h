//
//  ZCMapViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/15.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "ZCTransportOrderModel.h"

@interface ZCMapViewController : BaseViewController

@property (nonatomic, strong) ZCTransportOrderModel * model;
@property (nonatomic, strong) NSString *endPointLat;
@property (nonatomic, strong) NSString *endPointLng;


@end