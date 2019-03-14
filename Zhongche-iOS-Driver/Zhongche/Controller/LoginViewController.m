//
//  LoginViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "LoginViewController.h"
#import "FirstPageViewController.h"
#import "BaseViewModel.h"
#import "ZCGuidePageView.h"
#import "ResetPasswordViewController.h"
#import "UserInfoViewModel.h"
#import "RegisterViewController.h"
#import "ZCMyOrderViewController.h"
#import "WaitForCheckViewController.h"
#import "GetGeographicalPosition.h"
#import "PhotoSeclectView.h"
#import "UserInfoModel.h"
#import "ZCTransportOrderViewModel.h"
#import "ZCFailCheckViewController.h"






@interface LoginViewController ( )<UITextFieldDelegate,ZCGuidePageViewDelegate>
@property (nonatomic, strong) UIButton    *btnLogin;//登陆按钮
@property (nonatomic, strong) UIButton    *btnForgetPassword;//忘记密码
@property (nonatomic, strong) UIButton    *btnRegister;//注册按钮
@property (nonatomic, strong) UILabel     *lbPhone;//手机号标签
@property (nonatomic, strong) UIImageView *ivPhone;
@property (nonatomic, strong) UILabel     *lbPassword;//密码标签
@property (nonatomic, strong) UIImageView *ivPassword;
@property (nonatomic, strong) UITextField *tfPhone;//手机号输入框
@property (nonatomic, strong) UITextField *tfPassword;//密码输入
@property (nonatomic, strong) UIImageView *ivLogo;//logo图标
@property (nonatomic, strong) UIButton    *btnTouch;//触摸关闭键盘
@property (nonatomic, strong) UIButton    *eyeBut;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.tfPhone.text = @"";
    self.tfPassword.text =@"";

    UserInfoModel *userInfo = USER_INFO;
    if (userInfo) {

        ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
       

        WS(ws);

        [vm selectOrderWithType:0 WithDriverid:[userInfo.driverId intValue] callback:^(NSMutableArray *arrInfo) {

            if (arrInfo.count > 0) {
                [ws.navigationController pushViewController:[ZCMyOrderViewController new] animated:NO];

            }else {
                // identStatus
                //quaStatus

                if (userInfo.identStatus == 3 || userInfo.quaStatus == 3) {
                    //审核失败

                     [ws.navigationController pushViewController:[ZCFailCheckViewController new] animated:NO];

                }

                else if (userInfo.identStatus == 0 || userInfo.quaStatus == 0) {
                    //未提交

                    [ws.navigationController pushViewController:[FirstPageViewController new] animated:NO];

                }

                else if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {
                    //审核通过

                    [ws.navigationController pushViewController:[ZCMyOrderViewController new] animated:NO];
                    
                }else {
                    //正在审核
                    
                    [ws.navigationController pushViewController:[WaitForCheckViewController new] animated:NO];
                }

            }

            
        }];

//
//        if (userInfo.driverStatus == 0) {
//            [self.navigationController pushViewController:[FirstPageViewController new] animated:NO];
//        }
//
//        if (userInfo.driverStatus == 1) {
//            [self.navigationController pushViewController:[WaitForCheckViewController new] animated:NO];
//        }
//
//        if (userInfo.driverStatus == 2) {
//            [self.navigationController pushViewController:[ZCMyOrderViewController new] animated:NO];
//        }
    }
    


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.btnLeft.hidden = YES;
    
    self.btnRight.hidden = NO;
    
    [self loadingGudiePageView];
}

- (void)bindView {




    
    self.view.backgroundColor = [UIColor whiteColor];

    
//    self.lbPhone.frame = CGRectMake(20, 60, 70, 44);
//    [self.view addSubview:self.lbPhone];

    self.ivPhone.frame = CGRectMake(30, 63, 30, 30);
    [self.view addSubview:self.ivPhone];
    
    self.tfPhone.frame = CGRectMake(self.ivPhone.right +30 , 60 , SCREEN_W -self.ivPhone.right - 40, 25);
    [self.view addSubview:self.tfPhone];
    
    UILabel *lbLine1 = [UILabel new];
    lbLine1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine1.frame = CGRectMake(70, self.ivPhone.bottom + 10, SCREEN_W - 20, 1);
    [self.view addSubview:lbLine1];
    
    self.ivPassword.frame = CGRectMake(30, lbLine1.bottom +23, 30, 30);
    [self.view addSubview:self.ivPassword];
    
    self.tfPassword.frame = CGRectMake(self.ivPassword.right +30,lbLine1.bottom +20, SCREEN_W -self.ivPassword.right -40, 25);
    [self.view addSubview:self.tfPassword];
    
    //self.eyeBut.frame = CGRectMake(SCREEN_W-120, lbLine1.bottom +10, 120, 44);
    //[self.view addSubview:self.eyeBut];

    UILabel *lbLine2 = [UILabel new];
    lbLine2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lbLine2.frame = CGRectMake(70, self.ivPassword.bottom + 10, SCREEN_W - 20, 1);
    [self.view addSubview:lbLine2];

    self.btnForgetPassword.frame = CGRectMake(SCREEN_W - 80, lbLine2.bottom + 10, 80, 30);
    [self.view addSubview:self.btnForgetPassword];
    
    self.btnLogin.frame = CGRectMake(20,lbLine2.bottom + 70 ,SCREEN_W-40 , (SCREEN_W-40)*3/20);
    [self.view addSubview:self.btnLogin];
    
    self.btnRegister.frame = CGRectMake(20, self.btnLogin.bottom + 20, SCREEN_W-40 , (SCREEN_W-40)*3/20);
    [self.view addSubview:self.btnRegister];
    
    self.btnTouch.frame = CGRectMake(0, 0, SCREEN_W, self.ivLogo.bottom + 20);
    [self.view addSubview:self.btnTouch];

}

- (void)bindAction {
    
    
    WS(ws);
    [[self.btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        [ws logInAction];
    }];
    [[self.btnForgetPassword rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws btnForgetPasswordAction];
    }];
    [[self.btnTouch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws.view endEditing:YES];
    }];
    [[self.btnRegister rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws btnRegisterPasswordAction];
    }];
    [[self.eyeBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws eyeButAction];
    }];
    

}




-(void)eyeButAction {
    self.eyeBut.selected = !self.eyeBut.selected;
    self.tfPassword.secureTextEntry = !self.tfPassword.secureTextEntry;
}


-(void)btnForgetPasswordAction {
    ResetPasswordViewController * vC = [[ResetPasswordViewController alloc]init];
    [self.navigationController pushViewController:vC animated:YES] ;
}

- (void)btnRegisterPasswordAction {
    RegisterViewController * vC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:vC animated:YES] ;
}

-(void) logInAction{

    
    if ([self.tfPhone.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"手机号不能为空" aDuration:1];
    }else if([self.tfPassword.text isEqualToString:@""]){
        [[Toast shareToast]makeText:@"密码不能为空" aDuration:1];
    }else if(self.tfPhone.text.length !=11){
        [[Toast shareToast]makeText:@"手机号位数不正确" aDuration:1];
    }
    else{

        if ([self checkPhoneWithPhone:self.tfPhone.text]) {

            UserInfoViewModel *vm = [UserInfoViewModel new];
            WS(ws);

            [vm loginWithPhone:self.tfPhone.text WithPassWord:self.tfPassword.text callback:^(UserInfoModel *userInfo) {
                if (userInfo) {




                    //启动定位
                    [[GetGeographicalPosition shareGetGeographicalPosition] start];

                    [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];


                    //拉取车辆

                    UserInfoViewModel *usvm = [UserInfoViewModel new];


                    [usvm getBindCarListWithUserId:userInfo.iden callback:^(CarInfoModel *info) {

                        [NSKeyedArchiver archiveRootObject:info toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];

                    }];





                    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];

                    [vm selectOrderWithType:0 WithDriverid:[userInfo.driverId intValue] callback:^(NSMutableArray *arrInfo) {

                        if (arrInfo.count > 0) {
                            [ws.navigationController pushViewController:[ZCMyOrderViewController new] animated:NO];

                        }else {
                            // identStatus
                            //quaStatus

                            if (userInfo.identStatus == 3 || userInfo.quaStatus == 3) {
                                //审核失败
                                [ws.navigationController pushViewController:[ZCFailCheckViewController new] animated:NO];

                            }

                            else if (userInfo.identStatus == 0 || userInfo.quaStatus == 0) {
                                //未提交

                                [ws.navigationController pushViewController:[FirstPageViewController new] animated:NO];

                            }

                            else if (userInfo.identStatus == 2 && userInfo.quaStatus == 2) {
                                //审核通过
                                
                                [ws.navigationController pushViewController:[ZCMyOrderViewController new] animated:NO];
                                
                            }else {
                                //正在审核
                                
                                [ws.navigationController pushViewController:[WaitForCheckViewController new] animated:NO];
                            }
                            
                        }
                        
                        
                    }];
                    
                    
                }
            }];

        }else {

            [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];
        }


    }
    

}


///**
// *  自动登录
// */
//
//- (void)qickLoginAction{
//    
//    UserInfoViewModel *vm = [UserInfoViewModel new];
//    
//    UserInfoModel *userInfoModel = USER_INFO;
//    
//    [vm loginWithPhone:userInfoModel.phone WithPassWord:userInfoModel.password callback:^(UserInfoModel *userInfo) {
//        if (userInfo) {
//            
//            [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
//            if (userInfo.driver_status == 2) {
//
//                ZCMyOrderViewController *vc = [ZCMyOrderViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }else if (userInfo.driver_status == 1) {
//
//                WaitForCheckViewController *vc = [WaitForCheckViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//                
//            }else{
//
//
//                FirstPageViewController *vc = [FirstPageViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }
//        }
//    }];
//
//}



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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.tfPassword) {
        int num = (int)string.length;

        if ([string isEqualToString:@""]) {

            num = -1;

        }

        if ( textField.text.length + num < 6) {
            [self.btnLogin setBackgroundImage:[UIImage  getImageWithColor:[UIColor lightGrayColor] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
            self.btnLogin.userInteractionEnabled = NO;

        }else {

            [self.btnLogin setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
            self.btnLogin.userInteractionEnabled = YES;
            
        }
    }


    return YES;

}



/**
 *  加载引导页相关内容
 */
- (void)loadingGudiePageView {
    NSUserDefaults * appdict = [NSUserDefaults standardUserDefaults];
    if ([appdict objectForKey:@"bootRecordForVersion:1.0"])
    {
        return ;
    }
    [appdict setObject:@YES forKey:@"bootRecordForVersion:1.0"];
    self.navigationController.navigationBar.hidden = YES;
    ZCGuidePageView * gudiePageView = [[ZCGuidePageView alloc]init];
    gudiePageView.delegate = self;
    [self.view addSubview:gudiePageView];
}
/**
 *  实现 ZCGuidePageView 代理方法
 *
 *  @param guidePageView 协议委托方
 */
- (void)guidePageViewEnd:(UIView *)guidePageView
{
    [guidePageView removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    self.view.frame = CGRectMake(0, 64, SCREEN_W, SCREEN_H-64);
}



/**
 *  getter（懒加载）
 *
 *  @return
 */



- (UIButton *)btnLogin {
    if (!_btnLogin) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor lightGrayColor] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        button.userInteractionEnabled = NO;
        _btnLogin = button;
    }
    return _btnLogin;
}

- (UIButton *)btnRegister {
    if (!_btnRegister) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"注册" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_ORANGR2 forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = APP_COLOR_ORANGR2.CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径

        
        
        _btnRegister = button;
    }
    return _btnRegister;
}

- (UIButton *)btnForgetPassword {
    if (!_btnForgetPassword) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
      
        
        _btnForgetPassword = button;
    }
    return _btnForgetPassword;
}

- (UITextField *)tfPhone {
    if (!_tfPhone) {
        _tfPhone = [UITextField new];
        _tfPhone.placeholder = @"请输入手机号";
        _tfPhone.returnKeyType = UIReturnKeyDone;
        _tfPhone.keyboardType = UIKeyboardTypePhonePad;
        _tfPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tfPhone.delegate = self;
        
    }
    return _tfPhone;
}

- (UITextField *)tfPassword {
    if (!_tfPassword) {
        _tfPassword = [UITextField new];
        _tfPassword.placeholder = @"请输入登录密码";
        _tfPassword.returnKeyType = UIReturnKeyDone;
        _tfPassword.delegate = self;
        self.tfPassword.secureTextEntry = YES;
         _tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _tfPassword;
}

- (UILabel *)lbPhone {
    if (!_lbPhone) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"手机号";
        
        _lbPhone = label;
    }
    return _lbPhone;
}

- (UILabel *)lbPassword {
    if (!_lbPassword) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:20.0f];
        label.text = @"密码";
        
        _lbPassword = label;
    }
    return _lbPassword;
}

- (UIImageView *)ivLogo {
    if (!_ivLogo) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"logo"];

        
        _ivLogo = imageView;
    }
    return _ivLogo;
}

- (UIButton *)btnTouch {
    if (!_btnTouch) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _btnTouch = button;
    }
    return _btnTouch;
}

- (UIButton *)eyeBut {
    if (!_eyeBut) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"眼睛-拷贝"] forState:UIControlStateSelected];
        _eyeBut = button;
    }
    return _eyeBut;
}

- (UIImageView *)ivPhone {
    if (!_ivPhone) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"user"];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        <#custom#>

        _ivPhone = imageView;
    }
    return _ivPhone;
}

- (UIImageView *)ivPassword {
    if (!_ivPassword) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"password"];

        _ivPassword = imageView;
    }
    return _ivPassword;
}



@end
