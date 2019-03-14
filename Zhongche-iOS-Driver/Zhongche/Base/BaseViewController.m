//
//  AppDelegate.h
//  Zhongche
//
//  Created by lxy on 16/7/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

#include "ZCCarManagerViewController.h"
#include "ZCTransportationRecordViewController.h"
#include "ZCHistoryOrderViewController.h"
#include "ZCWalletViewController.h"
#include "PersonViewController.h"
#include "ZCRecommendViewController.h"
#include "ZCMyOrderViewController.h"
#include "WaitForCheckViewController.h"
#include "FirstPageViewController.h"
#import "PrivacyProvisionViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface BaseViewController()<UIAlertViewDelegate,UIGestureRecognizerDelegate, UIAlertViewDelegate,HomeMenuViewDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *clickMAXView;

@end


@implementation BaseViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SYSTEM_VIEW_LOADDATA object:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self leftViewSet];
    [self.view addGestureRecognizer:self.clickMAXView];
    [self.clickMAXView addTarget:self action:@selector(hideTheKeyboard)];
    [self navigationSet];
    [self bindModel];
    [self bindView];
    [self bindAction];
    
}

/**
 *  导航按钮设置
 */
- (void)navigationSet{
    
    self.btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setFrame:CGRectMake(0, 0, 24, 25)];
    [_btnRight addTarget:self action:@selector(onRightAction) forControlEvents:UIControlEventTouchUpInside];

    _btnRight.titleLabel.textAlignment = NSTextAlignmentRight;
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_btnRight];
    [self.btnRight setImage:[UIImage imageNamed:@"phoneTop-1"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.btnRight.hidden = YES;
    
    self.btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLeft setFrame:CGRectMake(0, 0, 50, 20)];
    [_btnLeft addTarget:self action:@selector(onBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitle:@"————" forState:UIControlStateNormal];
    [_btnLeft setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageNamed:@"zuojiantou_x"] forState:UIControlStateNormal];
    _btnLeft.highlighted = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:_btnLeft];
    self.navigationItem.leftBarButtonItem = backItem;

}

/**
 *  侧滑栏设置
 *
 */
- (void)leftViewSet {




    if ( [self isKindOfClass:[ZCMyOrderViewController class]] ||  [self isKindOfClass:[WaitForCheckViewController class]] ||  [self isKindOfClass:[FirstPageViewController class]]) {

        self.demo = [[LeftMenuViewDemo alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width * 0.8, [[UIScreen mainScreen] bounds].size.height)];
        self.demo.customDelegate = self;

        MenuView *menu = [MenuView MenuViewWithDependencyView:self.view MenuView:self.demo isShowCoverView:YES];
        self.menu = menu;



    }

    

    
}

/**         
 *  加载视图
 */
- (void)bindView {
}

/**
 *  加载模型
 */
- (void)bindModel {
}

/**
 *  加载方法
 */
- (void)bindAction {
}


/**
 *  导航控制器上角按钮方法
 */
- (void)onBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightAction {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.stTelephone = APP_CUSTOMER_SERVICE;
    
    [alert show];
}

//打电话
- (void)callAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要拨打客服电话联系客服？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.stTelephone = APP_CUSTOMER_SERVICE;

    [alert show];
}


//*****************************************************************
// MARK: - actions
//*****************************************************************
/**
 *  点击空白取消键盘
 */

- (void)hideTheKeyboard {
    [self.view endEditing:YES];
}

//词典转换为字符串

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

//时间戳转时间格式字符串
- (NSString *)stDateToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [outputFormatter stringFromDate:date];
}

//时间戳转时间格式字符串
- (NSString *)stDateToString1:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [outputFormatter stringFromDate:date];

}

//时间戳转时间格式字符串
- (NSString *)stDateToString2:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy年MM月dd HH:mm"];
    return [outputFormatter stringFromDate:date];

}

//时间戳转时间格式字符串
- (NSString *)stDateAndTimToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [outputFormatter stringFromDate:date];

}

//检查手机号
- (BOOL)checkPhoneWithPhone:(NSString *)Phone {

    NSString *searchText = Phone;

    NSError *error = NULL;

    NSRegularExpression *regex18 = [NSRegularExpression regularExpressionWithPattern:@"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$" options:NSRegularExpressionCaseInsensitive error:&error];

    NSTextCheckingResult *result18 = [regex18 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result18) {

        return YES;
    }


    return NO;
}

- (void) showAlertViewWithTitle:(NSString *)title WithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

//计算两个坐标距离
- (float)distanceWithStartlat:(float)startlat WithStartlng:(float)startlng WithEndlat:(float)endlat WithEndlng:(float)endlng{

    CLLocation *orig=[[CLLocation alloc] initWithLatitude:startlat  longitude:startlng];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:endlat longitude:endlng];
    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
    return kilometers;
}


//*****************************************************************
// MARK: - delegates
//*****************************************************************

/**
 *  alertView代理
 *
 *  @param alertView   delegate
 */


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        UIWebView * callWebview = [[UIWebView alloc]init];
        
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.stTelephone]]]];
        
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

    }
}

/**
 *  视图代理
 *
 */
-(void)LeftMenuViewClick:(NSInteger)tag{
   [self.menu hidenWithAnimation];


    UserInfoModel *userInfo = USER_INFO;
    NSLog(@"%@",self.menu);
    BaseViewController * vc;
    switch (tag) {
        case 0:
            if (userInfo.identStatus == 0 || userInfo.quaStatus == 0) {

                [[Toast shareToast]makeText:@"请先完善资料" aDuration:1];
                
            }else {

                vc = [[ZCWalletViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];

            }


            break;
        case 1:
            vc = [[ZCCarManagerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;

        case 2:
            vc = [[ZCTransportationRecordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;

        case 3:
            vc = [[ZCHistoryOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;

            //ZCTransportationRecordViewController.h
            break;
        case 4:
            [self callAction];
            break;

        case 5:

            vc = [[PrivacyProvisionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];


            break;

        default:
            break;

    }
}

-(void)HeadClick {

    [self.menu hidenWithAnimation];
    PersonViewController *vc = [PersonViewController new];

    [self.navigationController pushViewController:vc animated:YES];


//    [self.menu hidenWithAnimation];
//    //1. 创建联系人选择导航控制器
//
//    ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
//
//
//
//    //2. 设置代理 注意不要设置错了
//
//    picker.peoplePickerDelegate = self;
//
//
//
//    //3. 以模态视图弹出
//
//    [self presentViewController:picker animated:YES completion:nil];

}

#pragma mark 实现代理方法

/// 当选择了联系人的时候调用此方法

///

/// @param person       选中的联系人

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {

    //获取联系人姓名

    //NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));

    // NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));

    //self.nameLabel.text = [lastName stringByAppendingString:firstName];



    NSString *fullName = CFBridgingRelease(ABRecordCopyCompositeName(person));

    //self.nameLabel.text = fullName;



    //获取联系人电话

    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);



    //遍历phones, 拿到每一个电话

    CFIndex count = ABMultiValueGetCount(phones);



    for (int i = 0; i < count; i++) {

        // 电话label

        NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));

        //  电话

        NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));



        NSLog(@"label:%@, value: %@",label, value);

    }
    
    
    
    //释放CF对象.如果没有纪录电话，phone是nil，不能释放。
    
    if (phones != nil) {
        
        CFRelease(phones);
        
    }
    
    
    
}


- (void)ShareClick {


    [self.menu hidenWithAnimation];
    ZCRecommendViewController *vc = [ZCRecommendViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  手势代理
 *
 */

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}



//*****************************************************************
// MARK: - getter
//*****************************************************************

- (UITapGestureRecognizer *)clickMAXView {
    if (!_clickMAXView) {
        _clickMAXView = [UITapGestureRecognizer new];
        _clickMAXView.delegate = self;
    }
    return _clickMAXView;
}
@end
