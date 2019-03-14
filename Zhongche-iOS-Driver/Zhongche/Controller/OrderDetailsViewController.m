//
//  OrderDetailsViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderDetailsViewModel.h"
#import "ZCMapViewController.h"
#import "QCodeViewController.h"
#import "AlterView.h"
#import "MarkViewController.h"
#import "ZCTransportOrderViewModel.h"
#define PHONEIMGTAG 222
#define CALLSTARTPERSON 34
#define CALLENDPERSON 35
@interface OrderDetailsViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) ZCTransportOrderModel * model;
@property (nonatomic, strong) UIScrollView          * bgScrollView;
@property (nonatomic, strong) UIImageView           * bgView;
@property (nonatomic, strong) UILabel               * titleview;
@property (nonatomic, strong) UIView                * titleline;
@property (nonatomic, strong) UIImageView           * startImg;
@property (nonatomic, strong) UILabel               * startLab;
@property (nonatomic, strong) UIButton              * startPerson;
@property (nonatomic, strong) UIImageView           * endImg;
@property (nonatomic, strong) UILabel               * endLab;
@property (nonatomic, strong) UIButton              * endPerson;
@property (nonatomic, strong) UILabel               * requirements;
@property (nonatomic, strong) UILabel               * orderNum1;
@property (nonatomic, strong) UILabel               * orderNum2;
@property (nonatomic, strong) UILabel               * orderState1;
@property (nonatomic, strong) UILabel               * orderState2;
@property (nonatomic, strong) UILabel               * orderStartTime1;
@property (nonatomic, strong) UILabel               * orderStartTime2;
@property (nonatomic, strong) UILabel               * orderCargo1;
@property (nonatomic, strong) UILabel               * orderCargo2;
@property (nonatomic, strong) UILabel               * orderBox1;
@property (nonatomic, strong) UILabel               * orderBox2;
@property (nonatomic, strong) UIView                * bottomView;
@property (nonatomic, strong) UIButton              * countermandBtn;
@property (nonatomic, strong) UIButton              * scanningBtn;
@property (nonatomic, strong) UIView                *viBackGround;
@property (nonatomic, strong) AlterView             *viAlter;
@property (nonatomic, strong) NSString              *stCode;
@property (nonatomic, strong) UITextField           *tfCode;
@end
@implementation OrderDetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单详情";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    [self.btnRight setTitle:@"查看地图" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 60, 30);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)setBillId:(int)billId
{
    _billId = billId;
}
- (void)loadData
{
    UserInfoModel * user = USER_INFO;
    WS(ws);
    OrderDetailsViewModel * vm = [[OrderDetailsViewModel alloc]init];

    [vm selectOrderWithUserId:user.iden WithBillid:self.billId callback:^(ZCTransportOrderModel *info) {
        ws.model = info;
        [ws bindModel];
        [ws bindView];
    }];
}
- (void)bindModel
{
//    self.titleview.text = @"系统任务";
//    
//    self.startLab.text = self.model.start_position;
//    
//    [self.startPerson setTitle:self.model.start_contacts forState:UIControlStateNormal];
//    self.endLab.text = self.model.end_position;
//    
//    [self.endPerson setTitle:self.model.end_contacts forState:UIControlStateNormal];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    self.requirements.text = [NSString stringWithFormat:@"要求%d天内运达",(int)(([[dateFormatter dateFromString:self.model.end_time] timeIntervalSinceDate:[dateFormatter dateFromString:self.model.expect_start_time]]) / 3600 /24) + 1];
//    
//    self.orderNum1.text = @"单号: ";
//    self.orderNum2.text = self.model.waybill_code;
//    self.orderState1.text = @"状态: ";
//    switch (self.model.waybill_status) {
//        case 0:
//            self.orderState2.text = @"未装载";
//            break;
//        case 1:
//            self.orderState2.text = @"在途";
//            break;
//        case 2:
//            self.orderState2.text = @"待结算";
//            self.btnRight.hidden = YES;
//            break;
//        case 3:
//            self.orderState2.text = @"已完成";
//            self.btnRight.hidden = YES;
//            break;
//        default:
//            break;
//    }
//    self.orderStartTime1.text = @"起运日期: ";
//    self.orderStartTime2.text = self.model.expect_start_time;
//    self.orderCargo1.text = @"货品: ";
//    self.orderCargo2.text = self.model.goods_class;
//    self.orderBox1.text = @"箱型: ";
//    self.orderBox2.text = self.model.container_type;
//    
//    if (self.model.waybill_status == 0)
//    {
//        [self.scanningBtn setTitle:@"装载扫描" forState:UIControlStateNormal];
//    }
//    else if(self.model.waybill_status == 1)
//    {
//        [self.scanningBtn setTitle:@"抵达扫描" forState:UIControlStateNormal];
//    }
//    else if(self.model.waybill_status == 2)
//    {
//        self.countermandBtn.hidden = YES;
//        self.scanningBtn.hidden = YES;
//    }

}
- (ZCTransportOrderModel *)model
{
    if (!_model) {
        _model = [ZCTransportOrderModel new];
    }
    return _model;
}

- (void)bindView
{
    self.bgScrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 60);
    [self.view addSubview:self.bgScrollView];
    
    self.titleview.frame = CGRectMake(0, 30, SCREEN_W - 30, 60);
    [self.bgView addSubview:self.titleview];
    
    self.titleline.frame = CGRectMake(20, CGRectGetMaxY(self.titleview.frame), SCREEN_W - 30 - 40, 2);
    [self.bgView addSubview:self.titleline];
    
    self.startImg.frame = CGRectMake(CGRectGetMinX(self.titleline.frame), CGRectGetMaxY(self.titleline.frame) + 20, 20, 20);
    [self.bgView addSubview:self.startImg];
    
    self.startLab.frame = CGRectMake(CGRectGetMaxX(self.startImg.frame) + 10, CGRectGetMinY(self.startImg.frame), 0.5 * (SCREEN_W - 30), [self.startLab.text boundingRectWithSize:CGSizeMake( 0.5 * (SCREEN_W - 30), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.startLab.font} context:nil].size.height);
    [self.bgView addSubview:self.startLab];
    
    self.startPerson.frame = CGRectMake((SCREEN_W - 30) - 30 - 0.25 * (SCREEN_W - 30), CGRectGetMinY(self.startLab.frame), 0.25 * (SCREEN_W - 30) + 15, 40);
    [self.bgView addSubview:self.startPerson];
    
    UIView * view1 = [self.startPerson viewWithTag:PHONEIMGTAG];
    view1.frame = CGRectMake(CGRectGetWidth(self.startPerson.frame)- 20*SCREEN_W_COEFFICIENT, CGRectGetHeight(self.startPerson.frame) / 2 - 10, 20, 20);
    
    self.endImg.frame = CGRectMake(CGRectGetMinX(self.titleline.frame), MAX(CGRectGetMaxY(self.startImg.frame), CGRectGetMaxY(self.startLab.frame)) + 20, 20, 25);
    [self.bgView addSubview:self.endImg];
    
    self.endLab.frame = CGRectMake(CGRectGetMinX(self.startLab.frame), CGRectGetMinY(self.endImg.frame), 0.5 * (SCREEN_W - 30), [self.endLab.text boundingRectWithSize:CGSizeMake( 0.5 * (SCREEN_W - 30), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.endLab.font} context:nil].size.height);
    [self.bgView addSubview:self.endLab];
    
    self.endPerson.frame = CGRectMake((SCREEN_W - 30) - 30 - 0.25 * (SCREEN_W - 30), CGRectGetMinY(self.endLab.frame), 0.25 * (SCREEN_W - 30) + 15, 40);
    [self.bgView addSubview:self.endPerson];
    
    UIView * view2 = [self.endPerson viewWithTag:PHONEIMGTAG];
    view2.frame = CGRectMake(CGRectGetWidth(self.endPerson.frame) - 20*SCREEN_W_COEFFICIENT, CGRectGetHeight(self.endPerson.frame) /2- 10, 20, 20);
    
    self.requirements.frame = CGRectMake(0, MAX(MAX(CGRectGetMaxY(self.endImg.frame), CGRectGetMaxY(self.endLab.frame)) + 20, CGRectGetMaxY(self.endPerson.frame)), (SCREEN_W - 30), 30);
    [self.bgView addSubview:self.requirements];
    
    self.orderNum1.frame = CGRectMake(0, CGRectGetMaxY(self.requirements.frame) + 10, 0.3 * (SCREEN_W - 30) - 10, 30);
    [self.bgView addSubview:self.orderNum1];
    
    self.orderNum2.frame = CGRectMake(CGRectGetMaxX(self.orderNum1.frame) + 10, CGRectGetMinY(self.orderNum1.frame), 0.7 * (SCREEN_W - 30), 30);
    [self.bgView addSubview:self.orderNum2];
    
    self.orderState1.frame = CGRectMake(0, CGRectGetMaxY(self.orderNum1.frame) + 10, 0.3 * (SCREEN_W - 30) - 10, 30);
    [self.bgView addSubview:self.orderState1];
    
    self.orderState2.frame = CGRectMake(CGRectGetMaxX(self.orderState1.frame) + 10, CGRectGetMinY(self.orderState1.frame), 0.7 * (SCREEN_W - 30), 30);
    [self.bgView addSubview:self.orderState2];
    
    self.orderStartTime1.frame = CGRectMake(0, CGRectGetMaxY(self.orderState1.frame) + 10, 0.3 * (SCREEN_W - 30) - 10, 30);
    [self.bgView addSubview:self.orderStartTime1];
    
    self.orderStartTime2.frame = CGRectMake(CGRectGetMaxX(self.orderStartTime1.frame) + 10, CGRectGetMinY(self.orderStartTime1.frame), 0.7 * (SCREEN_W - 30), 30);
    [self.bgView addSubview:self.orderStartTime2];
    
    self.orderCargo1.frame = CGRectMake(0, CGRectGetMaxY(self.orderStartTime1.frame) + 10, 0.3 * (SCREEN_W - 30) - 10, 30);
    [self.bgView addSubview:self.orderCargo1];
    
    self.orderCargo2.frame = CGRectMake(CGRectGetMaxX(self.orderCargo1.frame) + 10, CGRectGetMinY(self.orderCargo1.frame), 0.7 * (SCREEN_W - 30), 30);
    [self.bgView addSubview:self.orderCargo2];
    
    self.orderBox1.frame = CGRectMake(0, CGRectGetMaxY(self.orderCargo1.frame) + 10, 0.3 * (SCREEN_W - 30) - 10, 30);
    [self.bgView addSubview:self.orderBox1];
    
    self.orderBox2.frame = CGRectMake(CGRectGetMaxX(self.orderBox1.frame) + 10, CGRectGetMinY(self.orderBox1.frame), 0.7 * (SCREEN_W - 30), 30);
    [self.bgView addSubview:self.orderBox2];
    
    self.bgView.frame = CGRectMake(15, 20, SCREEN_W - 15,  MAX(CGRectGetHeight(self.bgScrollView.frame),CGRectGetMaxY(self.orderBox1.frame)) + 20);
    [self.bgScrollView addSubview:self.bgView];
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_W,CGRectGetMaxY(self.bgView.frame));
    
    self.bottomView.frame = CGRectMake(0, SCREEN_H - 64 - 60,  SCREEN_W, 60);
    [self.view addSubview:self.bottomView];
    
    self.countermandBtn.frame = CGRectMake(20, 10, SCREEN_W / 2 - 40, 40);
    [self.bottomView addSubview:self.countermandBtn];
    
    self.scanningBtn.frame = CGRectMake(SCREEN_W / 2 + 20, 10, SCREEN_W / 2 - 40, 40);
    [self.bottomView addSubview:self.scanningBtn];

    [self.view bringSubviewToFront:self.viBackGround];
    [self.view bringSubviewToFront:self.viAlter];
}
- (void)bindAction
{
    WS(ws);
    [[self.startPerson rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws callStartPerson];
    }];
    [[self.endPerson rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws callEndPerson];
    }];

    [[self.scanningBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws scan];
    }];


    [[self.countermandBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [[Toast shareToast]makeText:@"取消订单请联系客服" aDuration:1];
    }];
}

- (void)onRightAction {

    if ([[[UIDevice currentDevice] systemVersion] floatValue] <8.0){

        [[Toast shareToast]makeText:@"手机系统版本过低，请升级系统已支持导航" aDuration:1];
    }else {
        ZCMapViewController * vc = [[ZCMapViewController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }


}

/**
 *  扫描方法
 */
- (void)scan {


    WS(ws);
    QCodeViewController *QcVC = [QCodeViewController new];
    [self.navigationController pushViewController:QcVC animated:YES];

    [QcVC returnText:^(NSString *showText) {

        ws.stCode = showText;
        [ws finishShipment];
        
    }];
}
/**
 *  完成装载
 */

- (void)finishShipment {



//    self.viBackGround.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//    [self.view addSubview:self.viBackGround];
//    self.viAlter = [[AlterView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 140, 100, 280, 200 )];
//    [self.viAlter.btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.viAlter.btnCentain addTarget:self action:@selector(centainAction) forControlEvents:UIControlEventTouchUpInside];
//    if (!self.model.container_code) {
//
//
//        UILabel *lb = [UILabel new];
//        lb.text = @"请输入集装箱编号";
//        lb.textAlignment = NSTextAlignmentCenter;
//        lb.frame = CGRectMake(0, 30, 280, 40);
//        [self.viAlter addSubview:lb];
//
//
//        self.tfCode = [UITextField new];
//        self.tfCode.frame = CGRectMake(10, lb.bottom + 10, 260, 40);
//        self.tfCode.layer.borderWidth = 1;
//        self.tfCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [self.viAlter addSubview:self.tfCode];
//
//        [self.view addSubview:self.viAlter];
//
//    }else{
//
//
//        UILabel *lb = [UILabel new];
//        lb.text = @"集装箱编号";
//        lb.font = [UIFont systemFontOfSize:22];
//        lb.textAlignment = NSTextAlignmentCenter;
//        lb.frame = CGRectMake(0, 30, 280, 40);
//        [self.viAlter addSubview:lb];
//
//        UILabel *lbNo = [UILabel new];
//        lbNo.text = self.model.container_code;
//        lb.font = [UIFont systemFontOfSize:20];
//        lbNo.textAlignment = NSTextAlignmentCenter;
//        lbNo.frame = CGRectMake(0, 80, 280, 40);
//        lbNo.textColor = [UIColor grayColor];
//        [self.viAlter addSubview:lbNo];
//
//        [self.view addSubview:self.viAlter];


//    }



}

- (void)cancleAction {
    [self.viAlter removeFromSuperview];
    [self.viBackGround removeFromSuperview];
}
- (void)centainAction{
//
//    WS(ws);
//
//
//    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
//    if (!self.model.container_code) {
//
//        if ([self.tfCode.text isEqualToString:@""]) {
//
//            [[Toast shareToast]makeText:@"装箱码不能为空" aDuration:1];
//
//        }else{
//
//            NSString *searchText = self.tfCode.text;
//            NSError *error = NULL;
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9]{11}$" options:NSRegularExpressionCaseInsensitive error:&error];
//            NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//            if (result) {
//
//                [vm finishShipmentWithType:self.model.waybill_status WithQrcode:self.stCode WithBillid:self.billId WithOrderid:self.model.order_id WithContainercode: self.tfCode.text callback:^(NSString *message) {
//                    if (message) {
//                        ws.model.container_code = message;
//                        [ws loadData];
//                        [ws cancleAction];
//                    }
//                }];
//            }else{
//                [[Toast shareToast]makeText:@"装箱码必须为11位的数字或字母" aDuration:1];
//
//            }
//
//
//
//        }
//
//
//    }else{
//
//        [vm finishShipmentWithType:self.model.waybill_status WithQrcode:self.stCode WithBillid:self.billId WithOrderid:self.model.order_id WithContainercode: self.model.container_code callback:^(NSString *message) {
//            if (message) {
//                [ws loadData];
//                [ws cancleAction];
//                MarkViewController *vc =[MarkViewController new];
//                vc.billId = ws.billId;
//                [ws.navigationController pushViewController:vc animated:YES];
//                
//                
//                
//            }
//        }];
//        
//    }
}

/**
 *  getting(懒加载)
 *
 */
- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [UIScrollView new];
        _bgScrollView.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _bgScrollView;
}
- (UIImageView *)bgView
{
    if (!_bgView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"背景 (2)"];
        imageView.userInteractionEnabled = YES;
        _bgView = imageView;
    }
    return _bgView;
}

- (UILabel *)titleview
{
    if (!_titleview) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:30.0f];
        label.textAlignment = NSTextAlignmentCenter;
        _titleview = label;
    }
    return _titleview;
}

- (UIView *)titleline
{
    if (!_titleline) {
        _titleline = [UIView new];
        _titleline.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _titleline;
}
- (UIImageView *)startImg
{
    if (!_startImg) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"起点-拷贝"];
        _startImg = imageView;
    }
    return _startImg;
}
- (UILabel *)startLab
{
    if (!_startLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        _startLab = label;
    }
    return _startLab;
}
- (UIButton *)startPerson
{
    if (!_startPerson) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"ic_bluephone"];
        image.tag = PHONEIMGTAG;
        [button addSubview:image];
        _startPerson = button;
    }
    return _startPerson;
}
- (UIImageView *)endImg
{
    if (!_endImg) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"终点"];
        _endImg = imageView;
    }
    return _endImg;
}
- (UILabel *)endLab
{
    if (!_endLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.numberOfLines = 0;
        _endLab = label;
    }
    return _endLab;
}
- (UIButton *)endPerson
{
    if (!_endPerson) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"ic_bluephone"];
        image.tag = PHONEIMGTAG;
        [button addSubview:image];
        
        _endPerson = button;
    }
    return _endPerson;
}

- (UILabel *)requirements
{
    if (!_requirements) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        _requirements = label;
    }
    return _requirements;
}
- (UILabel *)orderNum1
{
    if (!_orderNum1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentRight;
        _orderNum1 = label;
    }
    return _orderNum1;
}
- (UILabel *)orderNum2
{
    if (!_orderNum2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        _orderNum2 = label;
    }
    return _orderNum2;
}
- (UILabel *)orderState1
{
    if (!_orderState1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentRight;
        _orderState1 = label;
    }
    return _orderState1;
}
- (UILabel *)orderState2
{
    if (!_orderState2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        _orderState2 = label;
    }
    return _orderState2;
}
- (UILabel *)orderStartTime1
{
    if (!_orderStartTime1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentRight;
        _orderStartTime1 = label;
    }
    return _orderStartTime1;
}
- (UILabel *)orderStartTime2
{
    if (!_orderStartTime2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        _orderStartTime2 = label;
    }
    return _orderStartTime2;
}

- (UILabel *)orderCargo1
{
    if (!_orderCargo1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentRight;
        _orderCargo1 = label;
    }
    return _orderCargo1;
}
- (UILabel *)orderCargo2
{
    if (!_orderCargo2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        _orderCargo2 = label;
    }
    return _orderCargo2;
}
- (UILabel *)orderBox1
{
    if (!_orderBox1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentRight;
        _orderBox1 = label;
    }
    return _orderBox1;
}
- (UILabel *)orderBox2
{
    if (!_orderBox2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        _orderBox2 = label;
    }
    return _orderBox2;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _bottomView;
}
- (UIButton *)countermandBtn
{
    if (!_countermandBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消运单" forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = APP_COLOR_BLUE.CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _countermandBtn = button;
    }
    return _countermandBtn;
}

- (UIButton *)scanningBtn
{
    if (!_scanningBtn) {
        UIButton *button = [[UIButton alloc]init];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _scanningBtn = button;
    }
    return _scanningBtn;
}

- (UIView *)viBackGround {
    if (!_viBackGround) {
        _viBackGround = [UIView new];
        _viBackGround.backgroundColor = [UIColor blackColor];
        _viBackGround.alpha = 0.7;
    }
    return _viBackGround;
}

-(void)callStartPerson
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否需要拨打%@电话:\n%@",self.model.start_contacts,self.model.start_contacts_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = CALLSTARTPERSON;
    [alert show];
}
-(void)callEndPerson
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否需要拨打%@电话:\n%@",self.model.end_contacts,self.model.end_contacts_phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = CALLENDPERSON;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        switch (alertView.tag) {
            case CALLSTARTPERSON:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.model.start_contacts_phone]]];
                break;
            case CALLENDPERSON:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.model.end_contacts_phone]]];
                break;
            default:
                break;
        }
    }
    
}
@end
