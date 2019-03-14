//
//  LinesViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "LinesViewController.h"
#import "AddPreferenceRouteCell.h"

@implementation LinesViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = APP_COLOR_GRAY_LINE;
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = NO;
    if (self.type == 1) {
        self.title = @"选择路线";
    }
    else if (self.type == 2) {
        self.title = @"选择优选路线";
        
        [self.groupingData removeAllObjects];
        [self.groupingData addObject:@"个人偏爱路线"];
        [self.groupingData addObject:@"系统推荐路线"];
        
        [self.routeTbv registerClass:[AddPreferenceRouteCell class] forCellReuseIdentifier:@"AddPreferenceRouteCell"];
        self.routeTbv.allowsMultipleSelection = YES;
        
        [self.btnRight setImage:nil forState:UIControlStateNormal];
        [self.btnRight setTitle:@"完成" forState:UIControlStateNormal];
        self.btnRight.frame = CGRectMake(0, 0, 60, 30);
    }
    [self loadData];
}

-(void)bindView {
    self.cellClass = @"UITableViewCell";
    self.routeTbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.routeTbv];
}

-(void)loadData {
    
    WS(ws);
    if (self.type == 1)
    {
        
        [[[PreferLineViewModel alloc]init]getCapacityDetailsWithStartPositionCode:ws.citycode callback:^(NSMutableArray *info) {
            NSMutableArray * array = ws.dataArray[0];
            [array removeAllObjects];
            for (LineModel * model in info)
            {
                [array addObject:model];
            }
            [ws.routeTbv reloadData];
        }];
    }
    if (self.type == 2)
    {
        UserInfoModel * user = USER_INFO;
        PreferLineViewModel * vm =[[PreferLineViewModel alloc]init];
        [vm getCapacityDetailsWithDriverId:user.iden callback:^(NSMutableArray *info) {
            NSMutableArray * arr = ws.dataArray[0];
            [arr removeAllObjects];
            for (LineModel * model in info)
            {
                [arr addObject:model];
                [ws.routeTbv reloadData];
            }
        }];
        [vm getCapacityDetailsWithStartPositionCode:self.citycode callback:^(NSMutableArray *info) {
            NSMutableArray * array = ws.dataArray[1];
            [array removeAllObjects];
            for (LineModel * model in info)
            {
                [array addObject:model];
            }
            [ws.routeTbv reloadData];
        }];
    }
}

- (void)onRightAction {
    NSArray * deleteS = [self.routeTbv indexPathsForSelectedRows];
    if(deleteS.count > 5)
    {
        [[Toast shareToast]makeText:@"优选线路最多5条" aDuration:1];
        return ;
    }
    NSMutableArray * lines = [NSMutableArray array];
    LineModel * model;
    for(NSIndexPath * path in deleteS)
    {
        model = self.dataArray[path.section][path.row];
        [lines addObject:model];
    }
    [self.linesDeldgate getLines:lines];
    [self onBackAction];
}

/**
 *  tableView 代理
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    LineModel * model = self.dataArray[indexPath.section][indexPath.row];
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellClass forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",model.startName,model.endName];
    }
    else if(indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddPreferenceRouteCell" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSString * str1 = [NSString stringWithFormat:@"%@-%@",model.startName,model.endName];
        NSString * str2 = [NSString stringWithFormat:@"%d天送达",model.expect_time];
        NSString * str = [NSString stringWithFormat:@"%@  %@",str1,str2];
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:str1]];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[str rangeOfString:str1]];
        [attStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT range:[str rangeOfString:str2]];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:str2]];
        ((AddPreferenceRouteCell *)cell).labeltext = attStr;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (self.type == 2) {
        return ;
    }
    [self.linesDeldgate getLines:[NSArray arrayWithObject:self.dataArray[0][indexPath.row]]];
    [self onBackAction];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.groupingData[section];
}
@end
