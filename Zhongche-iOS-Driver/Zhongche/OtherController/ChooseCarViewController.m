//
//  ChooseCarViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ChooseCarViewController.h"
#import "CarInfoModel.h"
#import "BaseModel.h"
#import "BoxInfoModel.h"


@interface ChooseCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSString    *str;
@property (nonatomic, assign) BOOL        isBox;


@end

@implementation ChooseCarViewController

- (void)viewWillDisappear:(BOOL)animated {
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(self.str);
        }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

-(void)bindView {

    self.btnRight.hidden = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H -64 );
    [self.view addSubview:self.tvList];

    if (self.isBox) {
        self.btnRight.frame = CGRectMake(0, 0, 60, 30);
        [self.btnRight setImage:nil forState:UIControlStateNormal];
        [self.btnRight setTitle:@"确定" forState:UIControlStateNormal];
        self.btnRight.hidden = NO;


    }



}

- (void)bindModel {
     BaseModel *baseinfo = [self.arrInfo objectAtIndex:0];
    if (![baseinfo isKindOfClass:[CarInfoModel class]]){

        self.isBox =YES;
    }
}

- (void)onRightAction{


    self.str = @"";
    for (BoxInfoModel *info in self.arrInfo) {
        if (info.isSelected) {
            self.str = [NSString stringWithFormat:@"%@%d,",self.str,info.index];
        }

    }

    [self.navigationController popViewControllerAnimated:YES];

}


/**
 *
 *  @param tableView delegate
 *
 *  @return
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    }

    BaseModel *baseinfo = [self.arrInfo objectAtIndex:indexPath.row];
    if ([baseinfo isKindOfClass:[CarInfoModel class]]) {

        CarInfoModel *info = [self.arrInfo objectAtIndex:indexPath.row];
        cell.textLabel.text = info.name;

    }else{

        //container_size
        BoxInfoModel *info = [self.arrInfo objectAtIndex:indexPath.row];
        info.index = indexPath.row;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",info.name];

        if (info.isSelected) {

            cell.imageView.image = [UIImage imageNamed:@"同意"];

        }else{
            //没同意

            cell.imageView.image = [UIImage imageNamed:@"没同意"];

        }

    }



    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BaseModel *baseinfo = [self.arrInfo objectAtIndex:indexPath.row];
    if ([baseinfo isKindOfClass:[CarInfoModel class]]) {

//        CarInfoModel *info = [self.arrInfo objectAtIndex:indexPath.row];
        self.str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];


    }else{

         BoxInfoModel *info = [self.arrInfo objectAtIndex:indexPath.row];
        info.isSelected = !info.isSelected;
        [self.tvList reloadData];


    }




}


/**
 *  getting
 *
 *  @return
 */
- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;

        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
        tableView.tableFooterView = [UIView new];


        _tvList = tableView;
    }
    return _tvList;
}




@end
