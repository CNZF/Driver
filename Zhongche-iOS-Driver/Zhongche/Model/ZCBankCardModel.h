//
//  ZCBankCardModel.h
//  Zhongche
//
//  Created by lxy on 2016/10/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface ZCBankCardModel : BaseModel
/**
 *   accountTypeCode = "\U50a8\U84c4\U5361";
 bcarBin = 622700;
 bcarLen = 19;
 bcarName = "\U9f99\U5361\U50a8\U84c4\U5361(\U94f6\U8054\U5361)";
 code = 105100000017;
 id = 3368;
 name = "\U4e2d\U56fd\U5efa\U8bbe\U94f6\U884c\U80a1\U4efd\U6709\U9650\U516c\U53f8\U603b\U884c";
 status = 1;
 */

@property (nonatomic, strong) NSString *accountTypeCode;
@property (nonatomic, strong) NSString *bcarBin;
@property (nonatomic, strong) NSString *bcarLen;
@property (nonatomic, strong) NSString *bcarName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;


@end
