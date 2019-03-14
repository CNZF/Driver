//
//  ZCOrderTableViewCell.m
//  Zhongche
//
//  Created by lxy on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCOrderTableViewCell.h"

@implementation ZCOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
        //检测信号量
    
        [RACObserve(self, model) subscribeNext:^(id x) {


            self.im.image = [UIImage imageNamed:@"renwu"];
            self.im.hidden = (self.model.type == 1 || self.model.type == 3) && self.model.is_accept == 0?NO:YES;
            self.lbDistance.hidden = (self.model.type == 1 || self.model.type == 3) && self.model.is_accept == 0?NO:YES;

            self.btnKnockOrder.hidden =(self.model.type == 1 || self.model.type == 3) && self.model.is_accept == 0?NO:YES;

            self.lbMM.hidden = (self.model.type == 1 || self.model.type == 3) && self.model.is_accept == 0?YES:NO;

            self.lbRed.hidden = (self.model.status == 3 || self.model.status == 4 || self.model.status == 5) && self.model.is_accept == 1?NO:YES;


            if (self.model.price == 0) {
                self.lbMM.text = @"派单";
            }


            switch (self.model.status) {
                case 3:
                     self.lbRed.text = @"待装载";
                    break;
                case 4:
                    self.lbRed.text = @"在途";
                    break;
                case 5:
                    self.lbRed.text = @"已抵达";
                    break;
                case 6:
                    self.lbRed.text = @"已完成";
                    break;

                default:
                    break;
            }


        }];
    //

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
