//
//  ZCSellCapacityViewControllerViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/5.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCSellCapacityViewControllerViewController.h"
#import "ZCTransportationModel.h"
#import "ZCCityListViewController.h"
#import "UserInfoViewModel.h"
#import "UserInfoModel.h"
#import "CarInfoModel.h"
#import "SellCapacityViewModel.h"
#import "ZCTransportationRecordViewController.h"
#import "ZCCarManagerViewController.h"

@interface ZCSellCapacityViewControllerViewController ()<UITableViewDelegate,UITableViewDataSource,ZCCityListViewControllerDelagate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView           *tvList;
@property (nonatomic, strong) UILabel               *lbHead;
@property (nonatomic, strong) NSMutableArray        *arrStr;
@property (nonatomic, strong) NSArray               *arrImg;
@property (nonatomic, strong) UIView                *viDate;
@property (nonatomic, strong) UIView                *viBack;
@property (nonatomic, strong) NSArray               *arrCar;
@property (nonatomic, strong) ZCTransportationModel *transpoetation;
@property (nonatomic, strong) UIDatePicker          *datePicker;
@property (nonatomic, strong) UIPickerView          *carPicker;
@property (nonatomic, assign) int                   type;//1、选择时间，2、选择车
@property (nonatomic, strong) UIButton              *btnFinish;
@property (nonatomic, strong) UITextField           *tfPrice;

@end

@implementation ZCSellCapacityViewControllerViewController

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    UserInfoModel *userinfo  = USER_INFO;
    UserInfoViewModel *vm = [UserInfoViewModel new];


    //进入页面刷新当前车辆信息


    self.transpoetation.carInfo  = CAR_INFO;
    WS(ws);
    [vm getBindCarListWithUserId:userinfo.iden callback:^(CarInfoModel *info) {

        [NSKeyedArchiver archiveRootObject:info toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];
        ws.transpoetation.carInfo  = info;
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindModel {



    UserInfoViewModel *vm = [UserInfoViewModel new];
    UserInfoModel *info = USER_INFO;

    WS(ws);

    [vm getCarListWithUserId:info.iden callback:^(NSArray *arr) {

        if (arr.count == 0) {
            [ws.navigationController pushViewController:[ZCCarManagerViewController new] animated:YES];
            [[Toast shareToast]makeText:@"目前没有绑定的车辆" aDuration:1];

        }else {

            ws.arrCar = arr;
            [ws.carPicker reloadAllComponents];


        }


    }];

    self.arrStr = [NSMutableArray arrayWithObjects: @"起始城市",@"终点城市",@"请输入出发日期",@"请输入价格",@"车牌号",@"车辆类型", nil];

    self.arrImg = @[@"point",@"point",@"time",@"price",@"carnum",@"cartype"];


}

- (void)bindView {

    self.title  =@"出售运力";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tvList];

    self.lbHead.frame = CGRectMake(20, 10, SCREEN_W - 20, 30);
    [self.view addSubview:self.lbHead];

    self.viBack.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);

    [self dateViewMake];

    self.btnFinish.frame = CGRectMake(20, SCREEN_H - 130, SCREEN_W - 40, 40);
    [self.view addSubview:self.btnFinish];


}

- (void)bindAction {

    WS(ws);
    [[self.btnFinish rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws saleAction];
    }];
}

//出售运力
- (void)saleAction {



    WS(ws);

    SellCapacityViewModel *vm  =[SellCapacityViewModel new];

    self.transpoetation.price = self.tfPrice.text;

    /**

     [params setValue:model.startTime forKey:@"startTime"];
     [params setValue:[NSString stringWithFormat:@"%i",model.carInfo.support_40gp] forKey:@"suport40"];
     [params setValue:model.carInfo.code forKey:@"vehiclecode"];
     */


    if (self.transpoetation.carInfo && self.transpoetation.startRegionCode && self.transpoetation.price &&self.transpoetation.endRegionCode && self.transpoetation.startTime) {

        if (self.transpoetation.carInfo.auth_status == 2) {

            [vm sellCapacityWith:self.transpoetation callback:^{
                [[Toast shareToast]makeText:@"出售成功" aDuration:1];

                ZCTransportationRecordViewController *vc = [ZCTransportationRecordViewController new];
                vc.type = 1;
                [ws.navigationController pushViewController:vc animated:YES];
            }];

        }else {
            [[Toast shareToast]makeText:@"当前车辆不可用" aDuration:1];
        }



    }else {
        [[Toast shareToast]makeText:@"信息不完整" aDuration:1];
    }



}

//数据视图
- (void)dateViewMake {

    self.datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0,50,SCREEN_W,180)];
    [self.viDate addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;


    self.carPicker.frame = CGRectMake(0.0,50,SCREEN_W,180);
      [self.viDate addSubview:self.carPicker];

    UIView *viTope = [UIView new];
    viTope.backgroundColor = APP_COLOR_PURPLE;
    viTope.frame = CGRectMake(0, 0, SCREEN_W, 50);
    [self.viDate addSubview:viTope];

    UIButton *btnCancle = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 50)];
    [btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    btnCancle.tintColor = [UIColor whiteColor];
    [btnCancle setTitle:@"取消" forState:UIControlStateNormal];
    [viTope addSubview:btnCancle];

    UIButton *btnCentain = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 70, 0, 60, 50)];
    [btnCentain addTarget:self action:@selector(centainAction) forControlEvents:UIControlEventTouchUpInside];
    btnCentain.tintColor = [UIColor whiteColor];
    [btnCentain setTitle:@"确定" forState:UIControlStateNormal];
    [viTope addSubview:btnCentain];

    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];

    [window addSubview:self.viBack];

    self.viDate.frame = CGRectMake(0, SCREEN_H - 250, SCREEN_W, 250);

    [window addSubview:self.viDate];





}

- (void)cancleAction {

    self.viBack.hidden = YES;


    
    self.viDate.hidden = YES;
}

- (void)centainAction {

    [self cancleAction];

    if (self.type == 1) {
        NSDate *date = self.datePicker.date;
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stDate = [dateFormatter stringFromDate:date];
        self.transpoetation.startTime = stDate;

    }
    if (self.type == 2) {
        if (!self.transpoetation.carInfo && self.arrCar.count >0) {
            self.transpoetation.carInfo = [self.arrCar objectAtIndex:0];
        }
    }

    [self.tvList reloadData];

}


/**
 *
 *  @param tableView delegate
 *
 *  @return
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrStr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self.arrStr objectAtIndex:indexPath.row];

        UIImage *img =  [UIImage imageNamed:[self.arrImg objectAtIndex:indexPath.row]];
        cell.imageView.image = img;


        CGSize itemSize = CGSizeMake(img.size.width *2/3, img.size.height *2/3);

        UIGraphicsBeginImageContext(itemSize);

        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);

        [cell.imageView.image drawInRect:imageRect];

        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();


        cell.textLabel.textColor = [UIColor lightGrayColor];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


    }

    if (self.transpoetation.startRegionCode && indexPath.row==0) {
        cell.textLabel.text = self.transpoetation.startRegionName;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (self.transpoetation.endRegionCode && indexPath.row==1) {
        cell.textLabel.text = self.transpoetation.endRegionName;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (self.transpoetation.startTime && indexPath.row==2) {
        cell.textLabel.text = self.transpoetation.startTime;
        cell.textLabel.textColor = [UIColor blackColor];
    }

     if (indexPath.row==3) {

         cell.textLabel.hidden = YES;


         self.tfPrice.frame = CGRectMake(53, 10, SCREEN_W - 60, 40);
         [cell addSubview:self.tfPrice];

     }

    if (self.transpoetation.carInfo && indexPath.row==4) {
        cell.textLabel.text = self.transpoetation.carInfo.code;

        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (self.transpoetation.carInfo && indexPath.row==5) {
        cell.textLabel.text = self.transpoetation.carInfo.vehicle_type;

        cell.textLabel.textColor = [UIColor blackColor];
    }


    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tfPrice resignFirstResponder];
    
    if (indexPath.row == 0) {
        ZCCityListViewController * vc = [[ZCCityListViewController alloc]init];
        vc.cityType = 0;
        vc.getCityDelagate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }

    if (indexPath.row == 1) {
        ZCCityListViewController * vc = [[ZCCityListViewController alloc]init];
        vc.cityType = 1;
        vc.getCityDelagate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }

    if (indexPath.row == 2) {

        self.viBack .hidden= NO;
        self.viDate.hidden = NO;
        self.datePicker.hidden = NO;
        self.carPicker.hidden  =YES;
        self.type = 1;
    }

    if (indexPath.row == 4) {
        self.viBack .hidden= NO;
        self.viDate.hidden = NO;
        self.datePicker.hidden = YES;
        self.carPicker.hidden = NO;
        self.type = 2;
    }

    
}

- (void)getCityModel:(CityModel *)cityModel{

    if (cityModel.type == 0) {

        self.transpoetation.startRegionCode = cityModel.startPositionCode;
        self.transpoetation.startRegionName = cityModel.startPosition;


    }else{

        self.transpoetation.endRegionCode = cityModel.startPositionCode;
        self.transpoetation.endRegionName = cityModel.startPosition;

    }

    [self.tvList reloadData];

}

/**
 *  textField代理方法
 *
 *  @param textField delegate
 *
 *  @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.view endEditing:YES];

    return YES;

}

/**
 *  pickdelegate
 *
 */

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.arrCar count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    CarInfoModel *car = [self.arrCar  objectAtIndex:row];
    return  car.code;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.transpoetation.carInfo = [self.arrCar objectAtIndex:row];

}



/**
 *  getter
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_W, SCREEN_H- 160) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.bounces = NO;

        _tvList = tableView;
    }
    return _tvList;
}

- (UILabel *)lbHead {
    if (!_lbHead) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"发布空车信息";

        _lbHead = label;
    }
    return _lbHead;
}

- (UIView *)viDate {
    if (!_viDate) {
        _viDate = [UIView new];
        _viDate.backgroundColor = [UIColor whiteColor];
        _viDate.hidden = YES;

    }
    return _viDate;
}

- (UIView *)viBack {
    if (!_viBack) {
        _viBack = [UIView new];
        _viBack.backgroundColor = [UIColor blackColor];
        _viBack.alpha = 0.4;
        _viBack.hidden = YES;

    }
    return _viBack;
}


- (UIPickerView *)carPicker {
    if (!_carPicker) {
        _carPicker = [UIPickerView new];
        _carPicker.delegate = self;
        _carPicker.dataSource = self;
    }
    return _carPicker;
}

- (UIButton *)btnFinish {
    if (!_btnFinish) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        _btnFinish = button;
    }
    return _btnFinish;
}


- (UITextField *)tfPrice {
    if (!_tfPrice) {
        _tfPrice = [UITextField new];
        _tfPrice.returnKeyType = UIReturnKeyDone;
        _tfPrice.delegate = self;
        _tfPrice.placeholder = @"请输入价格";
        _tfPrice.keyboardType = UIKeyboardTypeNumberPad;

    }
    return _tfPrice;
}

- (ZCTransportationModel *)transpoetation {
    if (!_transpoetation) {
        _transpoetation = [ZCTransportationModel new];

    }
    return _transpoetation;
}



@end
