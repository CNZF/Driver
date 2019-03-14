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

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,ZCCityListViewControllerDelagate,getCodeDelegate,UITextFieldDelegate>
#pragma mark - 属性声明部分
@property (nonatomic, strong) UITableView    * inputTableview;//输入列表
@property (nonatomic, strong) UIButton       * submitBtn;//提交按钮
@property (nonatomic, strong) NSMutableArray * dataArray;//输入列表内容
@property (nonatomic, strong) UIButton       * isAgreedButton;//是否同意协议与条款按钮
@property (nonatomic, strong) UILabel        * textLab;//是否同意协议介绍文本
@property (nonatomic, strong) UIButton       * concealBtn;//服务条款与隐私政策
@property (nonatomic, strong) CityModel      * city;//选取城市信息
@property (nonatomic, strong) NSArray        *arrImg;//图片数组
@end

@implementation RegisterViewController

#pragma mark - 初始化部分
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.btnRight.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)bindView {




    self.inputTableview.frame = CGRectMake(0*SCREEN_W_COEFFICIENT,20*SCREEN_H_COEFFICIENT, SCREEN_W,5 * 64 * SCREEN_H_COEFFICIENT);
    self.inputTableview.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.inputTableview];
    
    self.isAgreedButton.frame = CGRectMake(20*SCREEN_W_COEFFICIENT,CGRectGetMaxY(self.inputTableview.frame) + 40*SCREEN_H_COEFFICIENT, 20*SCREEN_W_COEFFICIENT, 20*SCREEN_H_COEFFICIENT);
    [self.view addSubview:self.isAgreedButton];
    
    self.textLab.frame = CGRectMake(CGRectGetMaxX(self.isAgreedButton.frame) + 25 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.isAgreedButton.frame) - 13 * SCREEN_H_COEFFICIENT, SCREEN_W - 10 * SCREEN_W_COEFFICIENT  - CGRectGetMaxX(self.isAgreedButton.frame) -  5 * SCREEN_W_COEFFICIENT, 46*SCREEN_H_COEFFICIENT);
    [self.view addSubview:self.textLab];

    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(pushWebAction) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(CGRectGetMaxX(self.isAgreedButton.frame) + 25 * SCREEN_W_COEFFICIENT, CGRectGetMinY(self.isAgreedButton.frame) - 13 * SCREEN_H_COEFFICIENT, SCREEN_W - 10 * SCREEN_W_COEFFICIENT  - CGRectGetMaxX(self.isAgreedButton.frame) -  5 * SCREEN_W_COEFFICIENT, 46*SCREEN_H_COEFFICIENT);
    [self.view addSubview:btn];
    
    self.concealBtn.frame = CGRectMake((SCREEN_W - 260 *SCREEN_W_COEFFICIENT)/2, CGRectGetMaxY(self.textLab.frame) + 10 * SCREEN_H_COEFFICIENT, 260 *SCREEN_W_COEFFICIENT, 15* SCREEN_H_COEFFICIENT);
    [self.view addSubview:self.concealBtn];
    
    
    self.submitBtn.frame = CGRectMake(50*SCREEN_W_COEFFICIENT, CGRectGetMaxY(self.concealBtn.frame)+ 20*SCREEN_H_COEFFICIENT, SCREEN_W - 100*SCREEN_W_COEFFICIENT, 60*SCREEN_H_COEFFICIENT);
    [self.view addSubview:self.submitBtn];
}

-(void)bindModel {
    [self.dataArray addObject:@[@"基地",@"请选择基地"]];
    [self.dataArray addObject:@[@"手机号",@"请输入您的手机号"]];
    [self.dataArray addObject:@[@"验证码",@"请输入验证码"]];
    [self.dataArray addObject:@[@"密码",@"组合字母、数字或符号"]];
    [self.dataArray addObject:@[@"确认密码",@"组合字母、数字或符号"]];
    [self.inputTableview reloadData];
    
    self.textLab.text = @"我接受该公司的服务条款与认可隐私政策";
//    NSMutableAttributedString * authorStrLabelstr = [[NSMutableAttributedString alloc] initWithString:@"查看服务条款和隐私政策"];
//    [authorStrLabelstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16 * SCREEN_H_COEFFICIENT] range:NSMakeRange(0,11)];
//    [authorStrLabelstr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,2)];
//    [authorStrLabelstr addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLUE range:NSMakeRange(2,4)];
//    [authorStrLabelstr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(6,1)];
//    [authorStrLabelstr addAttribute:NSForegroundColorAttributeName value:APP_COLOR_BLUE range:NSMakeRange(7,4)];
//    [self.concealBtn setAttributedTitle:authorStrLabelstr forState:UIControlStateNormal];

     self.arrImg = @[@"register1",@"register2",@"register3",@"password",@"password"];
    
}

-(void)bindAction {
    WS(ws);
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws submitBtnClick];
    }];
    [[self.isAgreedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws isAgreedButtonClick];
    }];
    
}

#pragma mark - 按钮点击事件

//条款
-(void)pushWebAction {

    DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
    vc.title = @"条款与隐私";
    vc.urlStr = [NSString stringWithFormat:@"%@/apprest/serviceitem.jsp",BASEURL];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)isAgreedButtonClick {
    self.isAgreedButton.selected = !self.isAgreedButton.selected;
    self.submitBtn.userInteractionEnabled = !self.submitBtn.userInteractionEnabled;
    if(self.isAgreedButton.selected)
    {
        
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitBtn.backgroundColor =  APP_COLOR_BLUE;
    }
    else
    {
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitBtn.backgroundColor = [UIColor whiteColor];
    }
}

-(void)submitBtnClick {
    UserInfoViewModel *vm = [[UserInfoViewModel alloc]init];
    NSIndexPath *indexPath;
    ZCInputTableViewCell * cell;
    NSString * phoneNumber;
    NSString * verifycode;
    NSString * userbase;
    NSString * PassWord1;
    NSString * PassWord2;
    for (int i = 0; i < 5; i ++)
    {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];;
        cell = [self.inputTableview cellForRowAtIndexPath:indexPath];
//        if ([cell.inputTextField.text isEqualToString:@""]) {
//            [[Toast shareToast]makeText:@"请输入完整信息" aDuration:1];
//            return ;
//        }
        switch (i+1) {
            case 1:
                userbase = self.city.startPositionCode;
                break;
            case 2:
                phoneNumber = cell.inputTextField.text;
                break;
            case 3:
                verifycode = cell.inputTextField.text;
                break;
            case 4:
                PassWord1 = cell.inputTextField.text;
                break;
            case 5:
                PassWord2 = cell.inputTextField.text;
                break;
            default:
                break;
        }
    }

    //1\\d{10}$
    NSString *searchText = phoneNumber;
    NSError *error = NULL;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"1\\d{10}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];



    if (!result) {

        [[Toast shareToast]makeText:@"手机号码错误" aDuration:1];
        return ;
    }
    if (![PassWord1 isEqualToString:PassWord2]) {
        [[Toast shareToast]makeText:@"密码不一致" aDuration:1];
        return ;
    }
    else if(PassWord1.length < 6)
    {
        [[Toast shareToast]makeText:@"密码至少6位" aDuration:1];
        return ;
    }
    else if (!userbase)
    {
        [[Toast shareToast]makeText:@"基地没有选择" aDuration:1];
        return ;
    }
    WS(ws);
    [vm registerWithPhone:phoneNumber WithPassWord:PassWord1 WithVerifycode:verifycode WithUserbase:userbase callback:^(NSString *status) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCInputTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"inputTableviewCell" forIndexPath:indexPath];
    cell.getCodeInfo = self;
    //cell.titleLabel.text = self.dataArray[indexPath.row][0];
    cell.inputTextField.placeholder = self.dataArray[indexPath.row][1];
    cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
    cell.inputTextField.returnKeyType = UIReturnKeyDone;

    UIImage *img =  [UIImage imageNamed:[self.arrImg objectAtIndex:indexPath.row]];
    cell.ivLogo.image = img;
//    CGSize itemSize = CGSizeMake(img.size.width *2/3, img.size.height *2/3);
//
//    UIGraphicsBeginImageContext(itemSize);
//
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//
//    [cell.imageView.image drawInRect:imageRect];
//
//    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

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
        cell.validationBut.hidden = NO;
        cell.textFieldMaxLength = 6;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    NSRange range3 = [(NSString*)(self.dataArray[indexPath.row][0]) rangeOfString:@"基地"];
    if (range3.location ==NSNotFound)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.inputTextField.userInteractionEnabled = NO;
    }
    NSRange range4 = [(NSString*)(self.dataArray[indexPath.row][0]) rangeOfString:@"手机号"];
    if (range4.location ==NSNotFound)
    {
    }
    else
    {
        cell.textFieldMaxLength = 11;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    cell.inputTextField.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        ZCCityListViewController * vC = [[ZCCityListViewController alloc]init];
        vC.type = @"user";
        vC.getCityDelagate = self;
        [self.navigationController pushViewController:vC animated:YES] ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64 * SCREEN_H_COEFFICIENT;
}

-(void)getCityModel:(CityModel *)cityModel {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];;
    ZCInputTableViewCell * cell = [self.inputTableview cellForRowAtIndexPath:indexPath];
    cell.inputTextField.text = cityModel.startPosition;
    self.city = cityModel;
}

- (void)getCodeAction {

    NSIndexPath *indexPath;
    ZCInputTableViewCell * cell;
    NSString * phoneNumber = @"";
    NSString * verifycode;
    NSString * userbase;
    NSString * PassWord1;
    NSString * PassWord2;
    for (int i = 0; i < 5; i ++)
    {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];;
        cell = [self.inputTableview cellForRowAtIndexPath:indexPath];
        //        if ([cell.inputTextField.text isEqualToString:@""]) {
        //            [[Toast shareToast]makeText:@"请输入完整信息" aDuration:1];
        //            return ;
        //        }
        switch (i+1) {
            case 1:
                userbase = self.city.startPositionCode;
                break;
            case 2:
                phoneNumber = cell.inputTextField.text;
                break;
            case 3:
                verifycode = cell.inputTextField.text;
                break;
            case 4:
                PassWord1 = cell.inputTextField.text;
                break;
            case 5:
                PassWord2 = cell.inputTextField.text;
                break;
            default:
                break;
        }
    }

    if (![self checkPhoneWithPhone:phoneNumber]) {
        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];

    }else{
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];;
        cell = [self.inputTableview cellForRowAtIndexPath:indexPath];
        [cell validationButAction];

        UserInfoViewModel *vm = [UserInfoViewModel new];
        [vm getRCodeWithPhone:phoneNumber callback:^(NSString *st) {
            
        }];
    }



}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 属性懒加载部分

- (UITableView *)inputTableview {
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

- (UILabel *)textLab {
    if (!_textLab) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR1;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16.0f * SCREEN_H_COEFFICIENT];
        _textLab = label;
    }
    return _textLab;
}

- (UIButton *)concealBtn {
    if (!_concealBtn) {
        UIButton *button = [[UIButton alloc]init];
        _concealBtn = button;
    }
    return _concealBtn;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = APP_COLOR_BLUE.CGColor;
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _submitBtn = button;
    }
    return _submitBtn;
}

- (CityModel *)city {
    if (!_city) {
        _city = [CityModel new];
    }
    return _city;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (UIButton *)isAgreedButton {
    if (!_isAgreedButton) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"没同意"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"同意"] forState:UIControlStateSelected];
        button.selected = YES;
        _isAgreedButton = button;
    }
    return _isAgreedButton;
}
@end
