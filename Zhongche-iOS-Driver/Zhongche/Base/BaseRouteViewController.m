//
//  BaseRouteViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseRouteViewController.h"

@implementation BaseRouteViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        NSMutableArray * arr1 = [NSMutableArray new];
        [_dataArray addObject:arr1];
        NSMutableArray * arr2 = [NSMutableArray new];
        [_dataArray addObject:arr2];
    }
    return _dataArray;
}
- (NSMutableArray *)groupingData
{
    if (!_groupingData) {
        _groupingData = [NSMutableArray new];
    }
    return _groupingData;
}

- (UITableView *)routeTbv
{
    if (!_routeTbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:NSClassFromString(self.cellClass) forCellReuseIdentifier:self.cellClass];
        _routeTbv = tableView;
    }
    return _routeTbv;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellClass forIndexPath:indexPath];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.groupingData.count == 0) {
        return 1;
    }
    return self.groupingData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSMutableArray *)self.dataArray[section]).count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.groupingData.count == 0) {
        return nil;
    }
    return self.groupingData[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.groupingData.count == 0) {
        return 0;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
