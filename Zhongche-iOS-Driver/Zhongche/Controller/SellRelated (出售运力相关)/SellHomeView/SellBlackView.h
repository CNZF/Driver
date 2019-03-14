//
//  SellBlackView.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/31.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>


 typedef void(^ConfirmBlcoK)(NSInteger index);
 typedef void(^ConfirmDateBlcoK)(NSString * string);
@interface SellBlackView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) ConfirmBlcoK block;
@property (nonatomic, copy) ConfirmDateBlcoK dateBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy)NSString * dateString;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


-  (void) setDataArrayWithCarModel:(NSArray *)array;

@end
