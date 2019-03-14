//
//  BoxInfoModel.h
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface BoxInfoModel : BaseModel

/**
 *  "status": 1,
 "max_total_weight": 0,
 "outside_length": 0,
 "min_total_weight": 0,
 "inside_width": 0,
 "max_self_weight": 0,
 "outside_width": 0,
 "id": 17,
 "inside_height": 0,
 "outside_height": 0,
 "volume": 0,
 "min_self_weight": 0,
 "container_type": "收到",
 "container_size": "0",
 "inside_length": 0
 */



@property (nonatomic, assign) int      iden;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *name;


@end
