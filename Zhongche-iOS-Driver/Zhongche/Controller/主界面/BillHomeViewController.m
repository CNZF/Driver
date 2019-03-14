//
//  BillHomeViewController.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "BillHomeViewController.h"
#import "BillHomeTableViewCell.h"
#import "ZCTransportOrderViewModel.h"
#import "UserOrderSqlite.h"
#import "ZCTransportOrderModel.h"
#import "ZCOrderDetailsViewController.h"
#import "OrderDetailsHomeViewController.h"
#import "NoBillDataView.h"
#import "AlterView.h"
#import "AppDelegate.h"
#import "NotificationConstant.h"
#import "ConfirmLoadAlertController.h"

@interface BillHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

//视图
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, strong) NoBillDataView * noBillDataview;

//数据
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) ZCTransportOrderModel * myModel;

//模块视图及数据
///**=============扫描==================*/
//@property (nonatomic, strong) UIView      *viBackGround;
//@property (nonatomic, strong) AlterView   *viAlter;
//@property (nonatomic, strong) NSString    *stCode;
//@property (nonatomic, strong) UITextField *tfCode;

@end

@implementation BillHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BillHomeRefreshData) name:@"BillHomeRefreshData" object:nil];
    
    [self setViewAttribute];
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDate];
    }];
    
}

- (void) setViewAttribute{
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //导航栏下移
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)BillHomeRefreshData
{
    [self getDate];
}

- (void)getDate{
    
    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UserInfoModel *info = USER_INFO;
    
    [vm selectOrderWithType:0 WithDriverid:[info.driverId intValue] callback:^(NSMutableArray *arrInfo) {
        
        if (arrInfo.count >0) {
            ws.dataArray  = [[NSMutableArray alloc] initWithArray:arrInfo];
            UserOrderSqlite *model = [UserOrderSqlite shareUserOrderSqlite];
            NSArray *arr = [model selectAllOrderData];
            [self.dataArray addObjectsFromArray:arr];
            if (ws.dataArray.count > 0) {
                [ws.tableView reloadData];
            }else{
                [[Toast shareToast]makeText:@"暂无订单" aDuration:1];
            }
        }
        [ws.tableView.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BillHomeTableViewCell" forIndexPath:indexPath];
    [cell setBlock:^(ZCTransportOrderModel *model,NSString * stateTitle) {
        self.myModel = model;
        
        if ([stateTitle isEqualToString:@"接受任务"]) {
            [self qianOrder:model];
        }else{
            [self finishShipment];
        }
    }];
    ZCTransportOrderModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCOrderDetailsViewController *vc= [ZCOrderDetailsViewController new];
//
//    if(self.dataArray.count >0) {
//        BaseModel *model = [self.dataArray objectAtIndex:indexPath.row];
//        if ([model isKindOfClass:[ZCTransportOrderModel class]]) {
//            ZCTransportOrderModel *info = [self.dataArray objectAtIndex:indexPath.row];
//            if ((info.type == 1 || info.type == 3) && info.is_accept == 0) {
//                vc.type = 1;
//            }
//            vc.willId = info.waybill_id;
//            vc.waybillStatus = [NSString stringWithFormat:@"%i",info.status];
//        }else {
//
//            PushModel *info = [self.dataArray objectAtIndex:indexPath.row];
//            vc.pInfo = info;

//        }
//    }
//
//
//
//    [self.navigationController pushViewController:vc animated:YES];
    
    OrderDetailsHomeViewController * controller = [[UIStoryboard storyboardWithName:@"Business" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderDetailsHomeViewController"];
    
        if(self.dataArray.count >0) {
            ZCTransportOrderModel *model = [self.dataArray objectAtIndex:indexPath.row];
            controller.model  = model;
//            if ([model isKindOfClass:[ZCTransportOrderModel class]]) {
//                ZCTransportOrderModel *info = [self.dataArray objectAtIndex:indexPath.row];
//                if ((info.type == 1 || info.type == 3) && info.is_accept == 0) {
                    controller.type = 1;
//                }
                controller.willId = model.waybill_id;
                controller.waybillStatus = [NSString stringWithFormat:@"%i",model.status];
//            }else {
//
//                PushModel *info = [self.dataArray objectAtIndex:indexPath.row];
//                controller.pInfo = info;
//
//            }

        }
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count>0) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 24)];
        view.backgroundColor = [HelperUtil colorWithHexString:@"EBEBEB"];
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if (self.dataArray.count>0) {
         return 24;
     }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return SCREEN_H-60;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.dataArray.count == 0  ) {
        return self.noBillDataview;
    }else{
        return [UIView new];
    }
}

- (void)RefrenshData
{
    [self.tableView.mj_header beginRefreshing];
}

- (NoBillDataView *)noBillDataview
{
    if (!_noBillDataview) {
        _noBillDataview = [[[NSBundle mainBundle] loadNibNamed:@"NoBillDataView" owner:self options:nil] firstObject];
        _noBillDataview.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-60);
    }
    return _noBillDataview;
}


- (void)qianOrder:(ZCTransportOrderModel *)model{
    
    WS(ws);
    
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    [vm centerOrderWithIsAccept:1 WithWaybillId:model.waybill_id callback:^(NSString *st) {
        if ([st isEqualToString:@"10000"]) {
            [[Toast shareToast]makeText:@"任务已确定" aDuration:1];
            [self RefrenshData];
        }else{
            [[Toast shareToast]makeText:@"任务接受失败，请联系管理员" aDuration:1];
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

/**
 *  完成装载
 */
- (void)finishShipment {

    if (self.myModel.carrierStatus == 1){
        [[Toast shareToast] makeText:@"运单状态错误请联系客服" aDuration:1];
        return;
    }
    ConfirmLoadAlertController * controller = [ConfirmLoadAlertController alertWithModel:self.myModel target:self completion:^(BOOL success) {
        
    }];
    [controller setSuccessBlock:^(BOOL success) {
        if (success) {
             [self RefrenshData];
        }
    }];
    [self presentViewController:controller animated:NO completion:nil];
}

//    return;
//    self.viBackGround = [[UIView alloc]init];
//    self.viBackGround.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//    self.viBackGround.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    [MAIN_WINDOW addSubview:self.viBackGround];
//
//    self.viAlter = [[AlterView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 140, SCREEN_H/2-100, 280, 200 )];
//    [self.viAlter.btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.viAlter.btnCentain addTarget:self action:@selector(centainAction) forControlEvents:UIControlEventTouchUpInside];
//    if (!self.myModel.container_code) {
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
//        [self.viBackGround addSubview:self.viAlter];
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
//        lbNo.text = self.myModel.container_code;
//        lb.font = [UIFont systemFontOfSize:20];
//        lbNo.textAlignment = NSTextAlignmentCenter;
//        lbNo.frame = CGRectMake(0, 80, 280, 40);
//        lbNo.textColor = [UIColor grayColor];
//        [self.viAlter addSubview:lbNo];
//
//        [self.viBackGround addSubview:self.viAlter];
//    }
//}
//
//- (void)cancleAction {
//    [self.viAlter removeFromSuperview];
//    [self.viBackGround removeFromSuperview];
//}
//
//- (void)centainAction{
//
//    [self.viAlter removeFromSuperview];
//    [self.viBackGround removeFromSuperview];
//
//    if (self.myModel.carrierStatus == 1) {
//        [[Toast shareToast] makeText:@"运单状态错误请联系客服" aDuration:1];
//        return;
//    }
//
//    WS(ws);
//
//    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
//    if (!self.myModel.container_code) {
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
//                [vm finishShipmentWithType:0 WithQrcode:self.myModel.parentCode WithBillid:self.myModel.waybill_id WithContainercode:searchText callback:^(NSString *message) {
//                    if (message) {
//                        [[Toast shareToast]makeText:@"装载成功" aDuration:1];
////                        [self cancleAction];
//                        [ws getDate];
//                    }
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
//        [vm finishShipmentWithType:1 WithQrcode:self.stCode WithBillid:self.myModel.waybill_id WithContainercode:self.myModel.container_code callback:^(NSString *message) {
//            if (message) {
//                [[Toast shareToast]makeText:@"抵达成功" aDuration:1];
////                [self cancleAction];
//                [ws getDate];
//            }
//
//        }];
//
//    }
//}

@end
