//
//  ZCFinishedTransportViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/16.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCFinishedTransportViewController.h"
#import "ZCHistoryTableViewCell.h"
#import "SellCapacityViewModel.h"
#import "ZCSaleTransportationViewController.h"

@interface ZCFinishedTransportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tvList;
@property (nonatomic, strong) NSMutableArray *arrRecord;

@end

@implementation ZCFinishedTransportViewController

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
    [self.arrRecord removeAllObjects];
    SellCapacityViewModel *vm = [SellCapacityViewModel new];
    [vm selectCapacityWith:1 callback:^(NSArray *recordList) {

        [ws.arrRecord addObjectsFromArray:recordList];
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


    return 168;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Celled";





    ZCHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZCHistoryTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];





    }

    if (self.arrRecord) {
        ZCTransportationModel *model = [self.arrRecord objectAtIndex:indexPath.row];

        cell.lbCode.text = model.vehicleCode;

        //                NSDate * date = [NSDate dateWithTimeIntervalSince1970:[model.start_effective integerValue]/1000];
        //                NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        //                [outputFormatter setDateFormat:@"yyyy-MM-dd"];

        cell.lbTime.text = [NSString stringWithFormat:@"出发时间：%@", [self stDateToString:model.startTime]];
        cell.lbStartName.text = model.startName;
        cell.lbEndName.text = model.endName;
        cell.lbPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
        cell.lbDay.hidden = YES;
        cell.lbPushOrder.hidden = YES;
        switch (model.order_status) {
                //0-已发布，1-待付款，2-付款审核，3-待收货，4-已完成，5-待退款，6-已取消

            case 0:
                 cell.lbState.text = @"已发布";

                break;
            case 1:
                 cell.lbState.text = @"待付款";

                break;
            case 2:
                 cell.lbState.text = @"付款审核";

                break;
            case 3:
                cell.lbState.text = @"待收货";

                break;
            case 4:
                cell.lbState.text = @"已完成";

                break;
            case 5:
                cell.lbState.text = @"待退款";

                break;

            case 6:
                cell.lbState.text = @"已取消";

                break;

                
            default:
                break;
        }

    }
    return cell;


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ZCTransportationModel *model = [self.arrRecord objectAtIndex:indexPath.row];
    ZCSaleTransportationViewController *controller = [ZCSaleTransportationViewController new];
    controller.capacityId = model.iden;
    [self.navigationController pushViewController:controller animated:YES];





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
