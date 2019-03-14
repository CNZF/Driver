//
//  WaitForCheckViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "WaitForCheckViewController.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "PersonViewController.h"
#import "ZCRecommendViewController.h"
#import "MyCapacityViewController.h"
#import "ZCHistoryOrderViewController.h"
#import "ZCSellCapacityViewControllerViewController.h"
#import "ZCCarManagerViewController.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCRecommendViewController.h"
#import "ZCTransportationRecordViewController.h"

@interface WaitForCheckViewController ()

@property (nonatomic, strong) UserInfoModel    *info;
@property (nonatomic, strong) UIImageView      *ivWaite;
@property (nonatomic, strong) UILabel          *lb1;
@property (nonatomic, strong) UILabel          *lb2;
@property (nonatomic, strong) UILabel          *lb3;
@property (nonatomic, strong) UIButton         *btnInvite;
@property (nonatomic, strong) UIButton         *btnBottom;//下面按钮


@end

@implementation WaitForCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.info=USER_INFO;
}

-(void)bindView {

    self.title = @"资料审核中";

    self.btnRight.hidden = NO;
    self.btnLeft.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];

//    [self.btnLeft setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [self.btnLeft  setFrame:CGRectMake(0, 0, 24, 25)];


    self.ivWaite.frame = CGRectMake(SCREEN_W/2 - 75, 50, 150, 135 );
    [self.view addSubview:self.ivWaite];

    self.lb1.frame = CGRectMake(0, self.ivWaite.bottom + 20, SCREEN_W, 30);
    [self.view addSubview:self.lb1];
    
    self.lb2.frame = CGRectMake(0, self.ivWaite.bottom + 60, SCREEN_W, 30);
    [self.view addSubview:self.lb2];
    
    self.lb3.frame = CGRectMake(0, self.ivWaite.bottom + 100, SCREEN_W, 30);
    [self.view addSubview:self.lb3];

//
//    self.btnInvite.frame =CGRectMake(20, SCREEN_H - 260, SCREEN_W - 40, 50);
//    [self.view addSubview:self.btnInvite];

    self.btnBottom.frame = CGRectMake(20, self.btnInvite.bottom + 20, SCREEN_W - 40, 50);
    //[self.view addSubview:self.btnBottom];

    
}

-(void)bindAction {

    WS(ws);
    [[self.btnInvite rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws.navigationController pushViewController:[ZCRecommendViewController new] animated:YES];
    }];
    
}

- (void)onBackAction{
//    [self.menu show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)Contectservice{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alert show];
}




- (UIImageView *)ivWaite {
    if (!_ivWaite) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"zhuce_pic_3"];

        _ivWaite = imageView;
    }
    return _ivWaite;
}

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您所更新的资料正在审核中";

        _lb1 = label;
    }
    return _lb1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请随时登录查看状态更新";
        
        _lb2 = label;
    }
    return _lb2;
}

- (UILabel *)lb3 {
    if (!_lb3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"审核完成后,我们会短信通知您";
        
        _lb3 = label;
    }
    return _lb3;
}
//
//- (UIButton *)btnInvite {
//    if (!_btnInvite) {
//        UIButton *button = [[UIButton alloc]init];
//        [button setTitle:@"推荐有奖" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
//        [button.layer setMasksToBounds:YES];
//        [button.layer setCornerRadius:7.0];//设置矩形四个圆角半径
//
//        _btnInvite = button;
//    }
//    return _btnInvite;
//}

- (UIButton *)btnBottom {
    if (!_btnBottom) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _btnBottom = button;
    }
    return _btnBottom;
}


@end
