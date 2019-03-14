//
//  ZCWalletInfo.h
//  Zhongche
//
//  Created by lxy on 2016/11/1.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface ZCWalletInfo : BaseModel

/**
 *  generalIncome = 0;
 isBoundBank = 1;
 waitConfirmedIncome = 0;
 generalIncome总收入
 waitConfirmedIncome 待确认
 withdrawAccount可提现
 */

@property (nonatomic, assign) float generalIncome;
@property (nonatomic, assign) float isBoundBank;
@property (nonatomic, assign) float waitConfirmedIncome;
@property (nonatomic, assign) float withdrawAccount;

@end
