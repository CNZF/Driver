//
//  ChooseCarViewController.h
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);

@interface ChooseCarViewController : BaseViewController
@property (nonatomic, strong) NSArray *arrInfo;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;

- (void)returnText:(ReturnTextBlock)block;

@end
