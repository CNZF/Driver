//
//  ZCBankCardMessageInfo.h
//  Zhongche
//
//  Created by lxy on 2016/10/31.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface ZCBankCardMessageInfo : BaseModel

/**
 bankCardNanme = "\U4e2d\U56fd\U5efa\U8bbe\U94f6\U884c\U80a1\U4efd\U6709\U9650\U516c\U53f8\U603b\U884c";
 bankCardNum = 6227000783050216088;
 userName = "\U674e\U96ea\U9633";
 */

@property (nonatomic, strong) NSString *bankCardNanme;
@property (nonatomic, strong) NSString *bankCardNum;
@property (nonatomic, strong) NSString *userName;

@end
