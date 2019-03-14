//
//  ZCCityTableViewCell.h
//  Zhongche
//
//  Created by lxy on 16/9/1.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCCityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivlogo;
@property (weak, nonatomic) IBOutlet UILabel     *lbCty;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhone;
@property (weak, nonatomic) IBOutlet UILabel     *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton    *btnPhone;
@property (weak, nonatomic) IBOutlet UILabel     *lbName;
@end
