//
//  ZCTakeInViewController.m
//  Zhongche
//
//  Created by lxy on 2016/10/20.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCTakeInViewController.h"
#import "ZCIncomeTableViewCell.h"
#import "ZCTakeInDetailViewController.h"
#import "ZCWalletViewModel.h"
#import "ZCWalletOredrInfo.h"

@interface ZCTakeInViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView           *tvList;
@property (nonatomic, strong) NSArray                *arrInfo;

@end

@implementation ZCTakeInViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated ];
    [self getDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.title                = @"收入明细";

    self.tvList.frame         = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 120);
    [self.view addSubview:self.tvList];

}

- (void)getDate{

    WS(ws);
    ZCWalletViewModel *vm = [ZCWalletViewModel new];
    [vm selectWalletMoneyOrderListcallback:^(NSMutableArray *arrInfo) {

        ws.arrInfo = arrInfo;
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
    return self.arrInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Celled";

    ZCIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZCIncomeTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    ZCWalletOredrInfo *info = [self.arrInfo objectAtIndex:indexPath.row];
    cell.lbTime.text = [self stDateToString1:info.update_time];
    cell.lbMoney.text = [NSString stringWithFormat:@"%@",info.trade_amount];
    cell.lbTitle.text = @"提现";
    if ([info.trade_amount intValue]>10) {
        cell.lbMoney.text = [NSString stringWithFormat:@"+%@",info.trade_amount];
        cell.lbTitle.text = @"运单收入";
    }



    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    ZCTakeInDetailViewController *vc = [ZCTakeInDetailViewController new];
    ZCWalletOredrInfo *info = [self.arrInfo objectAtIndex:indexPath.row];
    vc.walletInfo = info;


    [self.navigationController pushViewController:vc animated:YES];
}





/**
 *  get
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;

        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

              tableView.tableFooterView = [UIView new];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        _tvList = tableView;
    }
    return _tvList;
}



@end
