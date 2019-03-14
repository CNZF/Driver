//
//  BillListTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/6/1.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "BillListTableViewCell.h"


@interface BillListTableViewCell()

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
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoimageView;

@end

@implementation BillListTableViewCell

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
    
    if (model.status == 5) {
        self.confirmBtn.hidden = YES;
        self.detailOneLabel.hidden =YES;
        self.twoLabel.hidden  = YES;
        self.oneImageView.hidden = YES;
        self.twoimageView.hidden = YES;
    }
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
        self.psImageView.image = [UIImage imageNamed:@"butt_1"];
        self.psLabel.text = @"待装载";
        
    }else if(model.status ==5){
        self.psImageView.image = [UIImage imageNamed:@"butt_1"];
        self.psLabel.text = @"已抵达";
        
    }else{
        self.psImageView.image = [UIImage imageNamed:@"butt_1"];
        self.psLabel.text = @"配送中";
        
    }
    if (model.type != 3) {
        self.stateImageView.image = [UIImage imageNamed:@"tab-2"];
        self.priceLabel.hidden = NO;
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",model.price]];
        NSUInteger firstLoc = [[noteStr string] rangeOfString:@"."].location + 1;
        NSUInteger secondLoc = noteStr.length;
        NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
        [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:12] range:range];
        [self.priceLabel setAttributedText:noteStr];
    }else{
        self.stateImageView.image = [UIImage imageNamed:@"tab-1"];
        self.priceLabel.hidden = YES;
        
    }
    
}

//时间戳转时间格式字符串
- (NSString *)stDateToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [outputFormatter stringFromDate:date];
}

- (IBAction)pressConfirmBtn:(id)sender {
    
}

@end

