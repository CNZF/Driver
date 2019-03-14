//
//  ListTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "ListTableViewCell.h"
#import "ZCMapViewController.h"

@interface ListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (nonatomic, strong) NSArray * array;

@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.array = @[@"距离：",@"运单号：",@"运单类型：",@"计划载货时间：",@"要求：",@"货品：",@"箱型："];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setModelWith:(ZCTransportOrderModel *)model AndIndex:(NSInteger) index
{
    self.nameLabel.text = self.array[index];
    //0
    if (index == 0) {
        float distance = [self distanceWithStartlat:model.start_region_center_lat WithStartlng:model.start_region_center_lng WithEndlat:model.end_region_center_lat WithEndlng:model.end_region_center_lng];
        if (distance >0) {
            self.valueLabel.text = [NSString stringWithFormat:@"约%.0f公里",distance];
        }else {
            self.valueLabel.text = @"同城";
        }
    }
    
    //1
    if (index == 1) {
        self.valueLabel.text = model.waybill_code;
    }
    //2
    if (index == 2) {
        if (model.type == 2) {
            self.valueLabel.text = @"抢单";
        }else{
            self.valueLabel.text =@"任务";
        }
    }
    if (index == 3) {
       self.valueLabel.text = [self ConvertStrToTime:model.startTime];
    }
    
    if (index == 4) {
        double daytime = ([model.endTime doubleValue] - [model.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }
        self.valueLabel.text = [NSString stringWithFormat:@"%.0f日达",daytime];
    }
    if (index == 5) {
        self.valueLabel.text = model.goods_name;
    }
    
    if (index ==6) {
        self.cellImageView.hidden = YES;
        self.valueLabel.text = model.containerType;
    }
}
//毫秒转日期
- (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}

//计算两个坐标距离
- (float)distanceWithStartlat:(float)startlat WithStartlng:(float)startlng WithEndlat:(float)endlat WithEndlng:(float)endlng{
    
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:startlat  longitude:startlng];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:endlat longitude:endlng];
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}


@end
