//
//  ResetPasswordViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ZCInputTableViewCell.h"
#import "UserInfoViewModel.h"
#import "NSString+Password.h"
#import "UserInfoModel.h"
#import <SMS_SDK/SMSSDK.h>
#import "UITextField+LCWordLimit.h"

@interface ResetPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,getCodeDelegate>
#pragma mark - 属性生命部分
@property (nonatomic, strong) UITableView    * inputTableview;//输入列表
@property (nonatomic, strong) UIButton       * submitBtn;//提交按钮
@property (nonatomic, strong) NSMutableArray * dataArray;//输入列表内容
@property (nonatomic, strong) NSArray        *arrImg;
@property (nonatomic, strong) NSString *phone;


@property (weak, nonatomic) IBOutlet UITextField *telField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;

@end

@implementation ResetPasswordViewController

#pragma mark - 初始化部分
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - textField
- (void)textFieldValueChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    //输入过滤空格及不符合条件的字符
    if (textField.markedTextRange != nil) {
        return;
    }
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    [self.telField lc_wordLimit:11];
    [self.passwordField lc_wordLimit:20];
    [self.codeField lc_wordLimit:4];
    self.btnRight.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)bindView
{
    UserInfoModel * info = USER_INFO;
    if ([self.statue isEqualToString:@"Person"]) {
        self.telField.text = info.phone;
    }
}
-(void)bindModel
{
    [self.dataArray addObject:@[@"手机号",@"请输入您的手机号"]];
    [self.dataArray addObject:@[@"验证码",@"请输入验证码"]];
    [self.dataArray addObject:@[@"密码",@"组合字母、数字或符号"]];
    [self.dataArray addObject:@[@"确认密码",@"组合字母、数字或符号"]];
    [self.inputTableview reloadData];

    self.arrImg = @[@"password1",@"password2",@"password3",@"password",@"password"];

}
-(void)bindAction
{
    WS(ws);
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws submitBtnClick];
    }];
    
}

#pragma mark - 属性懒加载部分
- (UITableView *)inputTableview
{
    if (!_inputTableview) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[ZCInputTableViewCell class] forCellReuseIdentifier:@"inputTableviewCell"];
        tableView.scrollEnabled = NO;
        _inputTableview = tableView;
    }
    return _inputTableview;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _submitBtn = button;
    }
    return _submitBtn;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        
    }
    return _dataArray;
}

#pragma mark - 点击事件部分
-(void)submitBtnClick
{
    UserInfoViewModel *vm = [[UserInfoViewModel alloc]init];
    NSIndexPath *indexPath;
    ZCInputTableViewCell * cell;
    NSString * phoneNumber;
    NSString * verifycode;
    NSString * idnumber;
    NSString * newPassWord1;
    NSString * newPassWord2;
    for (int i = 0; i < 5; i ++)
    {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];;
        cell = [self.inputTableview cellForRowAtIndexPath:indexPath];
        if ([cell.inputTextField.text isEqualToString:@""] && i != 2)
        {
            [[Toast shareToast]makeText:@"请输入完整信息" aDuration:1];
            return ;
        }
        switch (i+1) {
            case 1:
                phoneNumber = cell.inputTextField.text;
                break;
            case 2:
                verifycode = cell.inputTextField.text;
                break;
            case 3:
                newPassWord1 = cell.inputTextField.text;
                break;
            case 4:
                newPassWord2 = cell.inputTextField.text;
                break;
            default:
                break;
        }
        
    }
//    if ([phoneNumber integerValue] <= 10000000000) {
//        [[Toast shareToast]makeText:@"手机号码错误" aDuration:1];
//        return ;
//    }
    if (![newPassWord1 isEqualToString:newPassWord2]) {
        [[Toast shareToast]makeText:@"密码不一致" aDuration:1];
        return ;
    }
    else if(newPassWord1.length < 6)
    {
        [[Toast shareToast]makeText:@"密码至少6位" aDuration:1];
        return ;
    }
//    else if ([newPassWord1 theComplexity] < 2)
//    {
//        [[Toast shareToast]makeText:@"密码应为字母、数字或符号的组合" aDuration:1];
//        return ;
//    }

    WS(ws);
    self.phone = phoneNumber;
    [vm resetPasswordWithPhone:phoneNumber WithNewPassWord:newPassWord1 WithVerifycode:verifycode WithIdnumber:idnumber callback:^(NSString *status) {

        UserInfoModel *us = nil;
        [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];

        [ws.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#pragma mark - tableView代理

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     ZCInputTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"inputTableviewCell" forIndexPath:indexPath];
    cell.getCodeInfo = self;
    //cell.titleLabel.text = self.dataArray[indexPath.row][0];
    UIImage *img =  [UIImage imageNamed:[self.arrImg objectAtIndex:indexPath.row]];
    cell.ivLogo.image = img;
//    CGSize itemSize = CGSizeMake(30, 30);
//
//    UIGraphicsBeginImageContext(itemSize);
//
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//
//    [cell.imageView.image drawInRect:imageRect];
//
//    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    cell.inputTextField.placeholder = self.dataArray[indexPath.row][1];
    cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
    NSRange range1 = [(NSString*)(self.dataArray[indexPath.row][0]) rangeOfString:@"密码"];
    if (range1.location ==NSNotFound)
    {
        cell.eyeBut.hidden = YES;
    }
    else
    {
        cell.eyeBut.hidden = NO;
        cell.inputTextField.secureTextEntry = YES;
        cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    NSRange range2 = [(NSString*)(self.dataArray[indexPath.row][0]) rangeOfString:@"验证码"];
    if (range2.location ==NSNotFound)
    {
        cell.validationBut.hidden = YES;
    }
    else
    {
        cell.textFieldMaxLength = 6;
        cell.validationBut.hidden = NO;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    NSRange range3 = [(NSString*)(self.dataArray[indexPath.row][0]) rangeOfString:@"手机号"];
    if (range3.location ==NSNotFound)
    {
    }
    else
    {
        cell.textFieldMaxLength = 11;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if (self.type == 1 && indexPath.row == 0) {
        UserInfoModel *info= USER_INFO;
        cell.inputTextField.text = info.phone;
        cell.inputTextField.enabled = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64 * SCREEN_H_COEFFICIENT;
}


-(void)getCodeAction {

    NSIndexPath *indexPath;
    ZCInputTableViewCell * cell;
    NSString * phoneNumber = @"";
    NSString * verifycode;

    NSString * newPassWord1;
    NSString * newPassWord2;
    for (int i = 0; i < 5; i ++)
    {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];;
        cell = [self.inputTableview cellForRowAtIndexPath:indexPath];

        switch (i+1) {
            case 1:
                phoneNumber = cell.inputTextField.text;
                break;
            case 2:
                verifycode = cell.inputTextField.text;
                break;
            case 3:
                newPassWord1 = cell.inputTextField.text;
                break;
            case 4:
                newPassWord2 = cell.inputTextField.text;
                break;
            default:
                break;
        }

    }


    if (![self checkPhoneWithPhone:phoneNumber]) {
        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];

    }else{
        
        UserInfoViewModel *vm = [UserInfoViewModel new];
        [vm getRCodeWithPhone:phoneNumber callback:^(NSString *st) {

        }];

    }


    
}

- (void)checkTelValid{
    if (![self checkPhoneWithPhone:self.telField.text]) {
        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];
        return;
    }
    UserInfoViewModel *vm = [UserInfoViewModel new];
    [vm getRCodeWithPhone:self.telField.text callback:^(NSString *st) {
        [self getNumBtnAction];
    }];
}
- (void)getNumBtnAction{
    
    __block NSInteger second = 60;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                self.codeBtn.enabled = NO;
                [self.codeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                self.codeBtn.titleLabel.text =[NSString stringWithFormat:@"%lds",(long)second];
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)second] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                self.codeBtn.enabled =YES;
                [self.codeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
    
}
- (void)checkSubValid
{
    if(self.telField.text.length !=11)
    {
        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];
        return ;
    }
    if(self.passwordField.text.length < 6)
    {
        [[Toast shareToast]makeText:@"密码至少6位" aDuration:1];
        return ;
    }
    if(self.codeField.text.length <1)
    {
        [[Toast shareToast]makeText:@"请输入验证码" aDuration:1];
        return ;
    }
    [self asyncForgetRequest];
}

- (void)asyncForgetRequest
{
    WS(ws);
    UserInfoViewModel *vm = [UserInfoViewModel new];
    [vm resetPasswordWithPhone:self.telField.text WithNewPassWord:self.passwordField.text WithVerifycode:self.codeField.text WithIdnumber:@"" callback:^(NSString *status) {
        
        UserInfoModel *us = nil;
        [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
        
        [ws.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)pressCodeBtn:(id)sender {
    [self checkTelValid];
    
}
- (IBAction)pressSubBtn:(id)sender {
    [self checkSubValid];
}

@end
