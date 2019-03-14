//
//  ZCCarManagerViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/5.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCarManagerViewController.h"
#import "PerfectCarInfomationViewController.h"
#include "UserInfoViewModel.h"
#import "CarInfoModel.h"




@interface ZCCarManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) UILabel     *lbHead;
@property (nonatomic, strong) NSArray     *arrCar;
@property (nonatomic, strong) UIButton    *btnAddCar;
@property (nonatomic, assign) int         style;
@property (nonatomic, strong) UIButton    *btnManager;
@property (nonatomic, strong) UIButton    *btnSetActive;
@property (nonatomic, strong) UIButton    *btnDelate;
@property (nonatomic, strong) UIView      *viFoot;
@property (nonatomic, assign) int         selectNo;
@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation ZCCarManagerViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];


    self.style = 0;

    [self getData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dic = @{@"0":@"未提交材料",@"1":@"注册完成",@"2":@"车辆认证完成",@"3":@"车辆认证未通过"};
}

- (void)bindModel {

//    self.arrCar = @[@"京N09980",@"京N09980",@"京N09980"];



}

- (void)bindView {

    self.title  =@"车辆管理";

    self.btnRight.hidden = NO;
    [self.btnRight setTitle:@"管理" forState:UIControlStateNormal];
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 60, 30);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tvList];

//    self.lbHead.frame = CGRectMake(20, 20, SCREEN_W - 20, 20);
//


    self.btnAddCar.frame = CGRectMake(20,SCREEN_H - 160-kiPhoneFooterHeight ,SCREEN_W-40 , 44);
    [self.view addSubview:self.btnAddCar];


    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, self.btnAddCar.top - 100);
     [self.view addSubview:self.tvList];
//     [self.view addSubview:self.lbHead];

//    self.btnManager.frame = CGRectMake(SCREEN_W - 100, 20, 100, 20);
//    [self.view addSubview:self.btnManager];

    self.viFoot.frame = CGRectMake(0, self.tvList.bottom+20, SCREEN_W, 60);
    self.btnSetActive.frame = CGRectMake(SCREEN_W - 240, 10, 100, 40);
    [self.viFoot addSubview:self.btnSetActive];

    self.btnDelate.frame = CGRectMake(SCREEN_W - 120, 10, 100, 40);
    [self.viFoot addSubview:self.btnDelate];
    [self.view addSubview:self.viFoot];
}

- (void)bindAction {
    WS(ws);
    [[self.btnAddCar rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws.navigationController pushViewController:[PerfectCarInfomationViewController new] animated:YES];
    }];

    [[self.btnManager rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        if (ws.arrCar.count >0) {
            if (ws.style == 0) {
                ws.style =1;
                [ws.tvList reloadData];
                [ws.btnManager setTitle:@"完成" forState:UIControlStateNormal];
                [ws.btnManager setTintColor:APP_COLOR_ORANGR2];
                ws.btnAddCar.hidden = YES;
                ws.btnSetActive.hidden = NO;
//                UserInfoModel * info = USER_INFO;
//                if (info.userType!=3) {
                     ws.btnDelate.hidden = YES;
//                }else{
//                     ws.btnDelate.hidden = NO;
//                }
               
            }else {

                ws.style =0;
                [ws.tvList reloadData];
                [ws.btnManager setTitle:@"管理" forState:UIControlStateNormal];
                [ws.btnManager setTintColor:[UIColor grayColor]];
                ws.btnAddCar.hidden = NO;
                ws.btnSetActive.hidden = YES;
                ws.btnDelate.hidden = YES;
                
            }


        }else {
            [[Toast shareToast]makeText:@"无车辆" aDuration:1];
        }



    }];

    [[self.btnSetActive rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws bindCar];
    }];

    [[self.btnDelate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws delateCar];
    }];
}

- (void)onRightAction {

    if (self.arrCar.count >0) {
        if (self.style == 0) {
            self.style =1;
            [self.tvList reloadData];
            [self.btnManager setTitle:@"完成" forState:UIControlStateNormal];
             [self.btnRight setTitle:@"完成" forState:UIControlStateNormal];
            [self.btnManager setTintColor:APP_COLOR_ORANGR2];
            self.btnAddCar.hidden = YES;
            self.btnSetActive.hidden = NO;
            self.btnDelate.hidden = YES;
        }else {

            self.style =0;
            [self.tvList reloadData];
            [self.btnManager setTitle:@"管理" forState:UIControlStateNormal];
            [self.btnRight setTitle:@"管理" forState:UIControlStateNormal];
            [self.btnManager setTintColor:[UIColor grayColor]];
            self.btnAddCar.hidden = NO;
            self.btnSetActive.hidden = YES;
            self.btnDelate.hidden = YES;

        }


    }else {
        [[Toast shareToast]makeText:@"无车辆" aDuration:1];
    }

}

- (void)getData {

    UserInfoViewModel *vm = [UserInfoViewModel new];
    UserInfoModel *info = USER_INFO;

    WS(ws);

    [vm getCarListWithUserId:info.iden callback:^(NSArray *arr) {

        ws.arrCar = arr;
        if (arr.count == 1) {
            CarInfoModel *car = [arr objectAtIndex:0];
            car.isActivite = YES;
        }

        if (arr.count == 0) {
            ws.btnAddCar.hidden = NO;
            ws.btnSetActive.hidden = YES;
            ws.btnDelate.hidden = YES;
        }

        [ws.tvList reloadData];
        
    }];

}

//获取新车
- (void)getNewCar {

    UserInfoViewModel *vm = [UserInfoViewModel new];
     UserInfoModel *userinfo  = USER_INFO;

    [vm getBindCarListWithUserId:userinfo.iden callback:^(CarInfoModel *info) {

        [NSKeyedArchiver archiveRootObject:info toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];
        
    }];

}

//绑定车辆
- (void)bindCar {

    UserInfoViewModel *vm = [UserInfoViewModel new];
    UserInfoModel *us = USER_INFO;

    NSMutableArray *cararr = [NSMutableArray array];

    for (CarInfoModel *info in self.arrCar) {
        if (info.selected == 1) {
            [cararr addObject:info];
        }
    }
    if (cararr.count >0){

        if (cararr.count > 1) {
            [[Toast shareToast]makeText:@"只能把一辆车辆设置为当前车辆" aDuration:1];
        }
        else{

            CarInfoModel *carInfo = [cararr objectAtIndex:0];
//            if(carInfo.auth_status ==2){

                WS(ws);

                [vm bindCarListWithUserId:us.iden withVehicleId:carInfo.vehicle_id callback:^(NSString *st) {
                    if ([st isEqualToString:@"10000"]) {

                        [[Toast shareToast]makeText:@"绑定成功" aDuration:1];
                        [ws onRightAction];
                        [ws getData];
                        [ws getNewCar];


                    }
                    
                }];


//            }else {
//                [[Toast shareToast]makeText:@"车辆不可用" aDuration:1];
//            }

        }

    }else {

        [[Toast shareToast]makeText:@"请先选择车辆" aDuration:1];
    }




}

//删除车辆
- (void)delateCar {

    
    NSMutableArray *cararr = [NSMutableArray array];

    for (CarInfoModel *info in self.arrCar) {
        if (info.selected == 1) {

           // NSString *st = [NSString stringWithFormat:@"%i",info.vehicle_id];
            [cararr addObject:[NSNumber numberWithInt:info.vehicle_id]];
        }
    }

     UserInfoViewModel *vm = [UserInfoViewModel new];


    WS(ws);



    [vm delateCarWith:cararr callback:^(NSString *st) {
        if ([st isEqualToString:@"10000"]) {

            [[Toast shareToast]makeText:@"车辆删除成功" aDuration:1];
            [ws getData];
            
        }

    }];

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

    return self.arrCar.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CarInfoModel *carInfo = [self.arrCar objectAtIndex:indexPath.row];

    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    cell.textLabel.text = carInfo.code;

    cell.textLabel.textColor = [UIColor lightGrayColor];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = [carInfo.dic objectForKey:[NSString stringWithFormat:@"%i",carInfo.auth_status]];


    UILabel *lb = [UILabel new];

    if (carInfo.isActivite == 1) {

        lb.frame = CGRectMake(110, 18, 60, 20);
        lb.hidden = NO;
        lb.layer.borderWidth = 1;
        lb.layer.borderColor = APP_COLOR_ORANGR1.CGColor;
        [lb.layer setMasksToBounds:YES];
        [lb.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        [cell addSubview:lb];
        lb.textColor = APP_COLOR_ORANGR2;
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = @"当前车辆";
        lb.font = [UIFont systemFontOfSize:12];
    }

    if (self.style == 1) {

        //激活状态

        lb.hidden = YES;
        if (carInfo.selected == 1) {
            cell.imageView.image = [UIImage imageNamed:@"fullbox"];
        }
        else{

             cell.imageView.image = [UIImage imageNamed:@"box"];

        }

    }else {

        cell.imageView.image = nil;

    }


    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CarInfoModel *info = [self.arrCar objectAtIndex:indexPath.row];
    if (info.selected == 0) {
        info.selected =1;
    }else{

        info.selected =0;
    }
    [self.tvList reloadData];

}

//- (void)onAddBtn{
//     [self.navigationController pushViewController:[PerfectCarInfomationViewController new] animated:YES];
//}

/**
 *  getter
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_W, SCREEN_H- 20) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.bounces = NO;

        _tvList = tableView;
    }
    return _tvList;
}

- (UILabel *)lbHead {
    if (!_lbHead) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"我的车辆";

        _lbHead = label;
    }
    return _lbHead;
}

- (UIButton *)btnAddCar {
    if (!_btnAddCar) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"添加车辆" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
//        [button addTarget:self action:@selector(onAddBtn) forControlEvents:UIControlEventTouchUpInside];
        _btnAddCar = button;
    }
    return _btnAddCar;
}

- (UIView *)viFoot {
    if (!_viFoot) {
        _viFoot = [UIView new];

    }
    return _viFoot;
}

- (UIButton *)btnManager {
    if (!_btnManager) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"管理" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];


        _btnManager = button;
    }
    return _btnManager;
}

- (UIButton *)btnSetActive {
    if (!_btnSetActive) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"设为当前" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        button.hidden = YES;

        _btnSetActive = button;
    }
    return _btnSetActive;
}

- (UIButton *)btnDelate {
    if (!_btnDelate) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        button.hidden = YES;


        _btnDelate = button;
    }
    return _btnDelate;
}


@end
