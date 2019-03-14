//
//  PayPWDView.h
//  Zhongche
//
//  Created by lxy on 2016/11/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseView.h"
#import "TXTradePasswordView.h"


@interface PayPWDView : BaseView

@property (nonatomic, strong) TXTradePasswordView *TXView;
@property (nonatomic, strong) UILabel     *lbMoney;
@property (nonatomic, strong) UILabel     *lbTixian;

+(PayPWDView *)sharePushOrderView;



@end
