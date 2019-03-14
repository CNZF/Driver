//
//  PreferenceRouteCell.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PreferenceRouteCell : BaseTableViewCell
@property (nonatomic, strong) NSMutableAttributedString * labeltext;
@property (nonatomic, assign) BOOL isEditoring;
@property (nonatomic, strong) UIButton * routesBtn;
@end
