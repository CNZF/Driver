//
//  ZCCancleOrderViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/2.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCancleOrderViewController.h"
#import "ZCHistoryTableViewCell.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCOrderDetailsViewController.h"


@interface ZCCancleOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tvList;
@property (nonatomic, strong) NSMutableArray *arrRecord;


@end

@implementation ZCCancleOrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tvList];
}

- (void)bindModel {
    self.arrRecord = [NSMutableArray array];

}


- (void)getData {


    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UserInfoModel *info = USER_INFO;

      [self.arrRecord removeAllObjects];
    [vm selectOrderWithType:2 WithDriverid:[info.driverId intValue] callback:^(NSMutableArray *arrInfo) {

        [ws.arrRecord addObjectsFromArray:arrInfo];

        [ws.tvList reloadData];
        
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

    return self.arrRecord.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Celled";





    ZCHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZCHistoryTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.lbDay.layer.borderWidth = 1;
        cell.lbDay.layer.borderColor = APP_COLOR_ORANGR1.CGColor;
        [cell.lbDay.layer setMasksToBounds:YES];
        [cell.lbDay.layer setCornerRadius:5.0];//设置矩形四个圆角半径



    }

    if (self.arrRecord) {
        ZCTransportOrderModel *model = [self.arrRecord objectAtIndex:indexPath.row];
        cell.lbTime.text = [NSString stringWithFormat:@"出发时间：%@", [self stDateToString:model.startTime]];
        cell.lbStartName.text = model.start_region_name;
        cell.lbEndName.text = model.end_region_name;
        cell.lbState.text = @"已取消";
        


        switch (model.type) {
            case 1:
                cell.lbPushOrder.text = @"任务";
                break;

            case 2:
                cell.lbPushOrder.text = @"抢单";
                break;

            case 3:
                cell.lbPushOrder.text = @"任务";
                break;

            default:
                break;
        }
        

        cell.lbPrice.hidden = YES;
        cell.lbCode.hidden = YES;
        double daytime = ([model.endTime doubleValue] - [model.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }
        cell.lbDay.text = [NSString stringWithFormat:@"%i天",(int)daytime];

        
    }
    
    return cell;

    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ZCOrderDetailsViewController *vc= [ZCOrderDetailsViewController new];
    ZCTransportOrderModel *model = [self.arrRecord objectAtIndex:indexPath.row];
    vc.willId = model.waybill_id;
    vc.waybillStatus = [NSString stringWithFormat:@"%i",model.status];
    [self.navigationController pushViewController:vc animated:YES];



}


/**
 *  getter
 *
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -40, SCREEN_W, SCREEN_H - 64) style:UITableViewStyleGrouped];
        tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.tableFooterView = [UIView new];
        
        _tvList = tableView;
    }
    return _tvList;
}


@end
