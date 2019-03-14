//
//  BillHomeTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "BillHomeTableViewCell.h"
#import "NSString+Money.h"

@interface BillHomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *beginCity;
@property (weak, nonatomic) IBOutlet UILabel *endCity;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *psImageView;
@property (weak, nonatomic) IBOutlet UILabel *psLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation BillHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZCTransportOrderModel *)model
{
    _model = model;
    self.dateLabel.text = [NSString stringWithFormat:@"%@出发",[self stDateToString:model.startTime]];
    self.beginCity.text = model.start_region_name;
    self.endCity.text = model.end_region_name;
    double daytime = ([model.endTime doubleValue] - [model.startTime doubleValue])/1000/60/60/24;
    if (daytime > (int)daytime) {
        daytime ++;
    }
    self.dayLabel.text = [NSString stringWithFormat:@"%i日达",(int)daytime];
    self.detailOneLabel.text = model.goods_name;
    self.twoLabel.text = model.containerType;
    
    if (model.status == 3) {
        self.psImageView.image = [UIImage imageNamed:@"butt_4"];
        self.psLabel.text = @"待装载";
        if (model.is_accept == 0) {
            [self.confirmBtn setTitle:@"接受任务" forState:UIControlStateNormal];
        }else{
            [self.confirmBtn setTitle:@"确认装载" forState:UIControlStateNormal];
        }
    }else{
        self.psImageView.image = [UIImage imageNamed:@"butt_1"];
        self.psLabel.text = @"配送中";
        [self.confirmBtn setTitle:@"确认抵达" forState:UIControlStateNormal];
    }
    if (model.type == 3 || model.type == 1) {
        self.stateImageView.image = [UIImage imageNamed:@"tab-1"];
        self.priceLabel.hidden = YES;
    }else{
        self.stateImageView.image = [UIImage imageNamed:@"tab-2"];
        self.priceLabel.hidden = NO;

        [self.priceLabel setAttributedText:[NSString getFormartPrice:model.price]];
    }
    
}
- (IBAction)pressConfirmBtn:(id)sender {
    if (self.block) {
        self.block(self.model,self.confirmBtn.titleLabel.text);
    }
}
//时间戳转时间格式字符串
- (NSString *)stDateToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [outputFormatter stringFromDate:date];
}
@end
