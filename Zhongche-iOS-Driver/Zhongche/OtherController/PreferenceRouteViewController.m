//
//  PreferenceRouteViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PreferenceRouteViewController.h"
#import "PreferenceRouteCell.h"
#import "PreferLineViewModel.h"
#import "AddPreferenceRouteViewController.h"

@interface PreferenceRouteViewController()<AddPreferenceRouteViewControllerDelegate>
@property (nonatomic, strong) UIView * addPreferenceRoute;
@property (nonatomic, strong) UILabel * allRoutes;
@property (nonatomic, strong) UIButton * allRoutesBtn;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, assign) BOOL isEditoring;
@end

@implementation PreferenceRouteViewController
- (void)viewDidLoad
{
    _isEditoring = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"偏爱路线";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    [self.btnRight setTitle:@"取消" forState:UIControlStateSelected];
    self.btnRight.frame = CGRectMake(0, 0, 60, 30);
    
    [self loadData];
}
-(void)loadData
{
    UserInfoModel * user = USER_INFO;
    WS(ws);
    [[[PreferLineViewModel alloc]init]getCapacityDetailsWithDriverId:user.iden callback:^(NSMutableArray *info) {
        NSMutableArray * arr = ws.dataArray[0];
        [arr removeAllObjects];
        for (LineModel * model in info)
        {
            [arr addObject:model];
            [ws.routeTbv reloadData];
        }
    }];
}
-(void)bindView
{
    self.addPreferenceRoute.frame = CGRectMake(0, 0, SCREEN_W, 60);
    [self.view addSubview:self.addPreferenceRoute];
    
    self.allRoutesBtn.frame = CGRectMake(20, 20, 20, 20);
    [self.view addSubview:self.allRoutesBtn];
    
    self.allRoutes.frame = CGRectMake(CGRectGetMaxX(self.allRoutesBtn.frame), 10, SCREEN_W - CGRectGetMaxX(self.allRoutesBtn.frame), 40);
    [self.view addSubview:self.allRoutes];
    
    self.cellClass = @"PreferenceRouteCell";
    self.routeTbv.frame = CGRectMake(0, CGRectGetMaxY(self.addPreferenceRoute.frame), SCREEN_W, SCREEN_H - CGRectGetMaxY(self.addPreferenceRoute.frame) - 60);
    self.routeTbv.allowsSelection = NO;
    self.routeTbv.allowsMultipleSelection = NO;
    [self.view addSubview:self.routeTbv];
    
    self.deleteBtn.frame = CGRectMake(40, SCREEN_H - 64 - 50, SCREEN_W - 80, 40);
    [self.view addSubview:self.deleteBtn];
}
-(void)bindAction
{
    WS(ws);
    [[self.allRoutesBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws allRoutesBtnClick];
    }];
    [[self.deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws deleteBtnClick];
    }];
    
    UITapGestureRecognizer * tapGesture = [UITapGestureRecognizer new];
    [tapGesture addTarget:self action:@selector(addPreferenceRouteAction)];
    [self.addPreferenceRoute addGestureRecognizer:tapGesture];
}
- (UIView *)addPreferenceRoute
{
    if (!_addPreferenceRoute) {
        _addPreferenceRoute = [UIView new];
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
        img.image = [UIImage imageNamed:@"添加"];
        [_addPreferenceRoute addSubview:img];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame), CGRectGetMinY(img.frame) - 10,SCREEN_W - CGRectGetMaxX(img.frame) , 40)];
        NSString * str = @"添加优选线路(优选线路最多5条)";
        NSMutableAttributedString * attrstr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrstr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:@"添加优选线路"]];
        [attrstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[str rangeOfString:@"添加优选线路"]];
        [attrstr addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT range:[str rangeOfString:@"(优选线路最多5条)"]];
        [attrstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:@"(优选线路最多5条)"]];
        label.attributedText = attrstr;
        [_addPreferenceRoute addSubview:label];
    }
    return _addPreferenceRoute;
}
- (UILabel *)allRoutes
{
    if (!_allRoutes) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"全选";
        label.hidden = YES;
        _allRoutes = label;
    }
    return _allRoutes;
}

- (UIButton *)allRoutesBtn
{
    if (!_allRoutesBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"椭圆-32"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        button.hidden = YES;
        _allRoutesBtn = button;
    }
    return _allRoutesBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        button.hidden = YES;
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _deleteBtn = button;
    }
    return _deleteBtn;
}
-(void)allRoutesBtnClick
{
    self.allRoutesBtn.selected = !self.allRoutesBtn.selected;
    NSArray * havearr = [self.routeTbv indexPathsForSelectedRows];
    if (havearr.count == ((NSMutableArray *)self.dataArray[0]).count)
    {
        NSIndexPath * indexpath;
        for (int  i = 0; i < ((NSMutableArray *)self.dataArray[0]).count; i ++) {
            indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.routeTbv deselectRowAtIndexPath:indexpath animated:NO];
            [self tableView:self.routeTbv didDeselectRowAtIndexPath:indexpath];
        }
    }
    else
    {
        NSIndexPath * indexpath;
        for (int  i = 0; i < ((NSMutableArray *)self.dataArray[0]).count; i ++) {
            indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            if ([havearr indexOfObject:indexpath] == NSNotFound || havearr.count == 0)
            {
                [self.routeTbv selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self tableView:self.routeTbv didSelectRowAtIndexPath:indexpath];
            }
        }
    }
}
- (void)addPreferenceRouteAction
{
    NSMutableArray * arr = self.dataArray[0];
    if (arr.count >= 5) {
        [[Toast shareToast]makeText:@"偏爱路线最多5条" aDuration:1];
        return ;
    }
    AddPreferenceRouteViewController * vc = [[AddPreferenceRouteViewController alloc]init];
    vc.addSuccessfulDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)deleteBtnClick
{
    NSArray * deleteS = [self.routeTbv indexPathsForSelectedRows];
    NSMutableArray * lines =[NSMutableArray array];
    for (NSIndexPath * index in deleteS)
    {
        [lines addObject:[NSString stringWithFormat:@"%d",((LineModel *)self.dataArray[0][index.row]).ID]];
    }
    if (lines.count != 0) {
        UserInfoModel * user = USER_INFO;
        WS(ws);
        [[[PreferLineViewModel alloc]init]deleteCapacityDetailsWithDriverId:user.iden Withlines:lines callback:^(BOOL isOk) {
            if(isOk)
            {
                NSMutableArray * array = ws.dataArray[0];
                NSMutableArray * lines = [NSMutableArray array];
                for (NSIndexPath * index in deleteS)
                {
                    [lines addObject:ws.dataArray[0][index.row]];
                }
                for (id obj in lines)
                {
                    [array removeObject:obj];
                }
                [ws.routeTbv reloadData];
            }
        }];
    }
    [self onRightAction];
}
-(void)onRightAction
{
    self.btnRight.selected = !self.btnRight.selected;
    self.addPreferenceRoute.hidden = !self.addPreferenceRoute.hidden;
    self.deleteBtn.hidden = !self.deleteBtn.hidden;
    self.allRoutes.hidden = !self.allRoutes.hidden;
    self.allRoutesBtn.hidden = !self.allRoutesBtn.hidden;
    self.routeTbv.allowsSelection = !self.routeTbv.allowsSelection;
    self.routeTbv.allowsMultipleSelection = !self.routeTbv.allowsMultipleSelection;
    _isEditoring = !_isEditoring;
    NSArray * havearr = [self.routeTbv indexPathsForSelectedRows];
    for (NSIndexPath * indexpath in havearr) {
        [self.routeTbv deselectRowAtIndexPath:indexpath animated:NO];
        [self tableView:self.routeTbv didDeselectRowAtIndexPath:indexpath];
    }
    
    [self.routeTbv reloadData];
    NSLog(@"%@",self.btnRight.titleLabel.text);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferenceRouteCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellClass forIndexPath:indexPath];
    LineModel * model = self.dataArray[0][indexPath.row];
    NSString * str1 = [NSString stringWithFormat:@"%@-%@",model.startName,model.endName];
    NSString * str = [NSString stringWithFormat:@"%@(优选线路最多5条)",str1];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[str rangeOfString:str1]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[str rangeOfString:str1]];
    [attStr addAttribute:NSForegroundColorAttributeName value:APP_COLOR_GRAY_TEXT range:[str rangeOfString:@"(优选线路最多5条)"]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[str rangeOfString:@"(优选线路最多5条)"]];
    cell.labeltext = attStr;
    cell.isEditoring = _isEditoring;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEditoring)
    {
        return indexPath;
    }
    return nil;
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isEditoring)
    {
        return indexPath;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    PreferenceRouteCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.routesBtn.selected = YES;
    if ([tableView indexPathsForSelectedRows].count == ((NSMutableArray *)self.dataArray[0]).count) {
        self.allRoutesBtn.selected = YES;
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PreferenceRouteCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.routesBtn.selected = NO;
    self.allRoutesBtn.selected = NO;
}
-(void)addPreferenceSuccessful
{
    [self loadData];
}
@end
