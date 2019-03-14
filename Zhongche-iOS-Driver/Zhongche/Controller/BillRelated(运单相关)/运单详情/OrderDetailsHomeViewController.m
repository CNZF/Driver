//
//  OrderDetailsHomeViewController.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "OrderDetailsHomeViewController.h"
#import "NameAddressTableViewCell.h"
#import "CodeTableViewCell.h"
#import "ListTableViewCell.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCMapViewController.h"
#import "ZCEWCodeViewController.h"
#import "AlterView.h"
#import "NSString+Money.h"
#import "SendBreakdownView.h"
#import "PeripheralServicesViewModel.h"
#import "ConfirmLoadAlertController.h"

@interface OrderDetailsHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_buttomConstant;

@property (nonatomic, strong) NSString    *endPointLat;
@property (nonatomic, strong) NSString    *endPointLng;

/**=============扫描==================*/
@property (nonatomic, strong) UIView      *viBackGround;
@property (nonatomic, strong) AlterView   *viAlter;
@property (nonatomic, strong) NSString    *stCode;
@property (nonatomic, strong) UITextField *tfCode;

@property (nonatomic, strong) ZCTransportOrderModel *myModel;
@end

@implementation OrderDetailsHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight  = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    [vm selectOrderDetailWithWillid:self.willId WithWaybillStatus:self.waybillStatus callback:^(ZCTransportOrderModel *info) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.pInfo) {
        self.btnRight.hidden = YES;
    }
    
    if (!self.pInfo) {
        
        [self getData];
    }else {
        
        double daytime = ([self.pInfo.endTime doubleValue] - [self.pInfo.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }
        
        /**
         *   "containerType": "20英尺通用集装箱",
         "capacity_apply_order_id": 37,
         "end_region_code": "370100",
         "start_address": "广东省广州市越秀区广州火车站",
         "end_address": "山东省济南市天桥区济南火车站",
         "start_contacts_phone": "13341195865",
         "start_region_code": "440100",
         "end_contacts": "李先生",
         "goods_name": "无烟块煤",
         "end_contacts_phone": "15350708905",
         "start_region": "广州",
         "start_contacts": "王先生",
         "endTime": 1473714000000,
         "type": 2, 1. 派单; 2. 抢单 ; 3. 外采',
         "waybill_group_id": 483,
         "waybillId": 1367,
         "startTime": 1473696000000,
         "end_region": "济南"
         */
//        self.arrTitle = @[[NSString stringWithFormat:@"接单类型：%@",@"抢单"],  [NSString stringWithFormat:@"计划载货时间：%@",[self stDateAndTimToString:self.pInfo.startTime ]], [NSString stringWithFormat:@"要求：%i天",(int)daytime], [NSString stringWithFormat:@"货品：%@",self.pInfo.goods_name], [NSString stringWithFormat:@"箱型： %@",self.pInfo.containerType]];
//        [self.tvList reloadData];
    }
    self.navigationController.navigationBar.hidden = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)getData {
    
    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    [vm selectOrderDetailWithWillid:self.willId WithWaybillStatus:self.waybillStatus callback:^(ZCTransportOrderModel *info) {
        
        //type==3 派单，否则，抢单
        //status == 3 待装载。 配送中
         ws.myModel = info;
        
        ws.endPointLat = info.start_lat;
        ws.endPointLng = info.start_lng;
        
        if ([ws.myModel.start_contacts isEqualToString:@""] || ws.myModel.start_contacts == nil) {
            ws.myModel.start_contacts = @"李先生";
            ws.myModel.start_contacts_phone = APP_CUSTOMER_SERVICE;
        }
        if ([ws.myModel.end_contacts isEqualToString:@""] || ws.myModel.end_contacts == nil) {
            ws.myModel.end_contacts = @"李先生";
            ws.myModel.end_contacts_phone = APP_CUSTOMER_SERVICE;
        }
        
        if (info.type  == 2) {
            [self.priceLabel setAttributedText:[NSString getFormartPrice:ws.myModel.price]];

        }else{
            ws.priceLabel.text = @"任务";
        }
        
        if (info.status == 3 ||info.status == 1) {
           
            [ws.leftBtn setTitle:@"忽略" forState:UIControlStateNormal];
            [ws.leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            if (info.is_accept == 0) {
                [ws.rightBtn setTitle:@"确认" forState:UIControlStateNormal];
            }else{
                [ws.rightBtn setTitle:@"确认装载" forState:UIControlStateNormal];
            }
        }else{
           [ws.leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            if(info.carrierStatus == 1) {
                [ws.leftBtn setTitle:@"解除故障" forState:UIControlStateNormal];
            }else{
                [ws.leftBtn setTitle:@"故障报警" forState:UIControlStateNormal];
            }
            [ws.rightBtn setTitle:@"确认抵达" forState:UIControlStateNormal];
        }
        

//        if (info.type == 2) {
//            [ws.btnScan setTitle:@"抢单" forState:UIControlStateNormal];
//            ws.btnRight.hidden = YES;
//            [ws.btnRefuse setTitle:@"忽略" forState:UIControlStateNormal];
//            if(info.status == 4){
//                [ws.btnRefuse setTitle:@"故障报警" forState:UIControlStateNormal];
//                if(info.carrierStatus == 1) {
//
//                    [ws.btnRefuse setTitle:@"解除报警" forState:UIControlStateNormal];
//
//                }
//
//            }
//        }
//
//        if (info.status == 3) {
////            ws.btnRight.hidden = NO;
//            [ws.btnScan setTitle:@"装载扫描" forState:UIControlStateNormal];
//            [ws.btnRefuse setTitle:@"忽略" forState:UIControlStateNormal];
//            ws.lbHead1.text = @"待装载";
//            ws.lbHead2.text = @"您还未装载货物，请按时载货";
//            ws.endPointLat = info.start_lat;
//            ws.endPointLng = info.start_lng;
//        }
//
        if (info.status == 4) {
            ws.btnRight.hidden = NO;
            [ws.rightBtn setTitle:@"确认抵达" forState:UIControlStateNormal];
            [ws.leftBtn setTitle:@"故障报警" forState:UIControlStateNormal];
            if(info.carrierStatus == 1) {

                [ws.leftBtn setTitle:@"解除故障" forState:UIControlStateNormal];

            }
        }
//
        if (info.status == 5) {
            ws.leftBtn.hidden = YES;
            ws.rightBtn.hidden = YES;
            ws.tableView_buttomConstant.constant = 0;
        }

//
//        if ((info.type == 1 || info.type == 3) && info.is_accept == 0) {
//            //显示按钮、图标、不显示价格
//            [ws.btnScan setTitle:@"确认" forState:UIControlStateNormal];
//            [ws.btnRefuse setTitle:@"拒绝" forState:UIControlStateNormal];
//
//            ws.lbHead1.text = @"任务";
//            ws.lbHead2.text = @"";
//            ws.endPointLat = info.start_lat;
//            ws.endPointLng = info.start_lng;
//
//        }
//        else if(info.status == 3 && info.is_accept == 1) {//&& model.is_accept == 1
//            [ws.btnScan setTitle:@"装载扫描" forState:UIControlStateNormal];
//
//            ws.endPointLat = info.start_lat;
//            ws.endPointLng = info.start_lng;
//
//        }
//        else if(info.status == 4 && info.is_accept == 1) {//&& model.is_accept == 1
//            //显示在途、按钮图标隐藏
//
//            [ws.btnScan setTitle:@"抵达扫描" forState:UIControlStateNormal];
//            ws.endPointLat = info.end_lat;
//            ws.endPointLng = info.end_lng;
//
//
//
//        }
//        else if(info.status == 5 && info.is_accept == 1) {//&& model.is_accept == 1
//            //显示在途、按钮图标隐藏
//
//            [ws.btnScan setTitle:@"抵达扫描" forState:UIControlStateNormal];
//            ws.endPointLat = info.end_lat;
//            ws.endPointLng = info.end_lng;
//        }

        
        [self.tableView reloadData];
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ||section == 1) {
        return 1;
    }else{
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws)
    if (indexPath.section == 0) {
        NameAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NameAddressTableViewCell" forIndexPath:indexPath];
        [cell setBlock:^(NSInteger index) {
            if (index == 0) {
                if (ws.myModel.start_contacts_phone) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",ws.myModel.start_contacts_phone]]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",APP_CUSTOMER_SERVICE]]];
                }
            }else{
                if (ws.myModel.end_contacts_phone) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",ws.myModel.end_contacts_phone]]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",APP_CUSTOMER_SERVICE]]];
                }
            }
        }];
        cell.model = self.myModel;
        return cell;
    }else if (indexPath.section == 1) {
        CodeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CodeTableViewCell" forIndexPath:indexPath];
        cell.model = self.myModel;
        return cell;
    }else{
        ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell" forIndexPath:indexPath];
        [cell setModelWith:self.myModel AndIndex:indexPath.row];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, SCREEN_W, 20);
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else{
        return 20.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ZCEWCodeViewController *vc = [ZCEWCodeViewController new];
        vc.title = @"运单二维码";
//        UserInfoModel * info = [UserInfoModel new];
        vc.message = [NSString stringWithFormat:@"%@",self.model.waybill_code];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)PressNaviLeft:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressMapBtn:(id)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <8.0){
        
        [[Toast shareToast]makeText:@"手机系统版本过低，请升级系统已支持导航" aDuration:1];
    }else {
        
        ZCMapViewController *vc = [ZCMapViewController new];
        if (!self.pInfo) {
            vc.model = self.myModel;
            vc.endPointLat = self.endPointLat;
            vc.endPointLng = self.endPointLng;
            
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)pressLeftBtn:(id)sender {
    UIButton * button = sender;
 
    if ([button.titleLabel.text isEqualToString:@"忽略"]) {
        [[Toast shareToast]makeText:@"运单无法放弃，请联系客服" aDuration:1];
    }else{
         [self breakUpAction];
    }
    
}
- (IBAction)pressrightBtn:(id)sender {
    
    UIButton * button = sender;
    if ([button.titleLabel.text isEqualToString:@"确认"]) {//推单状态
       [self qianOrder];
    }else{
        if (self.myModel.carrierStatus == 1){
            [[Toast shareToast] makeText:@"运单状态错误请联系客服" aDuration:1];
            return;
        }
        ConfirmLoadAlertController * controller = [ConfirmLoadAlertController alertWithModel:self.myModel target:self completion:^(BOOL success) {
           
        }];
        [controller setSuccessBlock:^(BOOL success) {
            if (success) {
                [self getData];
            }
        }];
        [self presentViewController:controller animated:NO completion:nil];
    }
    
    
}
- (void)qianOrder {
    
    WS(ws);
    
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UserInfoModel *userInfo = USER_INFO;
    [vm centerOrderWithIsAccept:1 WithWaybillId:self.model.waybill_id callback:^(NSString *st) {
        if ([st isEqualToString:@"10000"]) {
            [[Toast shareToast]makeText:@"任务已确定" aDuration:1];
            [self getData];
        }
        
        
    }];
//    if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {
//
//
//    }else {
//        [[Toast shareToast]makeText:@"资料审核中，暂时无法抢单" aDuration:1];
//    }
//    [vm receiveOrderWithPushModel:self.pInfo callback:^(NSString *st) {
//
//        if ([st isEqualToString:@"10000"]) {
//
//            [[Toast shareToast]makeText:@"已确认" aDuration:1];
//            [self getData];
//
//        }
//
//
//    }];
    

}

- (void)breakUpAction {
    
    
    UserInfoModel * user = USER_INFO;
    
    WS(ws);
    
    //carrierStatus 1已经报警 2 正常
    
    if (self.myModel.carrierStatus == 2) {
        
        SendBreakdownView *view = [SendBreakdownView sharePushOrderView];
        view.btnCertain.tag = view.index;
        
        [view.btnCertain addTarget:self action:@selector(certainAction:) forControlEvents:UIControlEventTouchUpInside];
        view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];
        
    }else{
    
        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.myModel.waybill_id WithReportcontent:@"cancle" WithDriverid:user.driverId WithType:1 WithWaybillCarrierId:self.myModel.waybill_carrier_id  callback:^{
            
            [self.leftBtn setTitle:@"故障报警" forState:UIControlStateNormal];
            ws.myModel.carrierStatus = 2;
            
        }];
        
    }
    
    
}

- (void)certainAction:(UIButton *)btn {
    
    UserInfoModel * user = USER_INFO;
    
    SendBreakdownView *view = [SendBreakdownView sharePushOrderView];
    [view removeFromSuperview];
    WS(ws);
    
    //CanNotFinish    MayFinish  CanFinish
    NSString *st;
    switch ((int)btn.tag) {
        case 0:
            st = @"CanNotFinish";
            break;
        case 1:
            st = @"MayFinish";
            break;
        case 2:
            st = @"CanFinish";
            break;
            
        default:
            break;
    }
    
    if (self.myModel.carrierStatus == 2) {
        
        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.myModel.waybill_id WithReportcontent:st WithDriverid:user.driverId WithType:0 WithWaybillCarrierId:self.myModel.waybill_carrier_id  callback:^{
            
            [self.leftBtn setTitle:@"解除报警" forState:UIControlStateNormal];
            ws.myModel.carrierStatus = 1;
            
        }];
        
    }else{
        
        
        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.myModel.waybill_id WithReportcontent:st WithDriverid:user.driverId WithType:1 WithWaybillCarrierId:self.myModel.waybill_carrier_id  callback:^{
            
            [self.leftBtn setTitle:@"故障报警" forState:UIControlStateNormal];
            ws.myModel.carrierStatus = 2;
            
        }];
        
    }
    
}

- (void)createAlertController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入集装箱编号" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        
        UITextField *userNameTextField = alertController.textFields.firstObject;
        [self asyncBillStateWithCode:userNameTextField.text];
    }]];
    
    
    //定义第一个输入框；
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入集装箱编号";
        
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}


- (void)asyncBillStateWithCode:(NSString *)str
{
//    WS(ws);
//    
//    
//    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
//    if (!self.myModel.container_code) {
//        
//        if ([str isEqualToString:@""]) {
//            
//            [[Toast shareToast]makeText:@"装箱码不能为空" aDuration:1];
//            
//        }else{
//            
//            NSString *searchText = str;
//            NSError *error = NULL;
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9]{11}$" options:NSRegularExpressionCaseInsensitive error:&error];
//            NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//            if (result) {
//                [vm finishShipmentWithType:0 WithQrcode:self.myModel.parentCode WithBillid:self.myModel.waybill_id WithContainercode:searchText callback:^(NSString *message) {
//                    if (message) {
//                        [[Toast shareToast]makeText:@"装载成功" aDuration:1];
////                        [ws getData];
//                    }
//                    
//                }];
//                
//            }else{
//                [[Toast shareToast]makeText:@"装箱码必须为11位的数字或字母" aDuration:1];
//                
//            }
//            
//        }
//    }else{
//        
//        
//        [vm finishShipmentWithType:1 WithQrcode:self.myModel.parentCode WithBillid:self.myModel.waybill_id WithContainercode:self.myModel.container_code callback:^(NSString *message) {
//            if (message) {
//                [[Toast shareToast]makeText:@"抵达成功" aDuration:1];
////                [self cancleAction];
//                [ws getData];
//            }
//            
//        }];
////        
//    }
}



/**
 *  完成装载
 */
- (void)finishShipment {
    
    self.viBackGround = [[UIView alloc]init];
    self.viBackGround.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.viBackGround.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [MAIN_WINDOW addSubview:self.viBackGround];
    
    self.viAlter = [[AlterView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 140, SCREEN_H/2-100, 280, 200 )];
    [self.viAlter.btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viAlter.btnCentain addTarget:self action:@selector(centainAction) forControlEvents:UIControlEventTouchUpInside];
    if (!self.myModel.container_code) {
        
        
        UILabel *lb = [UILabel new];
        lb.text = @"请输入集装箱编号";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.frame = CGRectMake(0, 30, 280, 40);
        [self.viAlter addSubview:lb];
        
        
        self.tfCode = [UITextField new];
        self.tfCode.frame = CGRectMake(10, lb.bottom + 10, 260, 40);
        self.tfCode.layer.borderWidth = 1;
        self.tfCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.viAlter addSubview:self.tfCode];
        
        [self.viBackGround addSubview:self.viAlter];
        
    }else{
        
        
        UILabel *lb = [UILabel new];
        lb.text = @"集装箱编号";
        lb.font = [UIFont systemFontOfSize:22];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.frame = CGRectMake(0, 30, 280, 40);
        [self.viAlter addSubview:lb];
        
        UILabel *lbNo = [UILabel new];
        lbNo.text = self.myModel.container_code;
        lb.font = [UIFont systemFontOfSize:20];
        lbNo.textAlignment = NSTextAlignmentCenter;
        lbNo.frame = CGRectMake(0, 80, 280, 40);
        lbNo.textColor = [UIColor grayColor];
        [self.viAlter addSubview:lbNo];
        
        [self.viBackGround addSubview:self.viAlter];
    }
}
- (void)cancleAction {
    [self.viAlter removeFromSuperview];
    [self.viBackGround removeFromSuperview];
}

- (void)centainAction{
    
    [self.viAlter removeFromSuperview];
    [self.viBackGround removeFromSuperview];
    
    if (self.myModel.carrierStatus == 1) {
        [[Toast shareToast] makeText:@"运单状态错误请联系客服" aDuration:1];
        return;
    }
    
    WS(ws);
    
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    if (!self.myModel.container_code) {
        
        if ([self.tfCode.text isEqualToString:@""]) {
            
            [[Toast shareToast]makeText:@"装箱码不能为空" aDuration:1];
            
        }else{
            
            NSString *searchText = self.tfCode.text;
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9]{11}$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (result) {
                [vm finishShipmentWithType:0 WithQrcode:self.myModel.parentCode WithBillid:self.myModel.waybill_id WithContainercode:searchText callback:^(NSString *message) {
                    if (message) {
                        [[Toast shareToast]makeText:@"装载成功" aDuration:1];
                        [self cancleAction];
                        [ws getData];
                    }
                }];
                
            }else{
                [[Toast shareToast]makeText:@"装箱码必须为11位的数字或字母" aDuration:1];
                
            }
            
        }
    }else{
        
        
        [vm finishShipmentWithType:1 WithQrcode:self.stCode WithBillid:self.myModel.waybill_id WithContainercode:self.myModel.container_code callback:^(NSString *message) {
            if (message) {
                [[Toast shareToast]makeText:@"抵达成功" aDuration:1];
                [self cancleAction];
                [ws getData];
            }
            
        }];
        
    }
}

@end
