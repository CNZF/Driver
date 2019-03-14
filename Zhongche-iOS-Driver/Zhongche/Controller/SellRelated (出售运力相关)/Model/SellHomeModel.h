//
//  SellHomeModel.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface SellHomeModel : BaseModel

@property (nonatomic, copy) NSString * beginCity;
@property (nonatomic, copy) NSString * endCity;
@property (nonatomic, copy) NSString * beginTime;
@property (nonatomic, copy) NSString * sellPrice;
@property (nonatomic, copy) NSString * carCard;
@property (nonatomic, copy) NSString * carState;

@end
