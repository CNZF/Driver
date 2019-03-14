//
//  MapCityTableViewCell.h
//  Zhongche
//
//  Created by lxy on 2016/9/27.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivPoint;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;

@end
