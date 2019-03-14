//
//  ZCOrderDetailsViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/1.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCOrderDetailsViewController.h"
#import "ZCCityTableViewCell.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCTransportOrderModel.h"
#import "QCodeViewController.h"
#import "AlterView.h"
#import "ZCMapViewController.h"
#import "ZCEWCodeViewController.h"
#import "PeripheralServicesViewModel.h"
#import "SendBreakdownView.h"

@interface ZCOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView                *viHead;
@property (nonatomic, strong) UITableView           *tvList;
@property (nonatomic, strong) UILabel               *lbHead1;
@property (nonatomic, strong) UILabel               *lbHead2;
@property (nonatomic, strong) UIImageView           *ivHead;//二维码
@property (nonatomic, strong) NSArray               *arrTitle;
@property (nonatomic, strong) UILabel               *lbBottom;
@property (nonatomic, strong) UIButton              *btnRefuse;
@property (nonatomic, strong) UIButton              *btnScan;
@property (nonatomic, strong) ZCTransportOrderModel *myModel;
@property (nonatomic, strong) UIButton              *btnEWM;

/**=============扫描==================*/
@property (nonatomic, strong) UIView      *viBackGround;
@property (nonatomic, strong) AlterView   *viAlter;
@property (nonatomic, strong) NSString    *stCode;
@property (nonatomic, strong) UITextField *tfCode;

@property (nonatomic, strong) NSString    *endPointLat;
@property (nonatomic, strong) NSString    *endPointLng;



@end

@implementation ZCOrderDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


        if (self.pInfo) {
            self.btnRight.hidden = YES;
        }
        
    self.arrTitle = @[@"运单号：",@"接单类型： 系统派单", @"计划载货时间： 2016-05-16 10:00", @"要求： 在三天内运达", @"货品： 仪表仪器",@"箱型： 20英寸集装箱", @"运力出售单：YL2130089900", @"任务来源：平台购买运力"];

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
         self.arrTitle = @[[NSString stringWithFormat:@"接单类型：%@",@"抢单"],  [NSString stringWithFormat:@"计划载货时间：%@",[self stDateAndTimToString:self.pInfo.startTime ]], [NSString stringWithFormat:@"要求：%i天",(int)daytime], [NSString stringWithFormat:@"货品：%@",self.pInfo.goods_name], [NSString stringWithFormat:@"箱型： %@",self.pInfo.containerType]];
        [self.tvList reloadData];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.btnRight.hidden = NO;

    [self.btnRight setImage:[UIImage imageNamed:@"btnAddress"] forState:UIControlStateNormal];

    [self.btnRight setFrame:CGRectMake(0, 0, 25, 26)];
}

- (void)bindView {


    self.title = @"运单详情";
    if (self.pInfo) {
        self.btnRight.hidden = YES;
    }




    [self HeadViewMake];

    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 120);

    self.tvList.tableHeaderView = self.viHead;


    [self.view addSubview:self.tvList];

    self.lbBottom.frame = CGRectMake(0, SCREEN_H  - 140, SCREEN_W, 100);
    [self.view addSubview:self.lbBottom];

    self.btnRefuse.frame =CGRectMake(20, SCREEN_H  - 125, SCREEN_W/2 - 30, 44);
    [self.view addSubview:self.btnRefuse];

    self.btnScan.frame =CGRectMake(self.btnRefuse.right + 20, SCREEN_H  - 125, SCREEN_W/2 - 30, 44);
    [self.view addSubview:self.btnScan];




}


- (void)bindModel {



}

- (void)getData {

    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    [vm selectOrderDetailWithWillid:self.willId WithWaybillStatus:self.waybillStatus callback:^(ZCTransportOrderModel *info) {

        ws.myModel = info;
        if ([ws.myModel.start_contacts isEqualToString:@""]) {
            ws.myModel.start_contacts = @"李先生";
            ws.myModel.start_contacts_phone = APP_CUSTOMER_SERVICE;
        }
        if ([ws.myModel.end_contacts isEqualToString:@""]) {
            ws.myModel.end_contacts = @"李先生";
            ws.myModel.end_contacts_phone = APP_CUSTOMER_SERVICE;
        }

        if (info.type == 2) {
            [ws.btnScan setTitle:@"抢单" forState:UIControlStateNormal];
            ws.btnRight.hidden = YES;
            [ws.btnRefuse setTitle:@"忽略" forState:UIControlStateNormal];
            if(info.status == 4){
                [ws.btnRefuse setTitle:@"故障报警" forState:UIControlStateNormal];
                if(info.carrierStatus == 1) {

                    [ws.btnRefuse setTitle:@"解除报警" forState:UIControlStateNormal];
                    
                }

            }
        }

        if (info.status == 3) {
             ws.btnRight.hidden = NO;
            [ws.btnScan setTitle:@"装载扫描" forState:UIControlStateNormal];
            [ws.btnRefuse setTitle:@"忽略" forState:UIControlStateNormal];
            ws.lbHead1.text = @"待装载";
            ws.lbHead2.text = @"您还未装载货物，请按时载货";
            ws.endPointLat = info.start_lat;
            ws.endPointLng = info.start_lng;
        }

        if (info.status == 4) {
             ws.btnRight.hidden = NO;
            [ws.btnScan setTitle:@"抵达扫描" forState:UIControlStateNormal];
            [ws.btnRefuse setTitle:@"故障报警" forState:UIControlStateNormal];
            if(info.carrierStatus == 1) {

                [ws.btnRefuse setTitle:@"解除报警" forState:UIControlStateNormal];

            }
            ws.lbHead1.text = @"在途";
            ws.lbHead2.text = @"您已经载货出发，一路平安";
            ws.endPointLat = info.end_lat;
            ws.endPointLng = info.end_lng;
        }

        if (info.status == 5) {
            ws.btnRight.hidden = NO;
            ws.btnScan.hidden = YES;
            ws.btnRefuse.hidden = YES;
            ws.lbBottom.hidden = YES;
            ws.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
            ws.lbHead1.text = @"已抵达";
            ws.lbHead2.text = @"您已经安全抵达，辛苦了";

        }

        if (info.status == 6) {
             ws.btnRight.hidden = NO;
            ws.btnScan.hidden = YES;
            ws.btnRefuse.hidden = YES;
            ws.lbBottom.hidden = YES;
            ws.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
            ws.lbHead1.text = @"已完成";
            ws.lbHead2.text = @"运单完成，希望今后继续合作";

        }

        if ((info.type == 1 || info.type == 3) && info.is_accept == 0) {
            //显示按钮、图标、不显示价格
            [ws.btnScan setTitle:@"确认" forState:UIControlStateNormal];
            [ws.btnRefuse setTitle:@"拒绝" forState:UIControlStateNormal];

            ws.lbHead1.text = @"任务";
            ws.lbHead2.text = @"";
            ws.endPointLat = info.start_lat;
            ws.endPointLng = info.start_lng;

        }
        else if(info.status == 3 && info.is_accept == 1) {//&& model.is_accept == 1
            [ws.btnScan setTitle:@"装载扫描" forState:UIControlStateNormal];

            ws.endPointLat = info.start_lat;
            ws.endPointLng = info.start_lng;

        }
        else if(info.status == 4 && info.is_accept == 1) {//&& model.is_accept == 1
            //显示在途、按钮图标隐藏

           [ws.btnScan setTitle:@"抵达扫描" forState:UIControlStateNormal];
           ws.endPointLat = info.end_lat;
           ws.endPointLng = info.end_lng;



       }
        else if(info.status == 5 && info.is_accept == 1) {//&& model.is_accept == 1
            //显示在途、按钮图标隐藏

            [ws.btnScan setTitle:@"抵达扫描" forState:UIControlStateNormal];
            ws.endPointLat = info.end_lat;
            ws.endPointLng = info.end_lng;
        }

        [NSString stringWithFormat:@"计划载货时间：%@",[ws stDateAndTimToString:ws.myModel.startTime ]];


        double daytime = ([info.endTime doubleValue] - [info.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }

        NSString *type;
        switch (info.type) {
            case 1:
                type = @"任务";
                ws.ivHead.hidden = YES;
                break;

            case 2:
                type = @"抢单";
                break;

            case 3:
                type = @"任务";
                ws.ivHead.hidden = YES;
                break;

            default:
                break;
        }


        float distance = [self distanceWithStartlat:ws.myModel.start_region_center_lat WithStartlng:ws.myModel.start_region_center_lng WithEndlat:ws.myModel.end_region_center_lat WithEndlng:ws.myModel.end_region_center_lng];

        NSString *stDistance;

        if (distance >0) {

            stDistance = [NSString stringWithFormat:@"距离：约%.0f公里",distance];

        }else {

            stDistance = @"距离：同城";
        }

        ws.arrTitle = @[stDistance,[NSString stringWithFormat:@"运单号：%@",ws.myModel.waybill_code],[NSString stringWithFormat:@"接单类型：%@",type],  [NSString stringWithFormat:@"计划载货时间：%@",[ws stDateAndTimToString:ws.myModel.startTime ]], [NSString stringWithFormat:@"要求：%i天",(int)daytime], [NSString stringWithFormat:@"货品：%@",ws.myModel.goods_name], [NSString stringWithFormat:@"箱型： %@",ws.myModel.containerType]];

        if (info.status == 5 ||info.status == 6) {

             ws.arrTitle = @[stDistance,[NSString stringWithFormat:@"运单号：%@",ws.myModel.waybill_code],[NSString stringWithFormat:@"接单类型：%@",type],  [NSString stringWithFormat:@"实际到达时间：%@",[ws stDateAndTimToString:ws.myModel.endTime ]], [NSString stringWithFormat:@"要求：%i天",(int)daytime], [NSString stringWithFormat:@"货品：%@",ws.myModel.goods_name], [NSString stringWithFormat:@"箱型： %@",ws.myModel.containerType]];


        }

        
        [ws.tvList reloadData];


        
    }];

}

- (void)bindAction {

    WS(ws);

    [self.btnScan addTarget:self action:@selector(btnScanAction) forControlEvents:UIControlEventTouchUpInside];

    [[self.btnRefuse rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        if (ws.pInfo) {

            [ws.navigationController popViewControllerAnimated:YES];

        }else {

              if (self.myModel.status == 4) {

                  [ws breakUpAction];


              }else {


                  if([ws.btnRefuse.titleLabel.text isEqualToString:@"忽略"]){

                   [[Toast shareToast]makeText:@"运单无法放弃，请联系客服" aDuration:1];
                  }
                  if([ws.btnRefuse.titleLabel.text isEqualToString:@"拒绝"]){


                      [[Toast shareToast]makeText:@"任务无法拒绝" aDuration:1];

                  }

              }


            
        }


    }];

    [[self.btnEWM rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        ZCEWCodeViewController *vc = [ZCEWCodeViewController new];
        vc.message = ws.myModel.order_code;

        [ws.navigationController pushViewController:vc animated:YES];
    }];
}

- (void) HeadViewMake {

    self.lbHead1.frame = CGRectMake(20, 30, SCREEN_W - 20 , 20);
    [self.viHead addSubview:self.lbHead1];

    self.lbHead2.frame = CGRectMake(20, self.lbHead1.bottom + 20, SCREEN_W - 20, 20);
    [self.viHead addSubview:self.lbHead2];


    self.ivHead.frame  =CGRectMake(SCREEN_W - 55, 30, 35, 35);
    [self.viHead addSubview:self.ivHead];

    self.btnEWM.frame  =CGRectMake(SCREEN_W - 55, 30, 35, 35);
    [self.viHead addSubview:self.btnEWM];





}

- (void) btnScanAction {

    if (self.type == 1 || self.type == 3) {
        [self centainOrder];
    }

    else if (self.pInfo) {


        [self qianOrder];

    }else {

        [self scan];
        
    }



}

- (void)centainOrder{

    WS(ws);


    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];


    [vm centerOrderWithIsAccept:1 WithWaybillId:self.myModel.waybill_id callback:^(NSString *st) {

        [[Toast shareToast]makeText:@"已经确认订单" aDuration:1];
        [ws.navigationController popViewControllerAnimated:YES];

        [ws getData];
        
    }];
    
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

             [ws.btnRefuse setTitle:@"故障报警" forState:UIControlStateNormal];
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

            [ws.btnRefuse setTitle:@"解除报警" forState:UIControlStateNormal];
            ws.myModel.carrierStatus = 1;

        }];

    }else{


        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.myModel.waybill_id WithReportcontent:st WithDriverid:user.driverId WithType:1 WithWaybillCarrierId:self.myModel.waybill_carrier_id  callback:^{

            [ws.btnRefuse setTitle:@"故障报警" forState:UIControlStateNormal];
            ws.myModel.carrierStatus = 2;
            
        }];
        
    }
    
}

/**
 *  扫描方法
 */
- (void)scan{


    WS(ws);
    QCodeViewController *QcVC = [QCodeViewController new];
    [self.navigationController pushViewController:QcVC animated:YES];

    [QcVC returnText:^(NSString *showText) {

        ws.stCode = showText;
        if ([ws.stCode isEqualToString:ws.myModel.parentCode]) {

            [ws finishShipment];
        }else {
            [[Toast shareToast]makeText:@"二维码无效" aDuration:1];
        }

    }];
}

- (void)qianOrder {

    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UserInfoModel *userInfo = USER_INFO;

    if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {

        [vm receiveOrderWithPushModel:self.pInfo callback:^(NSString *st) {

            if ([st isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"已抢单" aDuration:1];
                
            }

            [ws.navigationController popViewControllerAnimated:YES];
            
        }];

    }else {
        [[Toast shareToast]makeText:@"资料审核中，暂时无法抢单" aDuration:1];
    }



}
/**
 *  完成装载
 */
- (void)finishShipment {



    self.viBackGround.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:self.viBackGround];
    self.viAlter = [[AlterView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 140, 100, 280, 200 )];
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

        [self.view addSubview:self.viAlter];

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
        
        [self.view addSubview:self.viAlter];
    }
}

- (void)cancleAction {
    [self.viAlter removeFromSuperview];
    [self.viBackGround removeFromSuperview];
}

- (void)centainAction{

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

                if ([self.stCode isEqualToString:self.myModel.parentCode]) {
                    [vm finishShipmentWithType:0 WithQrcode:self.stCode WithBillid:self.myModel.waybill_id WithContainercode:searchText callback:^(NSString *message) {
                        if (message) {
                            [[Toast shareToast]makeText:@"装载成功" aDuration:1];
                            [self cancleAction];
                            [ws getData];
                        }

                    }];
                }else {
                    [[Toast shareToast]makeText:@"二维码无效" aDuration:1];
                }

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


- (void)phoneAction:(UIButton *)btn {

    if (btn.tag == 0) {

        if (self.pInfo) {
            self.stTelephone = self.pInfo.start_contacts_phone;

            [self showAlertViewWithTitle:[NSString stringWithFormat:@"打电话给%@?",self.pInfo.start_contacts] WithMessage:[NSString stringWithFormat:@"电话:%@",self.pInfo.start_contacts_phone]];
        }else {
            self.stTelephone = self.myModel.start_contacts_phone;

            [self showAlertViewWithTitle:[NSString stringWithFormat:@"打电话给%@?",self.myModel.start_contacts] WithMessage:[NSString stringWithFormat:@"电话:%@",self.myModel.start_contacts_phone]];

        }

    }else {

        if (self.pInfo) {
            self.stTelephone = self.pInfo.end_contacts_phone;

            [self showAlertViewWithTitle:[NSString stringWithFormat:@"打电话给%@?",self.pInfo.end_contacts] WithMessage:[NSString stringWithFormat:@"电话:%@",self.pInfo.end_contacts_phone]];
        }else {

        self.stTelephone = self.myModel.end_contacts_phone;

        [self showAlertViewWithTitle:[NSString stringWithFormat:@"打电话给%@?",self.myModel.end_contacts] WithMessage:[NSString stringWithFormat:@"电话:%@",self.myModel.end_contacts_phone]];
        }
    }


}

- (void)onRightAction {


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



/**
 *
 *  @param tableView delegate
 *
 *  @return
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {

        return self.arrTitle.count;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        return 100;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Celled";

    if (indexPath.section == 0) {

        ZCCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZCCityTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

//        if ([self.myModel.start_contacts isEqualToString:@""]) {
//            <#statements#>
//        }

        if (indexPath.row == 0) {

            cell.ivlogo.image = [UIImage imageNamed:@"startPoint"];
            cell.ivPhone.image = [UIImage imageNamed:@"startphone"];

            if(self.pInfo){

                cell.lbCty.text = self.pInfo.start_region;
                cell.lbAddress.text = self.pInfo.start_address;
                cell.lbName.text = self.pInfo.start_contacts;
                cell.btnPhone.tag = 0;

            }else{
                cell.lbCty.text = self.myModel.start_region_name;
                cell.lbAddress.text = self.myModel.start_address;
                cell.lbName.text = self.myModel.start_contacts;
                cell.btnPhone.tag = 0;
            }


        }else{

            if(self.pInfo){

                cell.lbCty.text = self.pInfo.end_region;
                cell.ivlogo.image = [UIImage imageNamed:@"endPoint"];
                cell.ivPhone.image = [UIImage imageNamed:@"endphone"];
                cell.lbAddress.text = self.pInfo.end_address;
                cell.lbName.text = self.pInfo.end_contacts;
                cell.btnPhone.tag = 1;

            }else {

                cell.lbCty.text = self.myModel.end_region_name;
                cell.ivlogo.image = [UIImage imageNamed:@"endPoint"];
                cell.ivPhone.image = [UIImage imageNamed:@"endphone"];
                cell.lbAddress.text = self.myModel.end_address;
                cell.lbName.text = self.myModel.end_contacts;
                cell.btnPhone.tag = 1;

            }




        }

          [cell.btnPhone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];

        if (self.myModel.type == 1 ||self.myModel.type == 3) {
            cell.ivPhone.hidden = YES;
            cell.lbName.hidden = YES;
            cell.btnPhone.hidden = YES;
        }


        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];


            NSRange range;
            NSString *tmpStr = [self.arrTitle objectAtIndex:indexPath.row];


            range = [tmpStr rangeOfString:@"："];

            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tmpStr];


            [AttributedStr addAttribute:NSForegroundColorAttributeName

                                  value:[UIColor grayColor]
             
                                  range:NSMakeRange(range.location,tmpStr.length - range.location)];
            
            cell.textLabel.attributedText = AttributedStr;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            

        return cell;
    }


    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{



}

/**
 *  getter(懒加载)
 */
- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = APP_COLOR_PURPLE;
    }
    return _viHead;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140) style:UITableViewStyleGrouped];
        tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;

        _tvList = tableView;
    }
    return _tvList;
}

- (UILabel *)lbHead1 {
    if (!_lbHead1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:23.0f];
        label.text = @"待装载";
        if (self.pInfo) {
            label.text = [NSString stringWithFormat:@"￥%i",self.pInfo.price];
        }

        _lbHead1 = label;
    }
    return _lbHead1;
}

- (UILabel *)lbHead2 {
    if (!_lbHead2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:14.0f];
        }




        _lbHead2 = label;
    }
    return _lbHead2;
}

- (UIImageView *)ivHead {
    if (!_ivHead) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"erweima"];

        _ivHead = imageView;
    }
    return _ivHead;
}


- (UILabel *)lbBottom {
    if (!_lbBottom) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.shadowOffset =  CGSizeMake(1, 1);
        label.layer.shadowOpacity = 0.8;
        label.layer.shadowColor =  [UIColor grayColor].CGColor;


        _lbBottom = label;
    }
    return _lbBottom;
}


- (UIButton *)btnRefuse {
    if (!_btnRefuse) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消" forState:UIControlStateNormal];

        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnRefuse = button;
    }
    return _btnRefuse;
}

- (UIButton *)btnScan {
    if (!_btnScan) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"抢单" forState:UIControlStateNormal];


        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnScan = button;
    }
    return _btnScan;
}


- (UIView *)viBackGround {
    if (!_viBackGround) {
        _viBackGround = [UIView new];
        _viBackGround.backgroundColor = [UIColor blackColor];
        _viBackGround.alpha = 0.7;
    }
    return _viBackGround;
}

- (UIButton *)btnEWM {
    if (!_btnEWM) {
        UIButton *button = [[UIButton alloc]init];


        _btnEWM = button;
    }
    return _btnEWM;
}



@end
