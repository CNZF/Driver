//
//  MarkViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "MarkViewController.h"
#import "ZCTransportOrderViewModel.h"

@interface MarkViewController ()

@property (nonatomic, strong) NSMutableArray *arr1;
@property (nonatomic, strong) NSMutableArray *arr2;
@property (nonatomic, strong) UIScrollView   *scroView;
@property (nonatomic, strong) UILabel        *lb1;
@property (nonatomic, strong) UILabel        *lb2;
@property (nonatomic, strong) UIView         *viMark1;
@property (nonatomic, strong) UIView         *viMark2;
@property (nonatomic, strong) YMTextView     *textView1;
@property (nonatomic, strong) YMTextView     *textView2;
@property (nonatomic, strong) UIButton       *btnSubmit;


@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)bindView {

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"运单评价";


    self.scroView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.scroView.contentSize = CGSizeMake(SCREEN_W, 700);
    [self.view addSubview:self.scroView];

    self.lb1.frame = CGRectMake(0, 40, SCREEN_W, 20);
    [self.scroView addSubview:self.lb1];

    self.viMark1.frame = CGRectMake(SCREEN_W/2 -87.5, self.lb1.bottom + 10, 175, 60);
    [self markViewSet];
    [self.scroView addSubview:self.viMark1];

    self.textView1.frame = CGRectMake(10, self.viMark1.bottom + 20, SCREEN_W - 20, 100);
    [self.scroView addSubview:self.textView1];

    self.lb2.frame = CGRectMake(0, self.textView1.bottom + 20, SCREEN_W, 20);
    [self.scroView addSubview:self.lb2];

    self.viMark2.frame = CGRectMake(SCREEN_W/2 -87.5, self.lb2.bottom + 10, 175, 60);
    [self markViewSet2];
    [self.scroView addSubview:self.viMark2];

    self.textView2.frame = CGRectMake(10, self.viMark2.bottom + 20, SCREEN_W - 20, 100);
    [self.scroView addSubview:self.textView2];

    self.btnSubmit.frame = CGRectMake(20, self.textView2.bottom + 20, SCREEN_W - 40, 50);
    [self.scroView addSubview:self.btnSubmit];



}

- (void)bindModel {
    self.arr1 = [NSMutableArray array];
    self.arr2 = [NSMutableArray array];
}

-(void)bindAction {

    WS(ws);
    [[self.btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws submitAction];
    }];
}

- (void) markViewSet {

    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"3-10运单详情-评价ＺＡ_03"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"3-10运单详情-评价_03"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.arr1 addObject:btn];

        btn.frame = CGRectMake(35 * i, 10, 35, 35);
        [self.viMark1 addSubview:btn];

    }
}

- (void) markViewSet2 {

    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"3-10运单详情-评价ＺＡ_03"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"3-10运单详情-评价_03"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 5;
        [self.arr2 addObject:btn];

        btn.frame = CGRectMake(35 * i, 10, 35, 35);
        [self.viMark2 addSubview:btn];
        
    }
}

- (void)changeAction:(UIButton *)btn {

    if (btn.tag < 5) {
        for (UIButton *btn in self.arr1) {
            btn.selected = NO;
        }
        for (int i =0; i<= btn.tag; i ++) {
            UIButton *btnSelect = [self.arr1 objectAtIndex:i];
            btnSelect.selected = YES;
        }
    }else{
        for (UIButton *btn in self.arr2) {
            btn.selected = NO;
        }
        for (int i =5; i<= btn.tag; i ++) {
            UIButton *btnSelect = [self.arr2 objectAtIndex:i-5];
            btnSelect.selected = YES;
        }

    }

}

- (void)submitAction {
    int a = 0;
    int b = 0;
    for (UIButton  *btn in self.arr1) {
        if (btn.selected) {
            a++;
        }
    }
    for (UIButton  *btn in self.arr2) {
        if (btn.selected) {
            b++;
        }
    }

    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    [vm markeWithBillid:self.billId WithShipperRate:a WithShipperRateContent:self.textView1.text WithConsigneeRate:b WithConsignnerRateContent:self.textView2.text callback:^(NSString *message) {
        if ([message isEqualToString:@"成功"]) {
            [[Toast shareToast]makeText:@"评价成功" aDuration:1];
            [ws.navigationController popViewControllerAnimated:YES];
        }
    }];
}


/**
 *  get(懒加载)
 */

- (UIScrollView *)scroView {
    if (!_scroView) {
        _scroView = [UIScrollView new];

    }
    return _scroView;
}

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"评价发货人";

        _lb1 = label;
    }
    return _lb1;
}

- (UIView *)viMark1 {
    if (!_viMark1) {
        _viMark1 = [UIView new];

    }
    return _viMark1;
}

- (YMTextView *)textView1 {
    if (!_textView1) {
        _textView1 = [YMTextView new];
        _textView1.placeholder = @"我还有话要说";
        _textView1.font = [UIFont systemFontOfSize:16];
        _textView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _textView1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"评价收货人";


        _lb2 = label;
    }
    return _lb2;
}

- (UIView *)viMark2 {
    if (!_viMark2) {
        _viMark2 = [UIView new];

    }
    return _viMark2;
}

- (YMTextView *)textView2 {
    if (!_textView2) {
        _textView2 = [YMTextView new];
        _textView2.placeholder = @"我还有话要说";
        _textView2.font = [UIFont systemFontOfSize:16];
        _textView2.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return _textView2;
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnSubmit = button;
    }
    return _btnSubmit;
}

@end
