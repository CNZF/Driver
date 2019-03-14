//
//  ZCCityListViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "CityModel.h"


typedef void(^cityModelBlcok)(CityModel * model);

@protocol ZCCityListViewControllerDelagate<NSObject>

- (void)getCityModel:(CityModel *)cityModel;

@end

@interface ZCCityListViewController : BaseViewController
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) int cityType;

@property (nonatomic, copy)cityModelBlcok block;
@property (nonatomic,weak)id<ZCCityListViewControllerDelagate>getCityDelagate;
@end
