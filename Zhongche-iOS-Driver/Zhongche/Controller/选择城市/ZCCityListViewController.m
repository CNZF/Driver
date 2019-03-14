//
//  ZCCityListViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCityListViewController.h"
#import "ZCCityListViewModel.h"
#import "NSString+InOrderSubstring.h"

@interface ZCCityListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
#pragma mark - 属性声明部分
@property (nonatomic, strong) UITableView    * cityList;
@property (nonatomic, strong) NSMutableArray * cityArray;//城市列表
@property (nonatomic, strong) NSMutableArray * allCitys;
@property (nonatomic, strong) UISearchBar    * searchBar;//搜索栏

@end

@implementation ZCCityListViewController
#pragma mark -初始化部分

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"选择基地";
    self.btnRight.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)bindView {
    self.searchBar.frame = CGRectMake(0, 0, SCREEN_W, 40*SCREEN_H_COEFFICIENT);
    [self.view addSubview:self.searchBar];
    
    self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame) - 64);
    [self.view addSubview:self.cityList];
}

-(void)bindModel {
    self.searchBar.placeholder = @"请输入城市名称";
    
    ZCCityListViewModel * vm = [[ZCCityListViewModel alloc]init];
    WS(ws);
    [vm getCityListWithType:self.type WithCallback:^(NSArray *cityArray) {
        [ws.allCitys removeAllObjects];
        for (CityModel * city in cityArray)
        {
            [ws.allCitys addObject:city];
        }
        [self loadCitysWithString:@""];
    }];
    
}

- (void)loadCitysWithString:(NSString *)cityName {
    [self.cityArray removeAllObjects];
    NSMutableArray * citys;
    for (int i = 'A'; i <= 'Z';  i ++)
    {
        citys = [[NSMutableArray alloc]init];
        [self.cityArray addObject:citys];
    }
    for(CityModel * city in self.allCitys)
    {
        if ([cityName isEqualToString:@""]) {
            [(NSMutableArray *)(self.cityArray[[city.startPinyin characterAtIndex:0] - 'A']) addObject:city];
        }
        else if ([cityName isInOrderSubstringForSting:city.startPosition])
        {
            [(NSMutableArray *)(self.cityArray[[city.startPinyin characterAtIndex:0] - 'A']) addObject:city];
        }
    }
    for (NSInteger i = self.cityArray.count - 1;i >= 0;i--)
    {
        citys = self.cityArray[i];
        if (citys.count == 0)
        {
            [self.cityArray removeObjectAtIndex:i];
        }
        else
        {
            [citys sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
                NSString * str1 = [NSString stringWithString:((CityModel *)obj1).startPosition];
                NSString * str2 = [NSString stringWithString:((CityModel *)obj2).startPosition];
                return [str1 compare:str2];
            }];
        }
    }
    [self.cityList reloadData];
}

- (NSString *)type {
    if (!_type) {
//        _type = @"getCityList";
        _type = @"user";
        
    }
    return _type;
}

#pragma mark - 属性懒加载部分

- (UITableView *)cityList {
    if (!_cityList) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityTableviewCell"];
        _cityList = tableView;
    }
    return _cityList;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
    }
    return _searchBar;
}

- (NSMutableArray *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray new];
    }
    return _cityArray;
}

- (NSMutableArray *)allCitys {
    if (!_allCitys) {
        _allCitys = [NSMutableArray new];
    }
    return _allCitys;
}

#pragma mark - tabview代理

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cityTableviewCell" forIndexPath:indexPath];
    cell.textLabel.text = ((CityModel *)(self.cityArray[indexPath.section][indexPath.row])).startPosition;
    cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255/.0f alpha:1];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)(self.cityArray[section])).count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CityModel * model = self.cityArray[section][0];
    return model.startPinyin;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexs=[[NSMutableArray alloc]init];
    CityModel * model;
    for(NSArray * citys in self.cityArray){
        model = citys[0];
        [indexs addObject:model.startPinyin];
    }
    return indexs;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *model  = self.cityArray[indexPath.section][indexPath.row];
    model.type = self.cityType;
//    [self.getCityDelagate getCityModel:model];
    
    if (self.block) {
        self.block(model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate

//输入文本实时更新时调用
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self loadCitysWithString:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [self loadCitysWithString:@""];
    [searchBar resignFirstResponder];
}

#pragma mark - 键盘
- (void)keyboardWasShown:(NSNotification*)aNotification{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame) - 64 - keyBoardFrame.size.height);
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame) - 64);
}

@end
