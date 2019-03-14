//
//  PlaceDetailsModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface PlaceDetailsModel : BaseModel
@property (nonatomic, copy) NSString * address;
@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSDictionary * createTime;
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *introdution;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int othePrice;
@property (nonatomic, assign) int price;
@property (nonatomic, assign) int salePrice;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) NSInteger tel;

@end
