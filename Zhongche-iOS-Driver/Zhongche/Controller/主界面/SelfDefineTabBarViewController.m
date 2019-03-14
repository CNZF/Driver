//
//  SelfDefineTabBarViewController.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "SelfDefineTabBarViewController.h"
#import "MLNavigationController.h"
#import "TabbarView.h"
#import "BillHomeViewController.h"
#import "SellHomeViewController.h"
#import "PersonHomeViewController.h"
#import "UserInfoModel.h"
#import <UIScrollView+MJRefresh.h>
#import "AppDelegate.h"
#import "UpCIDViewModel.h"
#import "UserInfoModel.h"

@interface SelfDefineTabBarViewController ()

//视图
@property (nonatomic, strong) TabbarView * tabbarView;//基础底部视图
@property (nonatomic, strong) UIView * billView;
@property (nonatomic, strong) UIView * sellView;
@property (nonatomic, strong) UIView * personView;

//控制器
@property (nonatomic, strong) BillHomeViewController * billHomeController;
@property (nonatomic, strong) SellHomeViewController * sellHomeController;
@property (nonatomic, strong) PersonHomeViewController * personHomeController;

@end

@implementation SelfDefineTabBarViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置导航条背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black.png"] forBarMetrics:UIBarMetricsDefault];
    //设置导航条字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.view addSubview:self.tabbarView];
    [self addDefaultTabbarSubViews];
    if (USER_INFO) {
        NSString * CID = [[NSUserDefaults standardUserDefaults] objectForKey:@"GeTuiCID"];
        if (CID) {
          [self upDateCIDWith:CID];
        }
        
    }
    
    
}

- (void)upDateCIDWith:(NSString *)cid
{
    UpCIDViewModel * vm = [UpCIDViewModel new];
    [vm upDateCIDWith:cid];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDefaultTabbarSubViews
{
    if (!_billHomeController) {
        self.billHomeController = [[UIStoryboard storyboardWithName:@"Business" bundle:nil] instantiateViewControllerWithIdentifier:@"BillHomeViewController"];
        self.billView = self.billHomeController.view;
        self.billView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-57-kiPhoneFooterHeight);
        [self.view addSubview:self.billView];
        [self addChildViewController:self.billHomeController];
    }
    [self.view bringSubviewToFront:self.tabbarView];
}


- (TabbarView *)tabbarView
{
    __weak typeof(self) WeakSelf = self;
    if (!_tabbarView) {
        _tabbarView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TabbarView class]) owner:self options:nil] firstObject];
        _tabbarView.frame = CGRectMake(0, SCREEN_H-88-kiPhoneFooterHeight, SCREEN_W, 130);
        [_tabbarView setBlock:^(NSInteger selectIndex) {

            if (selectIndex == WeakSelf.index && selectIndex!=1) return ;
            WeakSelf.index = selectIndex;
            
            switch (selectIndex) {
                case 0:
                    if (!WeakSelf.billHomeController) {
                        WeakSelf.billHomeController  = [[UIStoryboard storyboardWithName:@"Business" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([BillHomeViewController class])];
                        WeakSelf.billView = WeakSelf.billHomeController.view;
                        WeakSelf.billView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-57-kiPhoneFooterHeight);
                        [WeakSelf.view addSubview:WeakSelf.billView];
                        [WeakSelf addChildViewController:WeakSelf.billHomeController];
                    }else{
                        [WeakSelf.view addSubview:WeakSelf.billView];
                    }
                    [WeakSelf.sellView removeFromSuperview];
                    [WeakSelf.personView removeFromSuperview];
                    [WeakSelf.billHomeController RefrenshData];
                    
                    break;
                case 1:
                    if (USER_INFO) {
                         UserInfoModel * info = USER_INFO;
                        if (info.userType != 3) {
                            [[Toast shareToast]makeText:@"您没有权限出售运力" aDuration:1];
                            return ;
                        }else{
                            if (!WeakSelf.sellHomeController) {
                                WeakSelf.sellHomeController  = [[UIStoryboard storyboardWithName:@"Business" bundle:nil] instantiateViewControllerWithIdentifier:@"SellHomeViewController"];
                                [WeakSelf addChildViewController:WeakSelf.sellHomeController];
                                WeakSelf.sellView = WeakSelf.sellHomeController.view;
                                WeakSelf.sellView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-57-kiPhoneFooterHeight);
                                [WeakSelf.view addSubview:WeakSelf.sellView];
                            }else{
                                [WeakSelf.view addSubview:WeakSelf.sellView];

                            }
                            [WeakSelf.billView removeFromSuperview];
                            [WeakSelf.personView removeFromSuperview];
                            [WeakSelf.sellHomeController requestCarInfo];
                        }
                    }

                    break;
                case 2:
                    if (!WeakSelf.personHomeController) {
                        WeakSelf.personHomeController  = [[UIStoryboard storyboardWithName:@"Business" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonHomeViewController"];
                        [WeakSelf addChildViewController:WeakSelf.personHomeController];
                        WeakSelf.personView = WeakSelf.personHomeController.view;
                        WeakSelf.personView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-57-kiPhoneFooterHeight);
                        [WeakSelf.view addSubview:WeakSelf.personView];
                    }else{
                        [WeakSelf.view addSubview:WeakSelf.personView];
                    }
                    [WeakSelf.billView removeFromSuperview];
                    [WeakSelf.sellView removeFromSuperview];
                    
                    break;
                default:
                    break;
            }
            [WeakSelf.view bringSubviewToFront:WeakSelf.tabbarView];
            
        }];
    }
    return _tabbarView;
}


@end
