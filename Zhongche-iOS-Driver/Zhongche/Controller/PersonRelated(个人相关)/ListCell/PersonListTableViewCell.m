//
//  PersonListTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "PersonListTableViewCell.h"
#import "SelfDefineTabBarViewController.h"
#import "ZCWalletViewController.h"
#import "ZCCarManagerViewController.h"
#import "ZCTransportationRecordViewController.h"
#import "ZCHistoryOrderViewController.h"

@interface PersonListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *qbView;
@property (weak, nonatomic) IBOutlet UIView *carView;
@property (weak, nonatomic) IBOutlet UIView *transView;
@property (weak, nonatomic) IBOutlet UIView *hisView;

@property (nonatomic, strong) id target;
@property (nonatomic, strong) SelfDefineTabBarViewController * mainController ;

@end

@implementation PersonListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onqbView1)];
    [self.qbView addGestureRecognizer:tap1];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onqbView2)];
    [self.carView addGestureRecognizer:tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onqbView3)];
    [self.transView addGestureRecognizer:tap3];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onqbView4)];
    [self.hisView addGestureRecognizer:tap4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getTarget:(id)target
{
    _target = target;
    self.mainController = target;
}

- (void)onqbView1
{
    ZCWalletViewController * controller = [[ZCWalletViewController alloc]init];
    [self.mainController.navigationController pushViewController:controller animated:YES];
}
- (void)onqbView2
{
    ZCCarManagerViewController * controller = [[ZCCarManagerViewController alloc]init];
    [self.mainController.navigationController pushViewController:controller animated:YES];
}
- (void)onqbView3
{
    ZCTransportationRecordViewController * controller = [[ZCTransportationRecordViewController alloc]init];
    [self.mainController.navigationController pushViewController:controller animated:YES];
}
- (void)onqbView4
{
    ZCHistoryOrderViewController * controller = [[ZCHistoryOrderViewController alloc]init];
    [self.mainController.navigationController pushViewController:controller animated:YES];
}
@end
