//
//  ZCFailCheckViewController.m
//  Zhongche
//
//  Created by lxy on 2016/11/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCFailCheckViewController.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "PersonViewController.h"
#import "UserInfoModel.h"
#import "ZCRecommendViewController.h"
#import "PerfectInfomationViewController.h"
#import "MyCapacityViewController.h"
#import "PushOrderView.h"
#import "PushModel.h"
#import "EvaluateResultView.h"
#import "UserInfoViewModel.h"
#import "PerfectCarInfomationViewController.h"
#import "CarInfoModel.h"
#import "ZCCarManagerViewController.h"
#import "ZCTransportationRecordViewController.h"
#import "ZCHistoryOrderViewController.h"

@interface ZCFailCheckViewController ()

@property (nonatomic, strong) UIImageView        *ivCartoon;
@property (nonatomic, strong) UILabel            *lbText;
@property (nonatomic, strong) UILabel            *lbText1;
@property (nonatomic, strong) UIButton           *btnRecommend;
@property (nonatomic, strong) UIButton           *btnPerfect;
@property (nonatomic, strong) UserInfoModel      *info;
@property (nonatomic, strong) PushOrderView      *viPush;
@property (nonatomic, strong) EvaluateResultView *viEvaluate;

@end

@implementation ZCFailCheckViewController

- (void)viewWillAppear:(BOOL)animated{
    //    [self leftViewSet];



}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审核失败";
    [self.btnLeft setImage:[UIImage imageNamed:@"home_top_sliding_icon"] forState:UIControlStateNormal];
    self.btnRight.hidden = NO;
    self.info=USER_INFO;

}

- (void)bindView{

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.ivCartoon.frame = CGRectMake(SCREEN_W/2 -62.5, 60, 125, 150);
    [self.view addSubview:self.ivCartoon];


    self.lbText.frame = CGRectMake(0, self.ivCartoon.bottom + 20, SCREEN_W, 30);
    [self.view addSubview:self.lbText];

    self.lbText1.frame = CGRectMake(0, self.lbText.bottom, SCREEN_W, 30);
    [self.view addSubview:self.lbText1];

    self.btnPerfect.frame = CGRectMake(20, SCREEN_H - 260, SCREEN_W - 40, 50);
    [self.view addSubview:self.btnPerfect];

    self.btnRecommend.frame = CGRectMake(20, self.btnPerfect.bottom + 20, SCREEN_W - 40, 50);
    [self.view addSubview:self.btnRecommend];


}

- (void)bindAction{
    WS(ws);
    [[self.btnRecommend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws.navigationController pushViewController:[ZCRecommendViewController new] animated:YES];
    }];

    [[self.btnPerfect rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws.navigationController pushViewController:[PerfectInfomationViewController new] animated:YES];
    }];
}

- (void)onBackAction{
    [self.menu show];
}

//联系客服
- (void)Contectservice{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alert show];
}


/**
 *  getter(懒加载)
 */
- (UIImageView *)ivCartoon {
    if (!_ivCartoon) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"hh"];

        _ivCartoon = imageView;
    }
    return _ivCartoon;
}

- (UILabel *)lbText {
    if (!_lbText) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您提交的资料未通过审核";

        _lbText = label;
    }
    return _lbText;
}

- (UILabel *)lbText1 {
    if (!_lbText1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请重新提交资料！";

        _lbText1 = label;
    }
    return _lbText1;
}

- (UIButton *)btnRecommend {
    if (!_btnRecommend) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"推荐有奖" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setCornerRadius:8.0];//设置矩形四个圆角半径



        _btnRecommend = button;
    }
    return _btnRecommend;
}

- (UIButton *)btnPerfect {
    if (!_btnPerfect) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"完善资料" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];

        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:8.0];//设置矩形四个圆角半径
        _btnPerfect = button;
    }
    return _btnPerfect;
}

- (PushOrderView *)viPush {
    if (!_viPush) {
        _viPush = [PushOrderView new];

    }
    return _viPush;
}

- (EvaluateResultView *)viEvaluate {
    if (!_viEvaluate) {
        _viEvaluate = [EvaluateResultView new];
        
    }
    return _viEvaluate;
}


@end
