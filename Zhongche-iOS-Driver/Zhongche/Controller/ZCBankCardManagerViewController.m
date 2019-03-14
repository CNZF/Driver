//
//  ZCBankCardManagerViewController.m
//  Zhongche
//
//  Created by lxy on 2016/10/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCBankCardManagerViewController.h"
#import "ZCBindBankCardViewController.h"
#import "ZCUnBindingBankCardViewController.h"

@interface ZCBankCardManagerViewController ()

@property (nonatomic, strong) UILabel *lb1;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *iv;



@end

@implementation ZCBankCardManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"我的银行卡";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.iv.frame = CGRectMake(SCREEN_W/2 - 35, 30, 70, 70);
    [self.view addSubview:self.iv];

    self.lb1.frame = CGRectMake(0, 140, SCREEN_W, 20);
    [self.view addSubview:self.lb1];

    self.btn.frame = CGRectMake(20, self.lb1.bottom + 20, SCREEN_W - 40, 44);
    [self.view addSubview:self.btn];


}

- (void)bindAction {

    WS(ws);
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        ZCUnBindingBankCardViewController *vc = [ZCUnBindingBankCardViewController new];

        vc.style = 1;


        [ws.navigationController pushViewController:vc animated:YES];
    }];
    
    
    
    
}


/**
 *  get
 */

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"当前账户没有银行卡，请添加";


        _lb1 = label;
    }
    return _lb1;
}

- (UIButton *)btn {
    if (!_btn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
//        button.userInteractionEnabled = NO;

        _btn = button;
    }
    return _btn;
}

- (UIImageView *)iv {

    if (!_iv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"wollateTop"];


        _iv = imageView;
    }
    return _iv;
}



@end
