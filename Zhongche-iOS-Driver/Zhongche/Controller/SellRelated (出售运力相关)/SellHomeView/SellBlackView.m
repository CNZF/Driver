//
//  SellBlackView.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/31.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "SellBlackView.h"
#import "TwoLabelCell.h"
#import "CarInfoModel.h"

@implementation SellBlackView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = nil;
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell"];
    
   
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker setDate:[NSDate date] animated:YES];
     self.datePicker.minimumDate = [NSDate date];
    [self.datePicker setMaximumDate:[NSDate distantFuture]];
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
}
- (NSString *)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    return dateStr;
//    self.dateString = dateStr;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCell" forIndexPath:indexPath];
    CarInfoModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    if (model.isCheck) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tintColor = APP_COLOR_ORANGR;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
         CarInfoModel * model = self.dataArray[i];
        if (i==indexPath.row) {
            model.isCheck = YES;
            self.index = i;
        }else{
            model.isCheck = NO;
        }
    }
    [self.tableView reloadData];
}


-  (void) setDataArrayWithCarModel:(NSArray *)array
{
    _dataArray = array.mutableCopy;
    [self.tableView reloadData];
}



- (IBAction)pressErrprBtn:(id)sender {
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        CarInfoModel * model = self.dataArray[i];
        model.isCheck = NO;
    }
    [self removeFromSuperview];

}
- (IBAction)pressConfirmBtn:(id)sender {
    for (NSInteger i = 0; i<self.dataArray.count; i++) {
        CarInfoModel * model = self.dataArray[i];
        model.isCheck = NO;
    }
    
    if (self.datePicker.hidden) {
        if (self.block) {
            self.block(self.index);
        }
    }else{
        
        NSString * str = [self dateChange:self.datePicker];
        if (self.dateBlock) {
            self.dateBlock(str);
        }
    }
    
    [self removeFromSuperview];
}
@end
