//
//  TwoLabelCell.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/31.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfoModel.h"
@interface TwoLabelCell : UITableViewCell

@property (nonatomic, strong)CarInfoModel * model;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
