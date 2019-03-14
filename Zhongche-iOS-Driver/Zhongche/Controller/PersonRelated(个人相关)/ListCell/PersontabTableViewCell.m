//
//  PersontabTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "PersontabTableViewCell.h"
@interface PersontabTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *statLabel;

@end

@implementation PersontabTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellPrefernceWitnIndexPath:(NSInteger)index
{
    if (index == 0) {
        self.headImage.image = [UIImage imageNamed:@"geren_icon_5"];
        self.statLabel.text = @"联系客服";
    }else if (index == 1){
        self.headImage.image = [UIImage imageNamed:@"geren_icon_7"];
        self.statLabel.text = @"检查更新";
    }else{
        self.headImage.image = [UIImage imageNamed:@"geren_icon_8"];
        self.statLabel.text = @"关于我们";
    }
}
@end
