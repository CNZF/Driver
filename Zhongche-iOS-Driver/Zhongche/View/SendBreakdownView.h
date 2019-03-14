//
//  SendBreakdownView.h
//  Zhongche
//
//  Created by lxy on 2016/10/27.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseView.h"

@interface SendBreakdownView : BaseView

@property (nonatomic, strong) UIButton    *btnCertain;
@property (nonatomic, assign) int         index;

+(SendBreakdownView *)sharePushOrderView;

@end
