//
//  EvaluateResultView.h
//  Zhongche
//
//  Created by lxy on 16/8/10.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseView.h"
#import "PushEvaluateModel.h"

@interface EvaluateResultView : BaseView
@property (nonatomic, strong) UIButton *btnCancle;//右上角X
@property (nonatomic, strong) UIButton *btnGiveUp;//放弃
@property (nonatomic, strong) UIButton *btnAgree;//同意
@property (nonatomic, strong) PushEvaluateModel * model;

@end
