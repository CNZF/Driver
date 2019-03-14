//
//  ZCSaleTransportationViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/3.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCSaleTransportationViewController.h"
#import "ZCSaleTransportationTableViewCell.h"
#import "SellCapacityViewModel.h"

@interface ZCSaleTransportationViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIView                *viHead;
@property (nonatomic, strong) UILabel               *lbHead1;
@property (nonatomic, strong) UILabel               *lbHead2;
@property (nonatomic, strong) UITableView           *tvList;
@property (nonatomic, strong) NSArray               *arrTitle;
@property (nonatomic, strong) UILabel               *lbBottom;
@property (nonatomic, strong) UIButton              *btnRefuse;
@property (nonatomic, strong) UIButton              *btnChangePrice;
@property (nonatomic, strong) ZCTransportationModel *info;
@property (nonatomic, strong) UITextField           *tfChange;



@end

@implementation ZCSaleTransportationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {

    self.title = @"出售运力详情";

    [self HeadViewMake];
    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 120);

    self.tvList.tableHeaderView = self.viHead;


    [self.view addSubview:self.tvList];

    self.lbBottom.frame = CGRectMake(0, SCREEN_H  - 140, SCREEN_W, 100);
    [self.view addSubview:self.lbBottom];

    self.btnRefuse.frame =CGRectMake(20, SCREEN_H  - 125, SCREEN_W/2 - 30, 44);
    [self.view addSubview:self.btnRefuse];

    self.btnChangePrice.frame =CGRectMake(self.btnRefuse.right + 20, SCREEN_H  - 125, SCREEN_W/2 - 30, 44);
    [self.view addSubview:self.btnChangePrice];

    [self getData];
    
}

- (void)bindModel {
    self.arrTitle = @[ @"计划载货时间： 2016-05-16 10:00", @"车牌号： 京N12321", @"车辆类型： 集装箱", @"运力出售单：YL2130089900"];
}

- (void)bindAction {

    WS(ws);

    [[self.btnChangePrice rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws ChangePrice];
    }];

    [[self.btnRefuse rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws refuseAction];
    }];
}

- (void)getData {


    /**
     "endCode": "130600",
     "startCode": "520400",
     "startTime": 1473782400000,
     "id": 11,
     "startName": "贵州省安顺市",
     "price": 1000,
     "status": 0,
     "vehicleCode": "京124578",
     "endName": "河北省保定市",
     "code": "ec29391b-243b-4460-b289-11dbc3de28e3"
     */

    WS(ws);

    SellCapacityViewModel *vc = [SellCapacityViewModel new];
    [vc selectCapacityDetailWith:self.capacityId callback:^(ZCTransportationModel *info) {

        //NSString转NSDate

        

        NSDate * date = [NSDate dateWithTimeIntervalSince1970:[info.startTime longLongValue]/1000];
        NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];


        ws.arrTitle = @[  [NSString stringWithFormat:@"计划载货时间： %@",[outputFormatter stringFromDate:date]], [NSString stringWithFormat:@"车辆类型： %@",info.vehicleType],[NSString stringWithFormat: @"运力出售单：%@",info.code]];

        ws.info = info;

        [ws.tvList reloadData];


    }];
    
}

- (void) HeadViewMake {

    self.lbHead1.frame = CGRectMake(20, 30, SCREEN_W - 20 , 20);
    [self.viHead addSubview:self.lbHead1];

    self.lbHead2.frame = CGRectMake(20, self.lbHead1.bottom + 20, SCREEN_W - 20, 20);
    [self.viHead addSubview:self.lbHead2];

}

- (void) ChangePrice {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更改价格" message: [NSString stringWithFormat:@"当前价格为￥%@，更改为",self.info.price] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField *tf=[alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
     [alert show];

}

- (void)refuseAction {

    WS(ws);

    SellCapacityViewModel *vc = [SellCapacityViewModel new];
    [vc cancleWith:self.capacityId callback:^{

        [[Toast shareToast]makeText:@"取消成功" aDuration:1];
        [ws.navigationController popViewControllerAnimated:YES];

    }];



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

    if (section == 1) {

        return self.arrTitle.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        return 122;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Celled";

    if (indexPath.section == 0) {

        ZCSaleTransportationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ZCSaleTransportationTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


        if (self.info) {
            cell.lbstart.text = self.info.startName;
            cell.lbstart.numberOfLines = 0;
            cell.lbend.text = self.info.endName;
            cell.lbend.numberOfLines = 0;
            cell.lbred.text = [NSString stringWithFormat:@"￥%@",self.info.price];
        }

        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];


            NSRange range;
            NSString *tmpStr = [self.arrTitle objectAtIndex:indexPath.row];
            range = [tmpStr rangeOfString:@"："];

            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tmpStr];


            [AttributedStr addAttribute:NSForegroundColorAttributeName

                                  value:[UIColor grayColor]

                                  range:NSMakeRange(range.location,tmpStr.length - range.location)];

            cell.textLabel.attributedText = AttributedStr;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];



        return cell;
    }


    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

/**
 *
 *  @param UIAlertView  delegate
 *
 *  @return
 */


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        if ([tf.text isEqualToString:@""]) {
            [[Toast shareToast]makeText:@"更改价格不能为空" aDuration:1];
        }else {

            WS(ws);
            SellCapacityViewModel *vc = [SellCapacityViewModel new];
            [vc changePriceWith:self.capacityId WithPrice:tf.text callback:^{

                [ws getData];

            }];


        }

    }


}

/**
 *  getter
 */

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = APP_COLOR_PURPLE;
    }
    return _viHead;
}

- (UILabel *)lbHead1 {
    if (!_lbHead1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:23.0f];
        label.text = @"待买家付款";

        _lbHead1 = label;
    }
    return _lbHead1;
}

- (UILabel *)lbHead2 {
    if (!_lbHead2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        if (SCREEN_W <350) {
            label.font = [UIFont systemFontOfSize:14.0f];
        }
        label.text = @"运力已出售，请联系买家确认吧~";



        _lbHead2 = label;
    }
    return _lbHead2;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140) style:UITableViewStyleGrouped];
        tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;

        _tvList = tableView;
    }
    return _tvList;
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

- (UIButton *)btnRefuse {
    if (!_btnRefuse) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"取消订单" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnRefuse = button;
    }
    return _btnRefuse;
}

- (UIButton *)btnChangePrice {
    if (!_btnChangePrice) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"更改价格" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnChangePrice = button;
    }
    return _btnChangePrice;
}

- (UITextField *)tfChange {
    if (!_tfChange) {
        _tfChange = [UITextField new];
        _tfChange.placeholder = @"输入更改的价格(元)";
    }
    return _tfChange;
}



@end
