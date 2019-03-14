//
//  ZCHistoryOrderViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/2.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCHistoryOrderViewController.h"
#import "NinaPagerView.h"
#import "ZCFinishedOrderViewController.h"
#import "ZCCancleOrderViewController.h"
#import "ZCNoFinishedTransportViewController.h"

@interface ZCHistoryOrderViewController ()

@end

@implementation ZCHistoryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {


    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"历史运单";
    NSArray *titleArray = @[@"未完成", @"已完成", @"已取消"];
    NSArray *colorArray = [self ninaColorArray];
    NSArray *vcsArray = [self ninaVCsArray];

    NinaPagerView *ninaPagerView = [[NinaPagerView alloc] initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray];
    ninaPagerView.titleScale = 1.15;
    ninaPagerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:ninaPagerView];
    ninaPagerView.pushEnabled = YES;


}


- (NSArray *)ninaColorArray {
    return @[
             APP_COLOR_ORANGR, /**< 选中的标题颜色 Title SelectColor  **/
             [UIColor grayColor], /**< 未选中的标题颜色  Title UnselectColor **/
             APP_COLOR_ORANGR, /**< 下划线颜色或滑块颜色 Underline or SlideBlock Color   **/
             [UIColor whiteColor], /**<  上方菜单栏的背景颜色 TopTab Background Color   **/
             ];
}

- (NSArray *)ninaVCsArray {
    return @[
             @"ZCNoFinishedOrderViewController",
             @"ZCFinishedOrderViewController",
             @"ZCCancleOrderViewController",
             ];
}

@end
