//
//  addPreferenceRouteViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "AddPreferenceRouteViewController.h"
#import "AddPreferenceRouteCell.h"
#import "PreferLineViewModel.h"
#import "ZCCityListViewController.h"

@interface AddPreferenceRouteViewController()<ZCCityListViewControllerDelagate>

@property (nonatomic, strong) UIView * cityView;
@property (nonatomic, strong) UILabel * cVLabel;
@property (nonatomic, strong) UIButton * cVBtn;
@property (nonatomic, strong) UILabel * reminderLab;
@property (nonatomic, assign) int citycode;
@end

@implementation AddPreferenceRouteViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = APP_COLOR_GRAY_LINE;
    self.title = @"添加偏爱路线";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    [self.btnRight setTitle:@"完成" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 60, 30);
    
    [self loadData];
}
- (void)bindView
{
    self.cityView.frame = CGRectMake(0,0, SCREEN_W, 60);
    [self.view addSubview:self.cityView];
    
    self.cVLabel.frame = CGRectMake(10, 10, 150, 40);
    [self.cityView addSubview:self.cVLabel];
    
    self.cVBtn.frame = CGRectMake(SCREEN_W - 100 - 10, 10, 100, 40);
    [self.cityView addSubview:self.cVBtn];
    
    self.reminderLab.frame = CGRectMake(0, CGRectGetMaxY(self.cityView.frame), SCREEN_W, 60);
    [self.view addSubview:self.reminderLab];
    
    self.cellClass = @"AddPreferenceRouteCell";
    self.routeTbv.allowsMultipleSelection = YES;
    self.routeTbv.frame = CGRectMake(0, CGRectGetMaxY(self.reminderLab.frame), SCREEN_W, SCREEN_H - 64 - CGRectGetMaxY(self.reminderLab.frame));
    self.routeTbv.backgroundColor = APP_COLOR_GRAY_LINE;
    [self.view addSubview:self.routeTbv];
}
- (void)bindAction
{
    WS(ws);
    [[self.cVBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws cVBtnClick];
    }];
}

- (void)bindModel
{

}
- (void)loadData
{
    WS(ws);
    [[[PreferLineViewModel alloc]init]getCapacityDetailsWithStartPositionCode:self.citycode callback:^(NSMutableArray *info) {
        NSMutableArray * array = ws.dataArray[0];
        [array removeAllObjects];
        for (LineModel * model in info)
        {
            [array addObject:model];
        }
        [ws.routeTbv reloadData];
    }];
}
- (UIView *)cityView
{
    if (!_cityView) {
        _cityView = [UIView new];
        _cityView.backgroundColor = [UIColor whiteColor];
    }
    return _cityView;
}
- (UILabel *)cVLabel
{
    if (!_cVLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:18];
        _cVLabel = label;
    }
    return _cVLabel;
}
- (UIButton *)cVBtn
{
    if (!_cVBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"更换城市" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _cVBtn = button;
    }
    return _cVBtn;
}
- (UILabel *)reminderLab
{
    if (!_reminderLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT;
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"偏爱路线最多5条哦";
        _reminderLab = label;
    }
    return _reminderLab;
}
- (void)cVBtnClick
{
    ZCCityListViewController * vC = [[ZCCityListViewController alloc]init];
    vC.getCityDelagate = self;
    [self.navigationController pushViewController:vC animated:YES] ;
}
- (void)onRightAction
{
    NSArray * deleteS = [self.routeTbv indexPathsForSelectedRows];
    if (deleteS.count > 5) {
        [[Toast shareToast]makeText:@"偏爱路线最多5条" aDuration:1];
        return ;
    }
    NSMutableArray * lines =[NSMutableArray array];
    NSMutableDictionary * lineDict;
    LineModel * lineModel;
    for (NSIndexPath * index in deleteS)
    {
        lineModel = self.dataArray[0][index.row];
        lineDict = [NSMutableDictionary dictionary];
        [lineDict setObject:[NSString stringWithFormat:@"%d",lineModel.ID] forKey:@"id"];
        [lineDict setObject:[NSString stringWithFormat:@"%d",lineModel.startCode] forKey:@"startPositionCode"];
        [lineDict setObject:[NSString stringWithFormat:@"%d",lineModel.endCode] forKey:@"endPositionCode"];
        [lines addObject:lineDict];
    }
    if (lines.count != 0) {
        UserInfoModel * user = USER_INFO;
        WS(ws);
        [[[PreferLineViewModel alloc]init]addCapacityDetailsWithDriverId:user.iden Withlines:lines callback:^(BOOL isOk)
         {
             if(isOk)
             {
                 [ws.addSuccessfulDelegate addPreferenceSuccessful];
                 [ws onBackAction];
             }
         }];
    }
    [self onBackAction];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddPreferenceRouteCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellClass forIndexPath:indexPath];
    LineModel * model = self.dataArray[0][indexPath.row];
    NSString * str1 = [NSString stringWithFormat:@"%@-%@",model.startName,model.endName];
    NSString * str2 = [NSString stringWithFormat:@"%d天送达",model.expect_time];
    NSString * str = [NSString stringWithFormat:@"%@  %@",str1,str2];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:str1]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[str rangeOfString:str1]];
    [attStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT range:[str rangeOfString:str2]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:str2]];
    cell.labeltext = attStr;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([self.routeTbv indexPathsForSelectedRows] == nil || [[self.routeTbv indexPathsForSelectedRows] indexOfObject:indexPath] == NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    AddPreferenceRouteCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddPreferenceRouteCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
-(void)getCityModel:(CityModel *)cityModel
{
    if (self.citycode != [cityModel.startPositionCode intValue])
    {
        NSIndexPath * indexpath;
        for (int  i = 0; i < ((NSMutableArray *)self.dataArray[0]).count; i ++) {
            indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.routeTbv deselectRowAtIndexPath:indexpath animated:NO];
            [self tableView:self.routeTbv didDeselectRowAtIndexPath:indexpath];
        }
        self.citycode = [cityModel.startPositionCode intValue];
        self.cVLabel.text = cityModel.startPosition;
        [self loadData];
    }
}
@end
