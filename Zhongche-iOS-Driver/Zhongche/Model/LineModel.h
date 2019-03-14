//
//  LineModel.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface LineModel : BaseModel
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int expect_time;
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, assign) int startCode;
@property (nonatomic, assign) int start_entrepot_id;
@property (nonatomic, copy) NSString * endName;
@property (nonatomic, assign) int endCode;
@property (nonatomic, assign) int end_entrepot_id;
@end
