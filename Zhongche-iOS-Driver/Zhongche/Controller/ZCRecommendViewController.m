//
//  ZCRecommendViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/17.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCRecommendViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"


@interface ZCRecommendViewController ()

@property (nonatomic, strong) UILabel     *lb1;
@property (nonatomic, strong) UILabel     *lbLine1;
@property (nonatomic, strong) UILabel     *lb2;
@property (nonatomic, strong) UIImageView *ivCode;
@property (nonatomic, strong) UILabel     *lb3;
@property (nonatomic, strong) UILabel     *lb4;
@property (nonatomic, strong) UILabel     *lbLine2;
@property (nonatomic, strong) UILabel     *lb5;
@property (nonatomic, strong) UIButton    *btnWeChat;
@property (nonatomic, strong) UIButton    *btnFriends;
@property (nonatomic, strong) UIButton    *btnQQ;
@property (nonatomic, strong) UIButton    *btnQQRoom;
@property (nonatomic, strong) UILabel     *lb6;
@property (nonatomic, strong) UILabel     *lb7;
@property (nonatomic, strong) UILabel     *lb8;
@property (nonatomic, strong) UILabel     *lb9;

@end

@implementation ZCRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)bindView {
    
    self.title = @"推荐有奖";
    self.btnRight.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.lbLine1.frame = CGRectMake(0, 52, SCREEN_W, 0.2);
    [self.view addSubview:self.lbLine1];
    
    self.lb1.frame = CGRectMake(SCREEN_W/2 - 50, 30, 100, 44);
    [self.view addSubview:self.lb1];
    
    
    if (SCREEN_H< 500) {
        self.lbLine1.frame = CGRectMake(0, 32, SCREEN_W, 0.2);
        [self.view addSubview:self.lbLine1];
        
        self.lb1.frame = CGRectMake(SCREEN_W/2 - 50, 10, 100, 44);
        [self.view addSubview:self.lb1];

    }
    
    self.lb2.frame = CGRectMake(0, self.lb1.bottom + 10, SCREEN_W, 20);
    [self.view addSubview:self.lb2];
    
    self.ivCode.frame = CGRectMake(SCREEN_W/2 - 40, self.lb2.bottom + 20, 80, 80);
    [self.view addSubview:self.ivCode];
    
    self.lb3.frame = CGRectMake(0, self.ivCode.bottom + 40, SCREEN_W , 10);
    [self.view addSubview:self.lb3];
    
    self.lb4.frame = CGRectMake(0, self.lb3.bottom + 10, SCREEN_W , 10);
    [self.view addSubview:self.lb4];
    
    self.lbLine2.frame = CGRectMake(0, self.lb4.bottom + 52, SCREEN_W, 0.2);
    [self.view addSubview:self.lbLine2];
    
    self.lb5.frame = CGRectMake(SCREEN_W/2 - 50, self.lb4.bottom + 30, 100, 44);
    [self.view addSubview:self.lb5];
    
    if (SCREEN_H< 500) {
        self.lbLine2.frame = CGRectMake(0, self.lb4.bottom + 32, SCREEN_W, 0.2);
        [self.view addSubview:self.lbLine2];
        
        self.lb5.frame = CGRectMake(SCREEN_W/2 - 50, self.lb4.bottom + 10, 100, 44);
        [self.view addSubview:self.lb5];

        
    }
    
    self.btnWeChat.frame = CGRectMake((SCREEN_W - 200)/5, self.lb5.bottom + 30, 50, 50);
    [self.view addSubview: self.btnWeChat];
    
    self.btnFriends.frame = CGRectMake(self.btnWeChat.right + (SCREEN_W - 200)/5, self.lb5.bottom + 30, 50, 50);
    [self.view addSubview:self.btnFriends];
    
    self.btnQQ.frame = CGRectMake(self.btnFriends.right + (SCREEN_W - 200)/5, self.lb5.bottom + 30, 50, 50);
    [self.view addSubview:self.btnQQ];
    
    self.btnQQRoom.frame = CGRectMake(self.btnQQ.right + (SCREEN_W - 200)/5, self.lb5.bottom + 30, 50, 50);
    [self.view addSubview:self.btnQQRoom];
    
    self.lb6.frame = CGRectMake((SCREEN_W - 200)/5, self.btnQQ.bottom +5, 50, 15);
    [self.view addSubview:self.lb6];
    
    self.lb7.frame = CGRectMake(self.lb6.right + (SCREEN_W - 200)/5, self.btnQQ.bottom +5, 50, 15);
    [self.view addSubview:self.lb7];
    
    self.lb8.frame = CGRectMake(self.lb7.right + (SCREEN_W - 200)/5, self.btnQQ.bottom +5, 50, 15);
    [self.view addSubview:self.lb8];
    
    self.lb9.frame = CGRectMake(self.lb8.right + (SCREEN_W - 200)/5, self.btnQQ.bottom +5, 50, 15);
    [self.view addSubview:self.lb9];
    
    

}

-(void)sharAction:(UIButton *)btn{
    
    [[Toast shareToast]makeText:@"该功能暂未开启" aDuration:1];
    
//    switch (btn.tag) {
//        case 11:
//            [self shareWinxin];
//            break;
//            
//        case 12:
//            [self shareWinxinLine];
//            break;
//            
//        case 13:
//            [self shareQQ];
//            break;
//            
//        case 14:
//            [self shareQQZone];
//            break;
//            
//        default:
//            break;
//    }

}

//分享微信
- (void)shareWinxin {

    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"中车分享测试"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK clientShareContent:publishContent //内容对象
                            type:ShareTypeWeixiSession //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件

                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                              }
                          }];

}

//分享微信朋友圈
- (void)shareWinxinLine {

     NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"中车分享测试"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK clientShareContent:publishContent //内容对象
                            type:ShareTypeWeixiTimeline //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件

                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                              }
                          }];
    
}

//分享QQ
- (void)shareQQ {

     NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"中车分享测试"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK clientShareContent:publishContent //内容对象
                            type:ShareTypeQQ //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件

                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                              }
                          }];
    
}

//分享QQ空间
- (void)shareQQZone {

     NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享"
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"中车分享测试"
                                                  url:@"http://www.mob.com"
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];

    [ShareSDK clientShareContent:publishContent //内容对象
                            type:ShareTypeQQSpace //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件

                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                              }
                          }];
    
}



/**
 *  get(懒加载)
 */

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont boldSystemFontOfSize:20.0f];
        label.text = @"扫码注册";
        label.textAlignment = NSTextAlignmentCenter;
        
        
        _lb1 = label;
    }
    return _lb1;
}

- (UILabel *)lbLine1 {
    if (!_lbLine1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        
        
        _lbLine1 = label;
    }
    return _lbLine1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"请朋友们扫面您的二维码";
        
        
        
        _lb2 = label;
    }
    return _lb2;
}

- (UIImageView *)ivCode {
    if (!_ivCode) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"1468575158"];
        
        
        _ivCode = imageView;
    }
    return _ivCode;
}

- (UILabel *)lb3 {
    if (!_lb3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您推荐的司机成功上线后，你们都将获得";
        
        
        _lb3 = label;
    }
    return _lb3;
}

- (UILabel *)lb4 {
    if (!_lb4) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"相应奖励";
        
        
        _lb4 = label;
    }
    return _lb4;
}

- (UILabel *)lbLine2 {
    if (!_lbLine2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor lightGrayColor];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        
        
        _lbLine2 = label;
    }
    return _lbLine2;
}

- (UILabel *)lb5 {
    if (!_lb5) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:20.0f];
        label.text = @"社交分享";
        label.textAlignment = NSTextAlignmentCenter;
        
        
        _lb5 = label;
    }
    return _lb5;
}

- (UIButton *)btnWeChat {
    if (!_btnWeChat) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 11;
        [button addTarget:self action:@selector(sharAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _btnWeChat = button;
    }
    return _btnWeChat;
}

- (UIButton *)btnFriends {
    if (!_btnFriends) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"微信朋友圈"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 12;
        [button addTarget:self action:@selector(sharAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnFriends = button;
    }
    return _btnFriends;
}

- (UIButton *)btnQQ {
    if (!_btnQQ) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"QQ好友"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 13;
        [button addTarget:self action:@selector(sharAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnQQ = button;
    }
    return _btnQQ;
}

- (UIButton *)btnQQRoom {
    if (!_btnQQRoom) {
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 14;
        [button addTarget:self action:@selector(sharAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _btnQQRoom = button;
    }
    return _btnQQRoom;
}

- (UILabel *)lb6 {
    if (!_lb6) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"微信";
        label.textAlignment = NSTextAlignmentCenter;
        
        _lb6 = label;
    }
    return _lb6;
}

- (UILabel *)lb7 {
    if (!_lb7) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"朋友圈";
        label.textAlignment = NSTextAlignmentCenter;
        
        _lb7 = label;
    }
    return _lb7;
}

- (UILabel *)lb8 {
    if (!_lb8) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"QQ";
        label.textAlignment = NSTextAlignmentCenter;
        
        _lb8 = label;
    }
    return _lb8;
}

- (UILabel *)lb9 {
    if (!_lb9) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"QQ空间";
        label.textAlignment = NSTextAlignmentCenter;
        
        _lb9 = label;
    }
    return _lb9;
}


@end
