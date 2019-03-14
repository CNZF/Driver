//
//  ZCEWCodeViewController.m
//  Zhongche
//
//  Created by lxy on 16/9/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCEWCodeViewController.h"

@interface ZCEWCodeViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZCEWCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView
{
    
    self.view.backgroundColor = [UIColor colorWithRed:66/255.0f green:66/255.0f blue:66/255.0f alpha:1];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(50, SCREEN_H/2-SCREEN_W/2- 50, SCREEN_W-100, SCREEN_W-80)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 30;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    self.imageView.frame = CGRectMake(100 ,SCREEN_H/2-SCREEN_W/2- 50+60 , SCREEN_W-200, SCREEN_W-200);
    [self.view addSubview:self.imageView];
}


/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
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
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:150];

}


/**
 *  getter
 */

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc]init];

        _imageView = imageView;
    }
    return _imageView;
}


@end
