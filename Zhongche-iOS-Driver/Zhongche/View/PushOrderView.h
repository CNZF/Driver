//
//  PushOrderView.h
//  Zhongche
//
//  Created by lxy on 16/8/9.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseView.h"
#import "PushModel.h"

@interface PushOrderView : BaseView

@property (nonatomic, strong) UIButton    *btnCancle;//右上角X
@property (nonatomic, strong) UIButton    *btnCancle1;//右上角X
@property (nonatomic, strong) UIButton    *btnOverLook;//拒绝、忽略按钮
@property (nonatomic, strong) UIButton    *btnPlunder;//接收、抢单按钮
@property (nonatomic, strong) PushModel * model;
@property (nonatomic, strong) UILabel     *lbType;
@property (nonatomic, strong) UIImageView *ivStyle;
@property (nonatomic, strong) UILabel     *lbPrice;

+(PushOrderView *)sharePushOrderView;

@end
