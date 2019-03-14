//
//  TabbarView.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TabBarStatus) {
    BillController = 0,
    SellController = 1,
    PersonController = 2,
};

typedef void(^chooseBlock)(NSInteger selectIndex);

@interface TabbarView : UIView

@property (nonatomic, assign)TabBarStatus tabbarStatus;
@property (nonatomic, copy)chooseBlock block;

@end
