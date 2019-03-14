//
//  SellChuFaTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "SellChuFaTableViewCell.h"


@interface SellChuFaTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end

@implementation SellChuFaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellPrefrenceWithIndexPatRow:(NSInteger)index WithModel:(SellHomeModel *)model
{
    _model = model;
    _index = index;
    if (index == 0) {
        self.stateImageView.image = [UIImage imageNamed:@"icon_1"];
        self.titleLabel.text = @"出发日期";
        if (!model.beginTime) {
            self.detailLabel.text = @"请选择日期";
        }else{
             self.detailLabel.text = model.beginTime;
        }
    }else if (index == 2){
        self.stateImageView.image = [UIImage imageNamed:@"icon_3"];
        self.titleLabel.text = @"车牌号";
        if (self.model.carCard) {
            self.detailLabel.text = self.model.carCard;
            self.detailLabel.textColor = [UIColor orangeColor];
        }else{
            self.detailLabel.text = @"请选择车量";
            self.detailLabel.textColor = [UIColor darkGrayColor];
        }
    }else{
        self.stateImageView.image = [UIImage imageNamed:@"icon_4"];
        self.titleLabel.text = @"车辆类型";
        self.changeBtn.hidden = YES;
        if (self.model.carState) {
            self.detailLabel.text = self.model.carState;
            self.detailLabel.textColor = [UIColor orangeColor];
        }else{
            self.detailLabel.text = @"";
            self.detailLabel.textColor = [UIColor darkGrayColor];
        }
    }
}

- (IBAction)pressBtn:(id)sender {
    if (self.block) {
        self.block(self.index);
    }
}

@end
