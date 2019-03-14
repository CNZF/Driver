//
//  ZCRefuseOrderViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/5.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCRefuseOrderViewController.h"

@interface ZCRefuseOrderViewController ()
@property (nonatomic, strong) UIView *ViBackround;
@property (nonatomic, strong) UIImageView *ivNo;
@property (nonatomic, strong) UILabel *lb1;
@property (nonatomic, strong) UILabel *lb2;
@property (nonatomic, strong) UILabel *lb3;
@property (nonatomic, strong) UILabel *lb4;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;



@end

@implementation ZCRefuseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"拒绝任务";
    self.view.backgroundColor = [UIColor whiteColor];

    self.ViBackround.frame = CGRectMake(0, 0, SCREEN_W, 10);
    [self.view addSubview:self.ViBackround];

    self.ivNo.frame = CGRectMake(SCREEN_W/2 - 50, 60, 100, 100);
    [self.view addSubview:self.ivNo];

    self.lb1.frame = CGRectMake(0, self.ivNo.bottom + 50, SCREEN_W, 20);
    [self.view addSubview:self.lb1];

    self.lb2.frame = CGRectMake(0, self.lb1.bottom + 40, SCREEN_W, 20);
    [self.view addSubview:self.lb2];

    self.lb3.frame = CGRectMake(0, self.lb2.bottom , SCREEN_W, 20);
    [self.view addSubview:self.lb3];

    self.lb4.frame = CGRectMake(0, self.lb3.bottom + 40, SCREEN_W, 20);
    [self.view addSubview:self.lb4];

    self.btn1.frame = CGRectMake(20, SCREEN_H - 200, SCREEN_W/2 -30, 44);
    [self.view addSubview:self.btn1];

    self.btn2.frame = CGRectMake(self.btn1.right + 20, SCREEN_H - 200, SCREEN_W/2 -30, 44);
    [self.view addSubview:self.btn2];




}


/**
 *  getter
 */

- (UIView *)ViBackround {
    if (!_ViBackround) {
        _ViBackround = [UIView new];
        _ViBackround.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _ViBackround;
}

- (UIImageView *)ivNo {
    if (!_ivNo) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"NO"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;

        _ivNo = imageView;
    }
    return _ivNo;
}

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"任务无法拒绝";

        _lb1 = label;
    }
    return _lb1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"任务源于您的运力出售订单";

        _lb2 = label;
    }
    return _lb2;
}

- (UILabel *)lb3 {
    if (!_lb3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请联系平台取消运力";

        _lb3 = label;
    }
    return _lb3;
}

- (UILabel *)lb4 {
    if (!_lb4) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"任何不明白之处，请联系客服";

        _lb4 = label;
    }
    return _lb4;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btn1 = button;
    }
    return _btn1;
}

- (UIButton *)btn2 {
    if (!_btn2) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"接受任务" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btn2 = button;
    }
    return _btn2;
}


@end
