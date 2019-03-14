//
//  RecommendViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/15.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@property (nonatomic, strong) UILabel *lb1;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView{
    self.title = @"推荐有奖";
    
    self.btnRight.hidden = NO;
}

/**
 *  getter
 */

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor yellowColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"扫码注册";
        
        _lb1 = label;
    }
    return _lb1;
}


@end
