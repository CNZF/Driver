//
//  ZCMyOrderViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/17.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCMyOrderViewController.h"
#import "MenuView.h"
#import "LeftMenuViewDemo.h"
#import "PersonViewController.h"
#import "ZCOrderTableViewCell.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCTransportOrderModel.h"
#import "QCodeViewController.h"
#import "XMFDropBoxView.h"
#import "AlterView.h"
#import "MyCapacityViewController.h"
#import "MarkViewController.h"
#import "ZCRecommendViewController.h"
#import "UserInfoModel.h"
#import "UserOrderSqlite.h"
#import "PushModel.h"
#import "ZCOrderDetailsViewController.h"
#import "ZCHistoryOrderViewController.h"
#import "ZCTransportationRecordViewController.h"
#import "ZCSellCapacityViewControllerViewController.h"
#import "ZCCarManagerViewController.h"
#import "PushOrderView.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCRecommendViewController.h"
#import "DynamicDetailsViewController.h"
#import "UserOrderSqlite.h"
#import "PushModel.h"

@interface ZCMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,XMFDropBoxViewDataSource,UIAlertViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView           *tvList;
@property (nonatomic, strong) UIButton              *btnSell;
@property (nonatomic, assign) float                 angle;;
@property (nonatomic, strong) NSMutableArray        *arrDate;
@property (nonatomic, strong) XMFDropBoxView        *inputBox;
@property (nonatomic, assign) BOOL                  show;
@property (nonatomic, strong) ZCTransportOrderModel *currentInfo;
@property (nonatomic, strong) NSString              *container_code;
@property (nonatomic, strong) UIView                *viBackGround;
@property (nonatomic, strong) AlterView             *viAlter;
@property (nonatomic, strong) NSString              *stCode;
@property (nonatomic, strong) UITextField           *tfCode;
@property (nonatomic, strong) UILabel               *lbBottom;
@property (nonatomic, strong) UIView                *ViewWaite;
@property (nonatomic, strong) UILabel               *lbWaite;
@property (nonatomic, strong) UIImageView           *ivShare;
@property (nonatomic, strong) NSArray               *arrSt;
@property (nonatomic, strong) UIButton              *btnShare;


@end

@implementation ZCMyOrderViewController

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self.inputBox dismissDropBox];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDate];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnLeft setImage:[UIImage imageNamed:@"home_top_sliding_icon"] forState:UIControlStateNormal];
    [self.btnLeft setFrame:CGRectMake(0, 0, 25, 25)];
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];

    [self.btnRight setFrame:CGRectMake(0, 0, 30, 7)];
    [self.btnRight setImage:[UIImage imageNamed:@"btnRight"] forState:UIControlStateNormal];


    //[self waitAction];
}

- (void)bindView{



//    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
//    [vm qiang];

//    PushOrderView *view = [PushOrderView new];
//    //view.model = model;
////    view.tag = PUSHORDERVIEWTAG;
//    view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:view];


    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.title                = @"正在接单";

    self.ViewWaite.frame = CGRectMake(0, 20, SCREEN_W, SCREEN_H - 140);
    [self.view addSubview:self.ViewWaite];

    self.tvList.frame         = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 120);
    [self.view addSubview:self.tvList];

    self.lbWaite.frame = CGRectMake(0, 120, SCREEN_W, 30);
    [self.ViewWaite addSubview:self.lbWaite];

    self.ivShare.frame = CGRectMake(SCREEN_W/2 - 50, self.lbWaite.bottom + 40, 100, 100);
    [self.ViewWaite addSubview:self.ivShare];

    self.btnShare.frame = CGRectMake(SCREEN_W/2 - 50, self.lbWaite.bottom + 40, 100, 100);
    [self.ViewWaite addSubview:self.btnShare];


    self.lbBottom.frame = CGRectMake(0, self.tvList.bottom, SCREEN_W, SCREEN_H - self.tvList.bottom);
    [self.view addSubview:self.lbBottom];

    self.btnSell.frame        = CGRectMake(SCREEN_W/2 - 40, SCREEN_H - 160, 80, 80);
    [self.view addSubview:self.btnSell];





}

- (void)bindModel {
    self.arrDate = [NSMutableArray array];
    self.arrSt = @[@"联系客服",@"停止接单"];



}

- (void)bindAction {


}

- (void)onBackAction{
    [self.menu show];
    [self.inputBox dismissDropBox];
}

- (void)onRightAction{




    self.inputBox = [XMFDropBoxView dropBoxWithLocationView:self.btnRight dataSource:self];
    self.inputBox.backgroundColor = [UIColor grayColor];



    WS(ws);
    [self.inputBox selectItemWithBlock:^(NSUInteger index) {

        if (index == 0) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

            [alert show];

        }else{

            NSString *st = [ws.arrSt objectAtIndex:1];
            if ([st isEqualToString:@"停止接单"]) {
                 ws.arrSt = @[@"联系客服",@"继续接单"];
                self.title = @"停止接单";
            }else {

                ws.arrSt = @[@"联系客服",@"停止接单"];
                 self.title = @"正在接单";

            }


            [ws.inputView reloadInputViews];


            [[Toast shareToast]makeText:st aDuration:1];
        }


    }];

    if (!self.show) {
        [self.inputBox displayDropBox];
    }else{

        [self.inputBox dismissDropBox];
    }

    self.show = !self.show;



//    [self.navigationController pushViewController:[QCodeViewController new] animated:YES];

}

//正在接单按钮点击事件
- (void)waitAction {

    self.title = @"正在接单";
    [self.btnRight setImage:[UIImage imageNamed:@"waitbutton"] forState:UIControlStateNormal];
    [self.btnSell setImage:[UIImage imageNamed:@"jiedan"] forState:UIControlStateNormal];
        [self.btnRight setFrame:CGRectMake(0, 0, 30, 26)];
    self.ViewWaite.backgroundColor = [UIColor whiteColor];
    self.tvList.hidden = YES;

}

- (void)getDate{

    WS(ws);

    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UserInfoModel *info = USER_INFO;

    [vm selectOrderWithType:0 WithDriverid:[info.driverId intValue] callback:^(NSMutableArray *arrInfo) {

        [ws.arrDate removeAllObjects];
        [ws.arrDate removeAllObjects];
        [ws.arrDate addObjectsFromArray: arrInfo];
        UserOrderSqlite *model = [UserOrderSqlite shareUserOrderSqlite];
        NSArray *arr = [model selectAllOrderData];
        [self.arrDate addObjectsFromArray:arr];

        if (ws.arrDate.count > 0) {
            ws.tvList.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [ws.tvList reloadData];

        }

        ws.tvList.hidden = NO;


        [ws.tvList.mj_header endRefreshing];
    }];
    [self.tvList.mj_header endRefreshing];
}

//出售运力
- (void)sellAction {

    ZCSellCapacityViewControllerViewController * vc = [[ZCSellCapacityViewControllerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  扫描方法
 */
- (void)scan:(UIButton *)btn {


    WS(ws);
    self.currentInfo = [self.arrDate objectAtIndex:btn.tag];
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



  self.viBackGround.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
  [self.view addSubview:self.viBackGround];
  self.viAlter = [[AlterView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 140, 100, 280, 200 )];
  [self.viAlter.btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];


}

- (void)cancleAction {
    [self.viAlter removeFromSuperview];
    [self.viBackGround removeFromSuperview];
}

- (void)centainOrder: (UIButton *)btn{

    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    ZCTransportOrderModel *model = [self.arrDate objectAtIndex:btn.tag];

    WS(ws);

    [vm centerOrderWithIsAccept:1 WithWaybillId:model.waybill_id callback:^(NSString *st) {
        [ws getDate];

    }];

}

- (void)Contectservice{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    [alert show];
}








/**
 *  XMFDropBoxView delegatge
 *
 */

- (NSUInteger)numberOfItemInDropBoxView:(XMFDropBoxView *)dropBoxView {
    return 2;
}

- (CGFloat)dropBoxView:(XMFDropBoxView *)dropBoxView heightForItemAtIndex:(NSUInteger)index {
    return 40.f;
}

- (UIView *)dropBoxView:(XMFDropBoxView *)dropBoxView itemAtIndex:(NSUInteger)index {
    UIView *view = [UIView new];
    UIImageView *iv = [UIImageView new];
    UIImage *img;
    if (index == 0) {
        img = [UIImage imageNamed:@"customerService"];
    }else{
        img = [UIImage imageNamed:@"stop"];
    }
    iv.image =  img;
    iv.frame = CGRectMake(10, 10, 20, 20);
    [view addSubview:iv];
    UILabel *titleLB = [UILabel new];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.font = [UIFont systemFontOfSize:16];
    if (index == 0) {
        titleLB.text = @"联系客服";
    }else{
        titleLB.text = [self.arrSt objectAtIndex:1];
    }

    titleLB.textColor = [UIColor whiteColor];
    titleLB.backgroundColor = [UIColor clearColor];
    titleLB.frame = CGRectMake(iv.right , 10, 80, 20);
    [view addSubview:titleLB];
    return view;
}

- (CGFloat)widthInDropBoxView:(XMFDropBoxView *)dropBoxView {
    return 120.f;
}

/**
 *  alertView代理
 *
 *  @param alertView   delegate
 */


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",APP_CUSTOMER_SERVICE]]];
    }

}


/**
 *
 *  @param tableView delegate
 *
 *  @return
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.arrDate.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

       static NSString *CellIdentifier = @"Celled";

       ZCOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

       BaseModel *model = [self.arrDate objectAtIndex:indexPath.row];

        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZCOrderTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.viewShow.layer.shadowOffset =  CGSizeMake(1, 1);
            cell.viewShow.layer.shadowOpacity = 0.1;
            cell.viewShow.layer.shadowColor =  [UIColor grayColor].CGColor;
            cell.btnKnockOrder.layer.masksToBounds = YES;
            cell.btnKnockOrder.layer.cornerRadius = 5;
            cell.lbDay.layer.borderWidth = 1;
            cell.lbDay.layer.borderColor = APP_COLOR_ORANGR1.CGColor;
            [cell.lbDay.layer setMasksToBounds:YES];
            [cell.lbDay.layer setCornerRadius:5.0];//设置矩形四个圆角半径
            cell.lbMM.layer.borderWidth = 1;
            cell.lbMM.layer.borderColor = APP_COLOR_ORANGR1.CGColor;
            [cell.lbMM.layer setMasksToBounds:YES];
            [cell.lbMM.layer setCornerRadius:5.0];//设置矩形四个圆角半径
            
            cell.viewShow.userInteractionEnabled = NO;

        }


    if ([model isKindOfClass:[ZCTransportOrderModel class]]) {
         ZCTransportOrderModel *model = [self.arrDate objectAtIndex:indexPath.row];
        cell.lbTime.text = [NSString stringWithFormat:@"出发时间：%@",[self stDateToString:model.startTime]];
        cell.lb1.text = [NSString stringWithFormat:@"物品： %@",model.goods_name];
        cell.lb2.text = [NSString stringWithFormat:@"箱型：%@",model.containerType];
        cell.lbCity1.text = model.start_region_name;
        cell.lbCity2.text = model.end_region_name;
        cell.lbMM.text = [NSString stringWithFormat:@"￥%i",model.price];
        cell.im.hidden = YES;
        cell.btnKnockOrder.hidden = YES;
        cell.lbRed.hidden = YES;
        cell.lbMM.hidden = YES;
        cell.model = model;
        double daytime = ([model.endTime doubleValue] - [model.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }
        cell.lbDay.text = [NSString stringWithFormat:@"%i天送达",(int)daytime];
        cell.btnKnockOrder.tag = indexPath.row;
        [cell.btnKnockOrder addTarget:self action:@selector(centainOrder:) forControlEvents:UIControlEventTouchUpInside];
        float distance = [self distanceWithStartlat:model.start_region_center_lat WithStartlng:model.start_region_center_lng WithEndlat:model.end_region_center_lat WithEndlng:model.end_region_center_lng];

        if (distance >0) {

             cell.lbDistance.text = [NSString stringWithFormat:@"约%.0f公里",distance];

        }else {

            cell.lbDistance.text = @"同城";
        }



    }else {

        PushModel *model = [self.arrDate objectAtIndex:indexPath.row];
        cell.lbTime.text = [NSString stringWithFormat:@"出发时间：%@",[self stDateToString:model.startTime]];
        cell.lbCity1.text = model.start_region;
        cell.lbCity2.text = model.end_region;

        cell.lb1.text = [NSString stringWithFormat:@"物品： %@",model.goods_name];
        cell.lb2.text = [NSString stringWithFormat:@"箱型：%@",model.containerType];
        double daytime = ([model.endTime doubleValue] - [model.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }
        cell.lbDay.text = [NSString stringWithFormat:@"%i天送达",(int)daytime];
        cell.lbRed.hidden = YES;

        cell.lbMM.text = [NSString stringWithFormat:@"￥%i",model.price];
        [cell.btnKnockOrder setTitle:@"抢单" forState:UIControlStateNormal];
        cell.im.hidden = NO;
        cell.im.image = [UIImage imageNamed:@"qiangdan"];
        cell.btnKnockOrder.hidden = NO;
        cell.btnKnockOrder.tag = indexPath.row;
        [cell.btnKnockOrder addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];

        float distance = [self distanceWithStartlat:model.start_region_center_lat WithStartlng:model.start_region_center_lng WithEndlat:model.end_region_center_lat WithEndlng:model.end_region_center_lng];

        if (distance >0) {

            cell.lbDistance.text = [NSString stringWithFormat:@"约%.0f公里",distance];

        }else {

            cell.lbDistance.text = @"同城";
        }

    }





        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.inputBox dismissDropBox];

    ZCOrderDetailsViewController *vc= [ZCOrderDetailsViewController new];

    if(self.arrDate.count >0) {
        BaseModel *model = [self.arrDate objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[ZCTransportOrderModel class]]) {
            ZCTransportOrderModel *info = [self.arrDate objectAtIndex:indexPath.row];
            if ((info.type == 1 || info.type == 3) && info.is_accept == 0) {
                vc.type = 1;
            }
            vc.willId = info.waybill_id;
            vc.waybillStatus = [NSString stringWithFormat:@"%i",info.status];
        }else {

            PushModel *info = [self.arrDate objectAtIndex:indexPath.row];
            vc.pInfo = info;
            
        }

    }


    [self.navigationController pushViewController:vc animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self.inputBox dismissDropBox];

}

- (void)receiveAction :(UIButton *)btn {

    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];



    UserInfoModel *userInfo = USER_INFO;
    if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {


        PushModel *model = [self.arrDate objectAtIndex:btn.tag];
        UserOrderSqlite *userSqlModel = [UserOrderSqlite shareUserOrderSqlite];
        [userSqlModel deleteOneOrderData:model];
        [self getDate];
        [vm receiveOrderWithPushModel:model callback:^(NSString *st) {

            if ([st isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"已抢单" aDuration:1];
                
            }


        }];

    }else {
        [[Toast shareToast]makeText:@"资料审核中，暂时无法抢单" aDuration:1];
    }
    

    
}

- (void)shareAction {

    ZCRecommendViewController *vc = [ZCRecommendViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



/**
 *  get
 */


- (UIButton *)btnSell {
    if (!_btnSell) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sellAction) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
        
        _btnSell = button;
    }
    return _btnSell;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        WS(weakSelf);
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getDate];
        }];
        tableView.tableFooterView = [UIView new];
        tableView.backgroundColor = [UIColor clearColor];
        
        _tvList = tableView;
    }
    return _tvList;
}

- (UIView *)viBackGround {
    if (!_viBackGround) {
        _viBackGround = [UIView new];
        _viBackGround.backgroundColor = [UIColor blackColor];
        _viBackGround.alpha = 0.7;
    }
    return _viBackGround;
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

- (UIView *)ViewWaite {
    if (!_ViewWaite) {
        _ViewWaite = [UIView new];
        _ViewWaite.backgroundColor = [UIColor clearColor];
    }
    return _ViewWaite;
}

- (UILabel *)lbWaite {
    if (!_lbWaite) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"系统正在为您准备订单，请稍后";

        _lbWaite = label;
    }
    return _lbWaite;
}

- (UIImageView *)ivShare {
    if (!_ivShare) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"sharebutton"];

        _ivShare = imageView;
    }
    return _ivShare;
}

- (UIButton *)btnShare {
    if (!_btnShare) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];



        _btnShare = button;
    }
    return _btnShare;
}



@end
