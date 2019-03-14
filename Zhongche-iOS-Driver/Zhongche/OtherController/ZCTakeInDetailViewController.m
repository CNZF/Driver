//
//  ZCTakeInDetailViewController.m
//  Zhongche
//
//  Created by lxy on 2016/10/26.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCTakeInDetailViewController.h"


@interface ZCTakeInDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSArray     *arrTitle;
@property (nonatomic, strong) NSArray     *arrStDetail;

@end

@implementation ZCTakeInDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.title                = @"收入详情";

    self.tvList.frame         = CGRectMake(0, -10, SCREEN_W, SCREEN_H - 120);
    [self.view addSubview:self.tvList];
    
}

- (void)bindModel {

    self.arrTitle = @[@[@"出账金额"],@[@"类型",@"时间",@"交易单号",@"余额",@"备注"]];


    self.arrStDetail = @[@"类型",[self stDateToString2:self.walletInfo.update_time],self.walletInfo.customer_account,[NSString stringWithFormat:@"%.2f",[self.walletInfo.after_trade_amount floatValue]],@"运单结算"];


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

    if (section == 0) {
        return 1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 62;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [[self.arrTitle objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    if (indexPath.section == 1) {
        cell.detailTextLabel.text = [self.arrStDetail objectAtIndex:indexPath.row];
    }

    if (indexPath.section == 0) {
        UILabel *lbMoney = [UILabel new];
        lbMoney.frame = CGRectMake(SCREEN_W - 200, 0, 190, 62);
        lbMoney.text = [NSString stringWithFormat:@"%.2f",[self.walletInfo.trade_amount floatValue]];
        lbMoney.textAlignment = NSTextAlignmentRight;
        lbMoney.textColor = APP_COLOR_ORANGR;
        [cell addSubview:lbMoney];
    }



    return cell;
}




/**
 *  get
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;

        tableView.tableFooterView = [UIView new];
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableView.scrollEnabled = NO;

        _tvList = tableView;
    }
    return _tvList;
}

@end
