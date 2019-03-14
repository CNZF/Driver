//
//  HistoryOrderViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/18.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "HistoryOrderViewController.h"
#import "OrderTabViewCell.h"
#import "ZCTransportOrderModel.h"
#import "ZCTransportOrderViewModel.h"
#import "OrderDetailsViewController.h"
#define HEADBUTNSKEY 1024
#define LINEVIEWTAG 555
#define HISTORYORDERTABLEVIEWKEY 333

@protocol HistoryOrderTableViewDelegate <NSObject>

- (void)transportOrderModelClick:(ZCTransportOrderModel *)model;
@end

@interface HistoryOrderTableView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) int type;
@property (nonatomic, strong) UITableView * orderTableview;//运单列表
@property (nonatomic, strong) NSMutableArray * dataArray;//运单列表内容
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, weak) id <HistoryOrderTableViewDelegate>cellClickDelegate;
-(void)loadingorderData;//刷新数据
@end

@implementation HistoryOrderTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        [self creatUI];
    }
    return self;
}
-(void)setType:(int)type
{
    _type = type;
}
- (void)creatUI
{
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetHeight(self.frame));
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[OrderTabViewCell class] forCellReuseIdentifier:@"orderTableviewCell"];
    [self addSubview:_tableView];
    WS(ws);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws loadingorderData];
    }];
}
-(void)loadingorderData
{
    UserInfoModel * user = USER_INFO;
    WS(ws);
    //user.iden
    [[[ZCTransportOrderViewModel alloc] init] selectOrderWithType:self.type WithDriverid:user.iden callback:^(NSMutableArray *arrInfo) {
        [_dataArray removeAllObjects];
        for (ZCTransportOrderModel * model in arrInfo) {
            [_dataArray addObject:model];
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
    OrderTabViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderTableviewCell" forIndexPath:indexPath];
    ZCTransportOrderModel * model = _dataArray[indexPath.row];
    [cell loadUIWithmodel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.cellClickDelegate transportOrderModelClick:self.dataArray[indexPath.row]];
}
@end

@interface HistoryOrderViewController()<UIScrollViewDelegate,HistoryOrderTableViewDelegate>

#pragma mark - 属性声明部分
@property (nonatomic, strong) UIView * headBtns;//头部选择器
@property (nonatomic, strong) NSArray * titileArr;//头部title按钮
@property (nonatomic,strong)UIScrollView * scrollview;//滑动换页
@end

@implementation HistoryOrderViewController
#pragma mark - 初始化部分
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"全部运单";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    HistoryOrderTableView * tbv;
    for (int i = 0; i < 3; i ++) {
        tbv = [self.scrollview viewWithTag:i + HISTORYORDERTABLEVIEWKEY];
        [tbv loadingorderData];
    }
}
- (void)bindView
{
    self.headBtns.frame = CGRectMake(0, 0, SCREEN_W, 43);
    [self.view addSubview:self.headBtns];
    
    self.scrollview.frame = CGRectMake(0, CGRectGetMaxY(self.headBtns.frame), SCREEN_W,SCREEN_H - 64 - 43);
    [self.view addSubview:self.scrollview];
    
    UIButton * btn = [self.headBtns viewWithTag:HEADBUTNSKEY];
    if (!btn.selected)
    {
        [self headbuttonActon:btn];
    }
}
- (void)bindAction
{
    WS(ws);
    for (id obj in self.headBtns.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]] && [obj tag] - HEADBUTNSKEY < self.titileArr.count)
        {
            [[obj rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                
                [ws headbuttonActon:obj];
            }];
        }
    }
}
#pragma mark - 属性懒加载
- (NSArray *)titileArr
{
    if (!_titileArr) {
        _titileArr = @[@"未完成",@"已完成",@"已取消"];
        
    }
    return _titileArr;
}

- (UIView *)headBtns
{
    if (!_headBtns) {
        _headBtns = [UIView new];
        
        UIButton * button;
        UIView * lineV;
        for (int i = 0 ; i < self.titileArr.count; i ++)
        {
            button = [[UIButton alloc]initWithFrame:CGRectMake(i * SCREEN_W / self.titileArr.count, 0, SCREEN_W / self.titileArr.count, 40)];
            [button setTitle:self.titileArr[i] forState:UIControlStateNormal];
            [button setTitleColor:APP_COLOR_GRAY_TEXT forState:UIControlStateNormal];
            [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateSelected];
            button.tag = i + HEADBUTNSKEY;
            [_headBtns addSubview:button];
            if (i == self.titileArr.count - 1) continue ;
            
            lineV = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(button.frame) - 1, 1.0 / 6 * CGRectGetHeight(button.frame), 1, 2.0 / 3 * CGRectGetHeight(button.frame))];
            lineV.backgroundColor = APP_COLOR_GRAY_LINE;
            [button addSubview:lineV];
        }
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,40, SCREEN_W / self.titileArr.count, 3)];
        lineView.tag = LINEVIEWTAG;
        lineView.backgroundColor = APP_COLOR_BLUE;
        [_headBtns addSubview:lineView];
    }
    return _headBtns;
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [UIScrollView new];
        _scrollview.delegate = self;
        _scrollview.bounces = NO;
        _scrollview.contentSize = CGSizeMake(self.titileArr.count * SCREEN_W,SCREEN_H - 64 - 43);
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.pagingEnabled = YES;
        CGPoint point = {0,0};
        _scrollview.contentOffset = point;
        
        HistoryOrderTableView * tbv;
        for (int i = 0; i < self.titileArr.count; i ++)
        {
            tbv = [[HistoryOrderTableView alloc]initWithFrame:CGRectMake(i * SCREEN_W, 0, SCREEN_W, _scrollview.contentSize.height)];
            tbv.type = i;
            tbv.tag = i + HISTORYORDERTABLEVIEWKEY;
            tbv.cellClickDelegate = self;
            [_scrollview addSubview:tbv];
        }
    }
    return _scrollview;
}
- (void)headbuttonActon:(id)obj
{
    if ([obj isKindOfClass:[UIButton class]] && [obj tag] - HEADBUTNSKEY < self.titileArr.count)
    {
        UIButton * btn = obj;
        if(!btn.selected)
        {
            UIView * line = [self.headBtns viewWithTag:LINEVIEWTAG];
            [UIView animateWithDuration:0.3 animations:^{
                line.frame = CGRectMake(line.frame.size.width * (btn.tag - HEADBUTNSKEY), line.frame.origin.y, line.frame.size.width , line.frame.size.height);
                _scrollview.contentOffset = CGPointMake((btn.tag - HEADBUTNSKEY) * SCREEN_W, 0);
            }];
            for (id obj in self.headBtns.subviews)
            {
                if ([obj isKindOfClass:[UIButton class]] && [obj tag] - HEADBUTNSKEY < self.titileArr.count)
                {
                    [(UIButton *)obj setSelected:NO];
                }
            }
            btn.selected = YES;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int a = (int)(scrollView.contentOffset.x / SCREEN_W);
    UIButton * btn = [self.headBtns viewWithTag:a + HEADBUTNSKEY];
    if (!btn.selected)
    {
        [self headbuttonActon:btn];
    }
}
-(void)transportOrderModelClick:(ZCTransportOrderModel *)model
{
    OrderDetailsViewController * vc = [[OrderDetailsViewController alloc]init];
    vc.billId = [model.waybill_id intValue];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
