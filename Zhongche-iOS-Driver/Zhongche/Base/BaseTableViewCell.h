//
//  BaseTableViewCell.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast.h"
#import "UIView+Frame.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YMTextView.h"

@interface BaseTableViewCell : UITableViewCell

- (void)bindView;
- (void)bindModel;
- (void)bindAction;

@end
