//
//  ZCHistoryTableViewCell.h
//  Zhongche
//
//  Created by lxy on 16/9/3.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbStartName;
@property (weak, nonatomic) IBOutlet UILabel *lbEndName;
@property (weak, nonatomic) IBOutlet UILabel *lbCode;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbState;
@property (weak, nonatomic) IBOutlet UILabel *lbPushOrder;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;

@end
