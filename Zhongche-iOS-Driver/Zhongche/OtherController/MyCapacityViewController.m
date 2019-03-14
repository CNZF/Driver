//
//  MyCapacityViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "MyCapacityViewController.h"
#import "CapacityDetailsViewController.h"
#import "CapacityTabViewCell.h"
#import "CapacityViewModel.h"

@interface MyCapacityViewController()<UITableViewDelegate,UITableViewDataSource,CapacityDetailsDelegate>
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSMutableArray * dataArray;//运力列表内容
@property (nonatomic, strong) UITableView * tableView;//运力列表
@end

@implementation MyCapacityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的运力";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    [self.btnRight setTitle:@"历史记录" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 60, 30);
    self.type = 1;
}
- (void)bindView
{
    self.tableView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.tableView];
}
-(void)bindAction
{
    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadingorderData];
    }];
}
-(void)setType:(int)type
{
    _type = type;
    [self loadingorderData];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)creatUI
{
    _tableView.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetHeight(self.view.frame));
    [self.view addSubview:_tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[CapacityTabViewCell class] forCellReuseIdentifier:@"CapacityTabViewCell"];
        _tableView = tableView;
    }
    return _tableView;
}

-(void)loadingorderData
{
    UserInfoModel * user = USER_INFO;
    WS(ws);
    //user.iden
    [[[CapacityViewModel alloc] init] selectCapacityWithType:self.type WithDriverid:user.iden callback:^(NSMutableArray *arrInfo) {
        [ws.dataArray removeAllObjects];
        for (CapacityModel * model in arrInfo) {
            [ws.dataArray addObject:model];
        }
        [_tableView reloadData];
        [ws.tableView.mj_header endRefreshing];
    }];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CapacityTabViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CapacityTabViewCell" forIndexPath:indexPath];
    CapacityModel * model = self.dataArray[indexPath.row];
    [cell loadUIWithmodel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
//制定个性标题，这里通过UIview来设计标题，功能上丰富，变化多。
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 50)];
    label.backgroundColor = APP_COLOR_GRAY_LINE;
    label.textColor = APP_COLOR_GRAY_TEXT;
    label.text = @"  当前订单";
    label.font = [UIFont systemFontOfSize:20.0f];
    return label;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (void)onRightAction {
//    CapacityOfHistoryViewController * vc = [[CapacityOfHistoryViewController alloc]init];

//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CapacityModel * model = _dataArray[indexPath.row];
    CapacityDetailsViewController * vc = [[CapacityDetailsViewController alloc]init];
    vc.capacityID = model.ID;
    vc.capacityDetailsDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)agreeORdisagreeCapacityDetails
{
    [self loadingorderData];
}

@end
