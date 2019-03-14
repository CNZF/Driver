//
//  ZCMapViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/15.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCMapViewController.h"
#import "PeripheralServicesViewModel.h"
#import "PlaceDetailsModel.h"
#import "QCodeViewController.h"
#import "AlterView.h"
#import "ZCTransportOrderViewModel.h"
#import "MarkViewController.h"
#import "ZCCityTableViewCell.h"
#import "MapCityTableViewCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "SendBreakdownView.h"
#define fDVIEWBTNKEY 1240
#define LEFTBTNKEY 1024

@interface ZCMapViewController()<MAMapViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AMapSearchDelegate>



#pragma mark ----  属性声明部分

@property (nonatomic, strong) UITableView                 *tvList;

@property (nonatomic, strong) MAMapView                   * mapView;//地图

/**
 *  下拉条部分
 */
@property (nonatomic, strong) UIView                      * findView;//下拉条

/**=============下弹框==================*/
@property (nonatomic, strong) UIView                      * findDetailsView;//发现页面
@property (nonatomic, strong) UIView                      * fDViewBg1;//发现部分背景
@property (nonatomic, strong) UIView                      * fDViewTitle;//发现标题
@property (nonatomic, strong) UIView                      * fDViewBtnView;//发现部分四个button
@property (nonatomic, strong) UIView                      * fDViewWebView;//四个按钮下web

/**=============右边侧栏条==================*/
@property (nonatomic, strong) UIView                      * leftButsView;//按钮view
@property (nonatomic, strong) NSArray                     * leftArray;//button title数组

/**=============我的定位==================*/
@property (nonatomic, assign) CLLocationCoordinate2D      ownLocation;//位置坐标

/**=============扫描==================*/
@property (nonatomic, strong) UIView                      *viBackGround;
@property (nonatomic, strong) AlterView                   *viAlter;
@property (nonatomic, strong) NSString                    *stCode;
@property (nonatomic, strong) UITextField                 *tfCode;

@property (nonatomic, strong) UIButton                    *btnBreakdown;//故障按钮

/**=============顶部视图==================*/
@property (nonatomic, strong) UIView                      *viHead;
@property (nonatomic, strong) UILabel                     *lbDays;
@property (nonatomic, strong) UILabel                     *lbTask;
@property (nonatomic, strong) UILabel                     *lbState;
@property (nonatomic, strong) UILabel                     *lbLine;

@property (nonatomic, strong) UIButton                    *btnUpAndDown;

@property (nonatomic, strong) AMapSearchAPI               *search;
@property (nonatomic, strong) AMapRoute *route;

@property (nonatomic, strong) UILabel  *lbWaring;




/* 用于显示当前路线方案. */
@property (nonatomic,strong) MANaviRoute * naviRoute;
@property (nonatomic,strong) NSArray * pathPolylines;
@property (nonatomic, copy)   NSString  *polyline; //!< 此路段坐标点串
@end

@implementation ZCMapViewController

#pragma mark ----初始化部分


- (instancetype)init {
    self = [super init];
    if (self) {
        [AMapServices sharedServices].apiKey = @"f395789433165eab93bb112089be98fe";

        self.ownLocation = CLLocationCoordinate2DMake(0, 0);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.btnRight.hidden = NO;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.model.start_lat floatValue],[self.model.start_lng floatValue]));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.model.end_lat floatValue],[self.model.end_lng floatValue]));
    //    //2.计算距离
    //    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    _mapView.visibleMapRect = MAMapRectMake(MIN(point1.x , point2.x), MIN(point1.y , point2.y),fabs(point1.x - point2.x) * 1.5, fabs(point1.y - point2.y) *1.5);
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(([self.model.start_lat floatValue] + [self.model.end_lat floatValue]) / 2, ([self.model.start_lng floatValue] + [self.model.end_lng floatValue]) / 2);
//    MAMapPoint point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(39.9, 116.39));
//    _mapView.visibleMapRect = MAMapRectMake(point.x - 125000, point.y - 250000,250000,500000);
}

-(void)bindView {
    self.mapView.frame = CGRectMake(0, 0,SCREEN_W , SCREEN_H);
    [self.view addSubview:self.mapView];
    
    
    self.leftButsView.frame = CGRectMake(SCREEN_W - 90, 0, 100, SCREEN_H);
    [self.view addSubview:self.leftButsView];

    self.btnBreakdown.frame = CGRectMake(20, SCREEN_H - 200, 50, 60);
    [self.view addSubview:self.btnBreakdown];
    
    self.findView.frame = CGRectMake(0, SCREEN_H - 114 , SCREEN_W, 50);
    [self.view addSubview:self.findView];
    
    self.findDetailsView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    self.findDetailsView.hidden = YES;
    [self.view addSubview:self.findDetailsView];
    
    self.fDViewBg1.frame = CGRectMake(0, CGRectGetHeight(self.findDetailsView.frame) - 240, SCREEN_W, 240);
    [self.findDetailsView addSubview:self.fDViewBg1];
    
    self.fDViewTitle.frame = CGRectMake(0,0,SCREEN_W , 40);
    [self.fDViewBg1 addSubview:self.fDViewTitle];
    
    self.fDViewBtnView.frame = CGRectMake(0, CGRectGetMaxY(self.fDViewTitle.frame), SCREEN_W, 100);
    [self.fDViewBg1 addSubview:self.fDViewBtnView];
    
    self.fDViewWebView.frame = CGRectMake(0, CGRectGetMaxY(self.fDViewBtnView.frame), SCREEN_W, 100);
    [self.fDViewBg1 addSubview:self.fDViewWebView];

    [self mapViewSet];



    self.viHead.frame = CGRectMake(0, 0, SCREEN_W, 60);
    [self viHeadMake];

    [self.view addSubview:self.tvList];

    

    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upAndDownAction)];
    recognizer.delegate = self;

    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.tvList addGestureRecognizer:recognizer];

    [self.view addSubview:self.viHead];






}



- (void)bindModel {

    if (!self.model.container_code) {
         self.leftArray = @[@"装载",@"发现",@"导航"];
    }else{

        self.leftArray = @[@"抵达",@"发现",@"导航"];

    }
}

- (void)bindAction {
    
    
    WS(ws);

    [[self.btnBreakdown rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws breakUpAction];
    }];



    [[self.btnUpAndDown rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws upAndDownAction];
    }];

    for (UIView * ve in  _fDViewBtnView.subviews)
    {
        if (ve.tag - fDVIEWBTNKEY >= 0 && ve.tag - fDVIEWBTNKEY < 4) {
            [[(UIButton *)ve rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                
                [ws servicesAction:(UIButton *)ve];
            }];
        }
    }
    UIButton * btn;
    for (int i = 0; i < 3; i ++)
    {
        btn = [self.leftButsView viewWithTag:i + LEFTBTNKEY];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            [ws leftBtnAction:btn];
        }];


    }
}

- (void)viHeadMake {

    self.lbDays.frame = CGRectMake(20, 20, 70, 20);
    [self.viHead addSubview:self.lbDays];

    self.lbTask.frame = CGRectMake(self.lbDays.right + 10, 20, 70, 20);
    [self.viHead addSubview:self.lbTask];

    self.lbState.frame = CGRectMake(SCREEN_W - 60, 20, 80, 20);
    [self.viHead addSubview:self.lbState];

    self.lbLine.frame = CGRectMake(0, self.lbDays.bottom + 19, SCREEN_W, 0.5);
    [self.viHead addSubview:self.lbLine];



}


- (void)upAndDownAction {

     WS(ws);

        if (!self.btnUpAndDown.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            ws.tvList.frame = CGRectMake(0,self.viHead.bottom,SCREEN_W,155);


        }];
    }else{

        [UIView animateWithDuration:0.5 animations:^{
            ws.tvList.frame = CGRectMake(0,self.viHead.bottom -120,SCREEN_W,155);


        }];

    }

    self.btnUpAndDown.selected = !self.btnUpAndDown.selected;





}


- (void)breakUpAction {

    //    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"故障情况" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"严重故障,无法继续运输",@"一般故障,但可能延误",@"一般故障,但能按时抵达", nil];
    //    sheet.delegate = self;
    //    [sheet showInView:self.view];

    UserInfoModel * user = USER_INFO;

    WS(ws);

    if (self.model.carrierStatus == 2) {

        SendBreakdownView *view = [SendBreakdownView sharePushOrderView];
        view.btnCertain.tag = view.index;

        [view.btnCertain addTarget:self action:@selector(certainAction:) forControlEvents:UIControlEventTouchUpInside];
        view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];

    }else{


        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.model.waybill_id WithReportcontent:@"cancle" WithDriverid:user.driverId WithType:1 WithWaybillCarrierId:self.model.waybill_carrier_id  callback:^{

            ws.lbWaring.text =  @"故障报警";
            ws.model.carrierStatus = 2;

        }];

    }


}

- (void)certainAction:(UIButton *)btn {

    UserInfoModel * user = USER_INFO;

    SendBreakdownView *view = [SendBreakdownView sharePushOrderView];
    [view removeFromSuperview];
    WS(ws);

    //CanNotFinish    MayFinish  CanFinish
    NSString *st;
    switch ((int)btn.tag) {
        case 0:
            st = @"CanNotFinish";
            break;
        case 1:
            st = @"MayFinish";
            break;
        case 2:
            st = @"CanFinish";
            break;

        default:
            break;
    }

    if (self.model.carrierStatus == 2) {

        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.model.waybill_id WithReportcontent:st WithDriverid:user.driverId WithType:0 WithWaybillCarrierId:self.model.waybill_carrier_id  callback:^{

            ws.lbWaring.text =  @"解除报警" ;
            ws.model.carrierStatus = 1;


        }];

    }else{


        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.model.waybill_id WithReportcontent:st WithDriverid:user.driverId WithType:1 WithWaybillCarrierId:self.model.waybill_carrier_id  callback:^{
            
            ws.lbWaring.text =  @"故障报警";
            ws.model.carrierStatus = 2;
            
        }];
        
    }
    
}


//====================地图========================
- (void)mapViewSet {

    NSString *startpoint = [NSString stringWithFormat:@"{%@,%@}",self.model.start_lat,self.model.start_lng];
    NSString *endpoint = [NSString stringWithFormat:@"{%@,%@}",self.model.end_lat,self.model.end_lng];
    [self addMarkOnMap:CLLocationCoordinate2DMake(CGPointFromString(startpoint).x, CGPointFromString(startpoint).y) withimageNamed:@"组-4-拷贝-3"];
    [self addMarkOnMap:CLLocationCoordinate2DMake(CGPointFromString(endpoint).x, CGPointFromString(endpoint).y) withimageNamed:@"组-4-拷贝-2"];

    //
    //    CLLocationCoordinate2D geodesicCoords[2];
    //    geodesicCoords[0].latitude = CGPointFromString(@"{39.915168,116.403875}").x;
    //    geodesicCoords[0].longitude = CGPointFromString(@"{39.915168,116.403875}").y;
    //
    //    geodesicCoords[1].latitude = CGPointFromString(@"{30.915168,116.403875}").x;
    //    geodesicCoords[1].longitude = CGPointFromString(@"{30.915168,116.403875}").y;

    //    //构造大地曲线对象
    //    MAGeodesicPolyline *geodesicPolyline = [MAGeodesicPolyline polylineWithCoordinates:geodesicCoords count:2];
    //
    //    [_mapView addOverlay:geodesicPolyline];


    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];


    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:[self.model.start_lat floatValue]
                                           longitude:[self.model.start_lng floatValue]];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:[self.model.end_lat floatValue]
                                                longitude:[self.model.end_lng floatValue]];

    [self.search AMapDrivingRouteSearch:navi];


}
//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }

    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];

    AMapPath *path = response.route.paths[0]; //选择一条路径
    AMapStep *step = path.steps[0]; //这个路径上的导航路段数组
    NSLog(@"%@",step.polyline);   //此路段坐标点字符串

    if (response.count > 0)
    {
        //移除地图原本的遮盖
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;

        // 只显⽰示第⼀条 规划的路径
        _pathPolylines = [self polylinesForPath:response.route.paths[0]];

        NSLog(@"%@",response.route.paths[0]);
        //添加新的遮盖，然后会触发代理方法进行绘制
        [_mapView addOverlays:_pathPolylines];
    }
}
//路线解析
- (NSArray *)polylinesForPath:(AMapPath *)path
{
    if (path == nil || path.steps.count == 0)
    {
        return nil;
    }
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline
                                                         coordinateCount:&count
                                                              parseToken:@";"];


        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];


        [polylines addObject:polyline];
        free(coordinates), coordinates = NULL;
    }];
    return polylines;
}
//解析经纬度
- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }

    if (token == nil)
    {
        token = @",";
    }

    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }

    else
    {
        str = [NSString stringWithString:string];
    }

    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));

    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    
    return coordinates;
}



#pragma mark --设置右侧按钮按钮标题
/**
 *   设置右侧按钮按钮标题,同时更新右侧按钮
 *
 *  @param leftArray
 */

-(void)setLeftArray:(NSArray *)leftArray {
    _leftArray = leftArray;
    UIButton * btn;
    NSString * name;
    UILabel * lab;
    UIImageView * img;
    for (int i = 0; i < 3; i ++)
    {
        btn = [self.leftButsView viewWithTag:i + LEFTBTNKEY];
        btn.hidden = YES;
    }
    for (int i = 0; i < leftArray.count ; i ++)
    {
        name = leftArray[i];
        btn = [self.leftButsView viewWithTag:i + LEFTBTNKEY];
        btn.hidden = NO;
        img = [btn viewWithTag:1];
        img.image = [UIImage imageNamed:name];
        lab = [btn viewWithTag:2];
        lab.text = name;
    }
}





#pragma mark - 发现栏按钮点击事件部分

-(void)servicesAction:(UIButton *)btn {
    [self gestureAction1];
    [self.mapView removeAnnotations:_mapView.annotations];
    if (self.ownLocation.longitude != 0 && self.ownLocation.latitude != 0)
    {
        UserInfoModel * user = USER_INFO;
        int type = (int)btn.tag - fDVIEWBTNKEY;
        WS(ws);
        [[[PeripheralServicesViewModel alloc]init] getPeripheralServicesWithType:type WithDriverid:user.iden WithLongitude:self.ownLocation.longitude WithLatitude:self.ownLocation.latitude callback:^(NSMutableArray *arrInfo) {
            NSString * img;
            for (PlaceDetailsModel * model in arrInfo)
            {
                switch (model.type) {
                    case 0:
                        img = @"组-1 (2)";
                        break;
                    case 1:
                        img = @"组-2 (2)";
                        break;
                    case 2:
                        img = @"组-3";
                        break;
                    case 3:
                        img = @"组-4";
                        break;
                    default:
                        break;
                }
                [ws addMarkOnMap:CLLocationCoordinate2DMake(model.longitude, model.latitude) withimageNamed:img];
            }
        }];
    }
    else
    {
        [[Toast shareToast]makeText:@"系统未定位" aDuration:1];
    }
}

#pragma mark - 侧栏栏按钮点击事件部分

-(void)leftBtnAction:(UIButton *)btn {
    UILabel * lab = [btn viewWithTag:2];
    NSLog(@"%@",lab.text);
    if ([lab.text isEqualToString:@"故障解除"])
    {
//        UserInfoModel * user = USER_INFO;
//        WS(ws);
////        [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:_model.ID WithReportcontent:[NSString string] WithDriverid:user.userId WithType:1 callback:^{
////            if(ws.model.waybill_status == 0)
////            {
////                ws.leftArray = @[@"装载",@"发现",@"导航"];
////            }
////            else if(ws.model.waybill_status == 1)
////            {
////                ws.leftArray = @[@"抵达",@"发现",@"导航"];
////            }
////        }];
    }
    else if([lab.text isEqualToString:@"导航"])
    {

        [self gpsBtnAction];

    }
    else if ([lab.text isEqualToString:@"发现"])
    {
        [self gestureAction];
    }
    else if ([lab.text isEqualToString:@"抵达"])
    {
        [self scan];
        
    }
    else if ([lab.text isEqualToString:@"装载"])
    {
        [self scan];
    }
}


//- (void)detailsBtnAction
//{
//    if(self.detailsBtn.frame.origin.y != 0)
//    {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.detailsBtn.frame = CGRectMake(SCREEN_W / 2 - 23*SCREEN_W_COEFFICIENT, 0,self.detailsBtn.frame.size.width,self.detailsBtn.frame.size.height);
//            self.orderView.frame = CGRectMake(0,- CGRectGetMaxY(self.cheakDetailsBtn.frame), SCREEN_W, MAX(CGRectGetMaxY(self.endPointLabel.frame), CGRectGetMaxY(self.cheakDetailsBtn.frame)));
//            
//        }];
//    }
//    else
//    {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.detailsBtn.frame = CGRectMake(SCREEN_W / 2 - 23*SCREEN_W_COEFFICIENT,self.orderView.size.height,self.detailsBtn.frame.size.width,self.detailsBtn.frame.size.height);
//            self.orderView.frame = CGRectMake(0, 0, SCREEN_W, MAX(CGRectGetMaxY(self.endPointLabel.frame), CGRectGetMaxY(self.cheakDetailsBtn.frame)));
//        }];
//    }
//}
-(void)gpsBtnAction {

    MKMapItem * currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem * toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.endPointLat floatValue],[self.endPointLng floatValue]) addressDictionary:nil]];
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

- (void)gestureAction {
    self.findView.hidden = YES;
    self.findDetailsView.hidden = NO;
}

- (void)gestureAction1 {
    self.findView.hidden = NO;
    self.findDetailsView.hidden = YES;
}


/**
 *  扫描方法
 */
- (void)scan{


    WS(ws);
    QCodeViewController *QcVC = [QCodeViewController new];
    [self.navigationController pushViewController:QcVC animated:YES];

    [QcVC returnText:^(NSString *showText) {

        ws.stCode = showText;
        if ([ws.stCode isEqualToString:ws.model.parentCode]) {

            [ws finishShipment];
        }else {
            [[Toast shareToast]makeText:@"二维码无效" aDuration:1];
        }




    }];
}
/**
 *  完成装载
 */
- (void)finishShipment {



    self.viBackGround.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.view addSubview:self.viBackGround];
    self.viAlter = [[AlterView alloc]initWithFrame:CGRectMake(SCREEN_W/2 - 140, 100, 280, 200 )];
    [self.viAlter.btnCancle addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viAlter.btnCentain addTarget:self action:@selector(centainAction) forControlEvents:UIControlEventTouchUpInside];
    if (!self.model.container_code) {


        UILabel *lb = [UILabel new];
        lb.text = @"请输入集装箱编号";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.frame = CGRectMake(0, 30, 280, 40);
        [self.viAlter addSubview:lb];


        self.tfCode = [UITextField new];
        self.tfCode.frame = CGRectMake(10, lb.bottom + 10, 260, 40);
        self.tfCode.layer.borderWidth = 1;
        self.tfCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.viAlter addSubview:self.tfCode];

        [self.view addSubview:self.viAlter];

    }else{


        UILabel *lb = [UILabel new];
        lb.text = @"集装箱编号";
        lb.font = [UIFont systemFontOfSize:22];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.frame = CGRectMake(0, 30, 280, 40);
        [self.viAlter addSubview:lb];

        UILabel *lbNo = [UILabel new];
        lbNo.text = self.model.container_code;
        lb.font = [UIFont systemFontOfSize:20];
        lbNo.textAlignment = NSTextAlignmentCenter;
        lbNo.frame = CGRectMake(0, 80, 280, 40);
        lbNo.textColor = [UIColor grayColor];
        [self.viAlter addSubview:lbNo];

        [self.view addSubview:self.viAlter];
    }
}

- (void)cancleAction {
    [self.viAlter removeFromSuperview];
    [self.viBackGround removeFromSuperview];
}

- (void)centainAction{

    WS(ws);


    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    if (!self.model.container_code) {

        if ([self.tfCode.text isEqualToString:@""]) {

            [[Toast shareToast]makeText:@"装箱码不能为空" aDuration:1];

        }else{

            NSString *searchText = self.tfCode.text;
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9]{11}$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (result) {

                if ([self.stCode isEqualToString:self.model.parentCode]) {
                    [vm finishShipmentWithType:0 WithQrcode:self.stCode WithBillid:self.model.waybill_id WithContainercode:searchText callback:^(NSString *message) {
                        if (message) {
                            [[Toast shareToast]makeText:@"装载成功" aDuration:1];
                             [ws.navigationController popViewControllerAnimated:YES];
                        }

                    }];
                }else {
                    [[Toast shareToast]makeText:@"二维码无效" aDuration:1];
                }

            }else{
                [[Toast shareToast]makeText:@"装箱码必须为11位的数字或字母" aDuration:1];

            }



        }
    }else{


        [vm finishShipmentWithType:1 WithQrcode:self.stCode WithBillid:self.model.waybill_id WithContainercode:self.model.container_code callback:^(NSString *message) {
            if (message) {
                [[Toast shareToast]makeText:@"抵达成功" aDuration:1];
                [ws.navigationController popViewControllerAnimated:YES];
            }
            
        }];
        
    }
}



#pragma mark --代理方法
/**
 *  给地图增加标注
 *
 *  @param location 位置坐标
 *  @param image    标注图片名称
 */
- (void)addMarkOnMap:(CLLocationCoordinate2D )location withimageNamed:(NSString *)image {

    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = location;
    pointAnnotation.title = image;
    [_mapView addAnnotation:pointAnnotation];
}
/**
 *  代理方法   实时获取位置坐标
 *
 *  @param mapView
 *  @param userLocation
 *  @param updatingLocation
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    
    if(updatingLocation)
    {
        self.ownLocation = userLocation.coordinate;
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//        _mapView.centerCoordinate = userLocation.coordinate;
    }
}

/**
 *  代理方法  设置标注样式
 *
 *  @param mapView
 *  @param annotation
 *
 *  @return
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:annotation.title];
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y, annotationView.frame.size.width / 2, annotationView.frame.size.height / 2);
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -8);
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAGeodesicPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 3.f;
        polylineRenderer.strokeColor  = APP_COLOR_BLUE;
        return polylineRenderer;
    }
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    return nil;
}


- (void)phoneAction:(UIButton *)btn {

    if (btn.tag == 0) {


            self.stTelephone = self.model.start_contacts_phone;

            [self showAlertViewWithTitle:[NSString stringWithFormat:@"打电话给%@?",self.model.start_contacts] WithMessage:[NSString stringWithFormat:@"电话:%@",self.model.start_contacts_phone]];



    }else {


            self.stTelephone = self.model.end_contacts_phone;

            [self showAlertViewWithTitle:[NSString stringWithFormat:@"打电话给%@?",self.model.end_contacts] WithMessage:[NSString stringWithFormat:@"电话:%@",self.model.end_contacts_phone]];

    }
    
    
}
/**
 *  代理方法  上传故障报警信息
 *
 *  @param actionSheet
 *  @param buttonIndex
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"取消"]) {
        return ;
    }
    UserInfoModel * user = USER_INFO;
    WS(ws);


    [[[PeripheralServicesViewModel alloc]init]submitFailureWithBillid:self.model.waybill_id WithReportcontent:[NSString stringWithFormat:@"%i",(int)buttonIndex ] WithDriverid:user.driverId WithType:1 WithWaybillCarrierId:self.model.waybill_carrier_id  callback:^{

        [ws.navigationController popViewControllerAnimated:YES];
     
    }];
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


    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


        return 60;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    static NSString *CellIdentifier = @"Celled";

        MapCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MapCityTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        }

    if (indexPath.row == 0) {
        cell.lbAddress.text = self.model.start_address;
//        cell.lbAddress.numberOfLines = 2;

        cell.lbName.text = self.model.start_contacts;
        cell.btnPhone.tag = 0;
        [cell.btnPhone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        cell.lbAddress.text = self.model.end_address;
//        cell.lbAddress.numberOfLines = 2;
        cell.ivPoint.image = [UIImage imageNamed:@"endPoint"];
        cell.ivPhone.image = [UIImage imageNamed:@"endphone"];
        cell.lbName.text = self.model.end_contacts;
        cell.btnPhone.tag = 1;
        [cell.btnPhone addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];

    }
        return cell;
   }


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self upAndDownAction];
}



#pragma mark -----属性懒加载部分

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES; 
    }
    return _mapView;
}

- (UIView *)findDetailsView {
    if (!_findDetailsView) {
        _findDetailsView = [UIView new];
        _findDetailsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

        UITapGestureRecognizer * gesture = [UITapGestureRecognizer new];
        [gesture addTarget:self action:@selector(gestureAction1)];
        [_findDetailsView addGestureRecognizer:gesture];
    }
    return _findDetailsView;
}

- (UIView *)fDViewBg1 {
    if (!_fDViewBg1) {
        _fDViewBg1 = [UIView new];
        _fDViewBg1.backgroundColor = [UIColor whiteColor];
    }
    return _fDViewBg1;
}

- (UIView *)fDViewTitle {
    if (!_fDViewTitle) {
        _fDViewTitle = [UIView new];

        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_W - 60) / 2, 0, 60, 40)];
        label.text = @"发现";
        label.textAlignment = NSTextAlignmentCenter;
        [_fDViewTitle addSubview:label];

        UIView * v1 = [[UIView alloc]initWithFrame:CGRectMake(0, label.frame.size.height / 2, (SCREEN_W - label.frame.size.width) / 2, 1)];
        v1.backgroundColor = [UIColor grayColor];
        [_fDViewTitle addSubview:v1];

        UIView * v2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), label.frame.size.height / 2, (SCREEN_W - label.frame.size.width) / 2, 1)];
        v2.backgroundColor = [UIColor grayColor];
        [_fDViewTitle addSubview:v2];
    }
    return _fDViewTitle;
}

- (UIView *)fDViewBtnView {
    if (!_fDViewBtnView) {
        _fDViewBtnView = [UIView new];

        NSArray * namearr = @[@"加油",@"加气",@"维修",@"餐饮"];
        UIButton * button;
        UILabel * nameLabel;
        UIImageView * image;
        float len = SCREEN_W / 4;
        float imageL = 60;
        float labelL = 40;
        for (int i = 0 ; i < 4; i ++)
        {
            button = [[UIButton alloc]initWithFrame:CGRectMake(i * len, 0, len, imageL + labelL)];
            button.tag = i + fDVIEWBTNKEY;
            [_fDViewBtnView addSubview:button];

            image = [[UIImageView alloc]initWithFrame:CGRectMake(len/2 - imageL / 2, 0, imageL, imageL)];
            image.image = [UIImage imageNamed:namearr[i]];
            [button addSubview:image];

            nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame),len , labelL)];
            nameLabel.text = namearr[i];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [button addSubview:nameLabel];
        }

        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 99, SCREEN_W, 1)];
        view.backgroundColor = [UIColor grayColor];
        [_fDViewBtnView addSubview:view];
    }
    return _fDViewBtnView;
}

- (UIView *)fDViewWebView {
    if (!_fDViewWebView) {
        _fDViewWebView = [UIView new];
    }
    return _fDViewWebView;
}

- (UIView *)leftButsView {
    if (!_leftButsView) {
        _leftButsView = [UIView new];

        UIButton * button;
        UIImageView * image;
        UILabel * label;
        for(int i = 0;i< 3; i++)
        {
            button = [[UIButton alloc]initWithFrame:CGRectMake(25, (SCREEN_H - 64) / 2 - 110 + 80 * i, 50, 60)];
              [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
            button.tag = LEFTBTNKEY + i;
            [_leftButsView addSubview:button];

            image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
            image.contentMode = UIViewContentModeScaleAspectFit;
            image.tag = 1;
            [button addSubview:image];

            label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 50, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor whiteColor];
            label.tag = 2;
            [button addSubview:label];

            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        }
    }
    return _leftButsView;
}

- (UIView *)viBackGround {
    if (!_viBackGround) {
        _viBackGround = [UIView new];
        _viBackGround.backgroundColor = [UIColor blackColor];
        _viBackGround.alpha = 0.7;
    }
    return _viBackGround;
}

- (UIButton *)btnBreakdown {
    if (!_btnBreakdown) {
        UIButton *button = [[UIButton alloc]init];
          [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];


        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20, 20)];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.image = [UIImage imageNamed:@"故障"];
        [button addSubview:iv];


        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 50, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor whiteColor];
        label.text = @"故障报警";
        [button addSubview:label];

        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        button.hidden = YES;
        if (self.model.status == 4) {
            button.hidden = NO;
        }

        if (self.model.carrierStatus == 1) {
            label.text = @"解除报警";
        }

        _lbWaring = label;
        _btnBreakdown = button;
    }
    return _btnBreakdown;
}

- (UIView *)viHead {
    if (!_viHead) {
        _viHead = [UIView new];
        _viHead.backgroundColor = [UIColor whiteColor];
    }
    return _viHead;
}

- (UILabel *)lbDays {
    if (!_lbDays) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.layer.borderWidth = 1;
        label.layer.borderColor = APP_COLOR_ORANGR2.CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        double daytime = ([self.model.endTime doubleValue] - [self.model.startTime doubleValue])/1000/60/60/24;
        if (daytime > (int)daytime) {
            daytime ++;
        }
        label.text = [NSString stringWithFormat:@"%i天送达",(int)daytime];


        _lbDays = label;
    }
    return _lbDays;
}

- (UILabel *)lbTask {
    if (!_lbTask) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR2;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.layer.borderWidth = 1;
        label.layer.borderColor = APP_COLOR_ORANGR2.CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        switch (self.model.type) {
            case 1:
                 label.text = @"派单";//系统
                break;
            case 2:
                label.text = @"抢单";
                break;
            case 3:
                label.text = @"派单";//外采
                break;

            default:
                break;
        }


        _lbTask = label;
    }
    return _lbTask;
}

- (UILabel *)lbState {
    if (!_lbState) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR2;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"待装载";
         if (self.model.status == 4) {
             label.text = @"在途";
         }
        if (self.model.status == 5) {
            label.text = @"完成";
        }

        _lbState = label;
    }
    return _lbState;
}

- (UILabel *)lbLine {
    if (!_lbLine) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor grayColor];

        _lbLine = label;
    }
    return _lbLine;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.viHead.bottom -120, SCREEN_W, 155) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        UIView *footView = [UIView new];
        footView.backgroundColor = [UIColor clearColor];
        footView.frame = CGRectMake(0, 0, 90, 30);
        tableView.tableFooterView = footView;
        self.btnUpAndDown.frame =CGRectMake(SCREEN_W/2 - 45, 0, 90, 30);
        [footView addSubview:self.btnUpAndDown];

        tableView.alwaysBounceHorizontal = NO;


        _tvList = tableView;
    }
    return _tvList;
}

- (UIButton *)btnUpAndDown {
    if (!_btnUpAndDown) {
        UIButton *button = [[UIButton alloc]init];
        [button setBackgroundImage:[UIImage imageNamed:@"down.jpg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"up.jpg"] forState:UIControlStateSelected];


        _btnUpAndDown = button;
    }
    return _btnUpAndDown;
}


@end
