//
//  BaseRouteViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseRouteViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * routeTbv;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * groupingData;
@property (nonatomic, copy) NSString * cellClass;
@end
