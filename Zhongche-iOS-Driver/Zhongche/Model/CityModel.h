//
//  CityModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel

@property (nonatomic, copy) NSString * startPositionCode;
@property (nonatomic, copy) NSString * startPosition;
@property (nonatomic, copy) NSString * startPinyin;
@property (nonatomic, assign) int type;

@end
