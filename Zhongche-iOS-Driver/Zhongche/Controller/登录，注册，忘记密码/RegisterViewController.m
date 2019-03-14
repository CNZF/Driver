//
//  RegisterViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/13.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZCInputTableViewCell.h"
#import "UserInfoViewModel.h"
#import "ZCCityListViewController.h"
#import "NSString+Password.h"
#import <SMS_SDK/SMSSDK.h>
#import "DynamicDetailsViewController.h"
#import "UIButton+Dispath_Source_Timer.h"
#import "UITextField+LCWordLimit.h"

@interface RegisterViewController ()<UITextFieldDelegate>
#pragma mark - 属性声明部分
@property (nonatomic, strong) UITableView    * inputTableview;//输入列表
@property (nonatomic, strong) UIButton       * submitBtn;//提交按钮
@property (nonatomic, strong) NSMutableArray * dataArray;//输入列表内容
@property (nonatomic, strong) UIButton       * isAgreedButton;//是否同意协议与条款按钮
@property (nonatomic, strong) UILabel        * textLab;//是否同意协议介绍文本
@property (nonatomic, strong) UIButton       * concealBtn;//服务条款与隐私政策
@property (nonatomic, strong) CityModel      * city;//选取城市信息
@property (nonatomic, strong) NSArray        *arrImg;//图片数组


@property (weak, nonatomic) IBOutlet UITextField *stationField;

@property (weak, nonatomic) IBOutlet UITextField *texField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;

@end

@implementation RegisterViewController

#pragma mark - 初始化部分
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.btnRight.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.texField lc_wordLimit:11];
    [self.passwordField lc_wordLimit:20];
    [self.codeField lc_wordLimit:4];
    [self addserverLabelTapGesture];
    self.stationField.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)addserverLabelTapGesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onStationTapClicked:)];
    [self.serverLabel addGestureRecognizer:tap];
}

#pragma marl --StationField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    ZCCityListViewController * controller = [[ZCCityListViewController alloc]init];
    controller.type = @"user";
    controller.title = @"选择基地";
    [controller setBlock:^(CityModel *model) {
        self.stationField.text = model.startPosition;
    }];
    [self.navigationController pushViewController:controller animated:YES] ;
    return NO;
}

- (void)textFieldValueChanged:(NSNotification *)notification {
    //输入过滤空格及不符合条件的字符
    if (self.texField.markedTextRange != nil) {
        return;
    }
    if ([self.texField.text containsString:@" "]) {
        self.texField.text = [self.texField.text substringToIndex:self.texField.text.length-1];
    }
}


#pragma mark --校验手机号
- (void)checkTelPhoneNumberValid
{
    
    if (![self checkPhoneWithPhone:self.texField.text]) {
        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];
        return;
    }
    UserInfoViewModel *vm = [UserInfoViewModel new];
    [vm getRCodeWithPhone:self.texField.text callback:^(NSString *st) {
        [UIButton getNumBtnAction:self.codeBtn];
    }];
    
}


- (void)checkFieldValid
{
    if (self.stationField.text.length == 0) {
        [[Toast shareToast]makeText:@"基地没有选择" aDuration:1];
        return;
    }
    if (self.texField.text.length == 0) {
        [[Toast shareToast]makeText:@"手机号码错误" aDuration:1];
        return;
    }
    if (self.codeField.text.length == 0) {
        [[Toast shareToast]makeText:@"验证码错误" aDuration:1];
        return;
    }
    if (self.passwordField.text.length < 6) {
        [[Toast shareToast]makeText:@"密码至少6位" aDuration:1];
        return;
    }
    [self asyncRegistRequest];
}

- (void)asyncRegistRequest{
    WS(ws);
    UserInfoViewModel *vm = [[UserInfoViewModel alloc]init];
    [vm registerWithPhone:self.texField.text WithPassWord:self.passwordField.text WithVerifycode:self.codeField.text WithUserbase:self.stationField.text callback:^(NSString *status) {
        [ws.navigationController popViewControllerAnimated:YES];
        [[Toast shareToast]makeText:@"注册成功" aDuration:1];
    }];
}

#pragma mark- pressAction

- (void)onStationTapClicked:(UITapGestureRecognizer *)tap
{
    DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
    vc.title = @"隐私服务";
    vc.urlStr = AboutUsUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

//验证码
- (IBAction)pressCodeBtn:(id)sender {
    [self checkTelPhoneNumberValid];
}
//眼睛
- (IBAction)pressEyeBtn:(id)sender {
    self.eyeBtn.selected = !self.eyeBtn.selected;
    self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;

    [self.passwordField becomeFirstResponder];
}
//同意
- (IBAction)pressAgreeBtn:(id)sender {
    self.agreeBtn.selected = !self.agreeBtn.selected;
    self.subBtn.enabled = self.agreeBtn.selected;
    if (self.agreeBtn.selected) {
        self.subBtn.alpha  = 1.0;
    }else{
        self.subBtn.alpha = 0.4;
    }
}
//提交
- (IBAction)pressSubBtn:(id)sender {
    [self checkFieldValid];
}



@end
