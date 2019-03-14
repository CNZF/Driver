//
//  QCodeViewController.h
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);

@interface QCodeViewController : BaseViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;


@end
