//
//  ZCOrderTableViewCell.h
//  Zhongche
//
//  Created by lxy on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCTransportOrderModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZCOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbCity1;
@property (weak, nonatomic) IBOutlet UILabel *lbCity2;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lb1;
@property (weak, nonatomic) IBOutlet UILabel *lb2;
@property (weak, nonatomic) IBOutlet UILabel *lbRed;
@property (weak, nonatomic) IBOutlet UIButton *btnKnockOrder;
@property (weak, nonatomic) IBOutlet UIView *viewShow;
@property (weak, nonatomic) IBOutlet UILabel *lbMM;
@property (weak, nonatomic) IBOutlet UIImageView *im;
@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (nonatomic, strong) ZCTransportOrderModel *model;

@end
