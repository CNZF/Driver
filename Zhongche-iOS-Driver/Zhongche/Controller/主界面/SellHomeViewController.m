//
//  SellHomeViewController.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "SellHomeViewController.h"
#import "SellChuFaTableViewCell.h"
#import "SellShoujiaTableViewCell.h"
#import "SellCheLiangTableViewCell.h"
#import "ZCCityListViewController.h"
#import "SellHomeModel.h"
#import "ZCTransportationModel.h"
#import "UserInfoViewModel.h"
#import "ZCCarManagerViewController.h"
#import "AppDelegate.h"
#import "SellBlackView.h"
#import "SellCapacityViewModel.h"
#import "ZCTransportationModel.h"
#import "ZCTransportationRecordViewController.h"
#import "CarInfoModel.h"

@interface SellHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *beginCity;
@property (weak, nonatomic) IBOutlet UIButton *endCity;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SellHomeModel * model;
@property (nonatomic, strong) ZCTransportationModel *transpoetation;
@property (nonatomic, strong) NSArray   *arrCar;
@property (nonatomic, strong) SellBlackView * blackView;
@property (nonatomic, strong) CarInfoModel * carModel;
@end

@implementation SellHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 90.0f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.model  = [[SellHomeModel alloc]init];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    //进入页面刷新当前车辆信息
    UserInfoModel *userinfo  = USER_INFO;
    UserInfoViewModel *vm = [UserInfoViewModel new];
    
    self.transpoetation.carInfo  = CAR_INFO;
    WS(ws);
    [vm getBindCarListWithUserId:userinfo.iden callback:^(CarInfoModel *info) {
        
        [NSKeyedArchiver archiveRootObject:info toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];
        ws.transpoetation.carInfo  = info;
        if (info) {
            self.model.carCard = info.code;
            self.model.carState  = info.vehicle_type;
            [self.tableView reloadData];
        }
    }];
    [self.tableView reloadData];
}

- (void)requestCarInfo {
    
    UserInfoViewModel *vm = [UserInfoViewModel new];
    UserInfoModel *info = USER_INFO;
    
    WS(ws);
    
    [vm getCarListWithUserId:info.iden callback:^(NSArray *arr) {
        
        if (arr.count == 0) {
            [ws.navigationController pushViewController:[ZCCarManagerViewController new] animated:YES];
            [[Toast shareToast]makeText:@"目前没有绑定的车辆" aDuration:1];
            
        }else {
            ws.arrCar = [NSMutableArray arrayWithArray:arr];
        }
    
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    if (indexPath.row == 0 || indexPath.row == 2 ||indexPath.row == 3) {
        SellChuFaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SellChuFaTableViewCell" forIndexPath:indexPath];
        [cell setCellPrefrenceWithIndexPatRow:indexPath.row WithModel:self.model];
        [cell setBlock:^(NSInteger index) {
            if (index == 0) {
                AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                ws.blackView.tableView.hidden = YES;
                ws.blackView.datePicker.hidden = NO;
                ws.blackView.titleLabel.text =@"选择出发时间";
                [app.window addSubview:ws.blackView];
                [ws.blackView setDateBlock:^(NSString *string) {
                    self.model.beginTime = string;
                    [ws.tableView reloadData];
                }];
             
            }else{
                if (ws.arrCar.count == 0) {
                    [[Toast shareToast]makeText:@"目前没有绑定的车辆" aDuration:1];
                    return ;
                }
                AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                ws.blackView.datePicker.hidden = YES;
                ws.blackView.tableView.hidden = NO;
                ws.blackView.titleLabel.text =@"选择车辆";
                [app.window addSubview:ws.blackView];
                [ws.blackView setDataArrayWithCarModel:ws.arrCar];
                [ws.blackView setBlock:^(NSInteger index) {
                    CarInfoModel * model = ws.arrCar[index];
                    ws.model.carCard = model.code;
                    ws.carModel = model;
                    ws.model.carState  = model.vehicle_type;
                    [ws.tableView reloadData];
                }];
                
            }
        }];
        
        return cell;
    }else {
        SellShoujiaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SellShoujiaTableViewCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }
}

- (IBAction)pressChooseBtn:(UIButton *)sender {
    __weak typeof(self) WeakSelf = self;
    ZCCityListViewController * controller = [[ZCCityListViewController alloc]init];
    switch (sender.tag) {
        case 1001:
            controller.title = @"选择起点城市";
            break;
        case 1002:
            controller.title = @"选择终点城市";
            break;
        default:
            break;
    }
    [controller setBlock:^(CityModel *model) {
        if (sender.tag == 1001) {
            [WeakSelf.beginCity setTitle:model.startPosition forState:UIControlStateNormal];
            [WeakSelf.beginCity setTitleColor:APP_COLOR_ORANGR forState:UIControlStateNormal];
             WeakSelf.model.beginCity = model.startPosition;
        }else{
            [WeakSelf.endCity setTitle:model.startPosition forState:UIControlStateNormal];
            [WeakSelf.endCity setTitleColor:APP_COLOR_ORANGR forState:UIControlStateNormal];
             WeakSelf.model.endCity = model.startPosition;
        }
    }];
    [self.navigationController pushViewController:controller animated:YES];
 
}
- (IBAction)pressSubmitBtn:(id)sender {
//    SellHomeModel * model = self.model;
    [self saleAction];
}

//出售运力
- (void)saleAction {
    
    
    WS(ws);
    
    SellCapacityViewModel *vm  =[SellCapacityViewModel new];
    ZCTransportationModel * transpoetation = [ZCTransportationModel new];
    transpoetation.carInfo = self.carModel;
    transpoetation.startRegionCode = self.model.beginCity;
    transpoetation.endRegionCode = self.model.endCity;
    transpoetation.startTime = self.model.beginTime;
    transpoetation.price = self.model.sellPrice;
    
    if (transpoetation.carInfo && transpoetation.startRegionCode && transpoetation.price &&transpoetation.endRegionCode && transpoetation.startTime) {
        
        if (transpoetation.carInfo.auth_status == 2) {
            
            [vm sellCapacityWith:transpoetation callback:^{
                [[Toast shareToast]makeText:@"出售成功" aDuration:1];
                self.model = nil;
                ZCTransportationRecordViewController *vc = [ZCTransportationRecordViewController new];
                vc.type = 1;
                [ws.navigationController pushViewController:vc animated:YES];
            }];
            
        }else {
            [[Toast shareToast]makeText:@"当前车辆不可用" aDuration:1];
        }
        
    }else {
        [[Toast shareToast]makeText:@"信息不完整" aDuration:1];
    }
    
    
    
}
- (SellBlackView *)blackView
{
    if (!_blackView) {
        _blackView = [[[NSBundle mainBundle] loadNibNamed:@"SellBlackView" owner:self options:nil] firstObject];
        _blackView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _blackView;
}

@end
