//
//  ZCCityListViewModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZCCityListViewModel : BaseViewModel
/**
 *  拉取城市列表
 *
 *  @param callback
 */
-(void)getCityListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback;
@end
