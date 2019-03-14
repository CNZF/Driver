//
//  personHomeHeadView.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "personHomeHeadView.h"
#import "SelfDefineTabBarViewController.h"
#import "PersonViewController.h"
#import "UserInfoModel.h"
#import <UIImageView+AFNetworking.h>
#import "ZCEWCodeViewController.h"

@interface personHomeHeadView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;


@property (strong, nonatomic) id target;
@end
@implementation personHomeHeadView


- (void)layoutSubviews
{
    [super layoutSubviews];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onHeadImageClicked)];
    [self.BGImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCodeImageClicked)];
    [self.codeImageView addGestureRecognizer:tap1];
}

- (void)onCodeImageClicked{
    ZCEWCodeViewController *vc = [ZCEWCodeViewController new];
    vc.title = @"二维码";
    UserInfoModel * info = [UserInfoModel new];
    vc.message = [NSString stringWithFormat:@"%i",info.iden];
    SelfDefineTabBarViewController * controller = self.target;
    [controller.navigationController pushViewController:vc animated:YES];
}

- (void)onHeadImageClicked
{
    SelfDefineTabBarViewController * controller = self.target;
    PersonViewController * person = [[PersonViewController alloc]init];
    [controller.navigationController pushViewController:person animated:YES];
}

- (void)getControllerWith:(id)target
{
    self.target = target;
    UserInfoModel * info = [UserInfoModel new];
    
    if (info.icon) {
       NSString * url = [NSString stringWithFormat:@"%@%@",BASEIMGURL,[info.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
       [self.headImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head"]];
    }
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)setMessage:(NSString *)message {
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = message;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    self.codeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:150];
    
}

- (void)setInfo:(UserInfoModel *)info
{
    _info = info;
    NSString *url;
    if (self.info.icon) {
        url = [NSString stringWithFormat:@"%@%@",BASEIMGURL,[info.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head"]];
    if (self.info.real_name) {
        self.nameLabel.text =  self.info.real_name;
    }else{
        self.nameLabel.text =  self.info.login_name;
    }
    
    self.message = [NSString stringWithFormat:@"%i",self.info.iden];
}

@end
