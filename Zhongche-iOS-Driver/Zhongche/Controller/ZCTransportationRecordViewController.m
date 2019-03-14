//
//  ZCTransportationRecordViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/5.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCTransportationRecordViewController.h"
#import "NinaPagerView.h"
#import "ZCFinishedTransportViewController.h"
#import "ZCNoFinishedTransportViewController.h"
#import "ZCCancleTransportViewController.h"
#import "ZCSellCapacityViewControllerViewController.h"


@interface ZCTransportationRecordViewController ()


@end

@implementation ZCTransportationRecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    [self.btnRight setTitle:@"出售运力" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 100, 30);
}

- (void)bindView {

    self.title = @"运力交易记录";
    NSArray *titleArray = @[@"未结算", @"已结算", @"未成交"];
    NSArray *colorArray = [self ninaColorArray];
    NSArray *vcsArray = [self ninaVCsArray];

    NinaPagerView *ninaPagerView = [[NinaPagerView alloc] initWithNinaPagerStyle:NinaPagerStyleBottomLine WithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray];
    ninaPagerView.titleScale = 1.15;
    ninaPagerView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:ninaPagerView];
    ninaPagerView.pushEnabled = YES;


}


- (void)onBackAction {
    if (self.type == 1) {
        //连续返回两级
        int index= (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];

    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }


}

- (void)onRightAction {
    ZCSellCapacityViewControllerViewController * vc = [[ZCSellCapacityViewControllerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

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
             @"ZCNoFinishedTransportViewController",
             @"ZCFinishedTransportViewController",
             @"ZCCancleTransportViewController",
             ];
}


@end
