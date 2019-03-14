//
//  PhotoSeclectView.m
//  Zhongche
//
//  Created by lxy on 16/9/6.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PhotoSeclectView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PhotoSeclectView()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UIButton *btn;



@end

@implementation PhotoSeclectView



- (void)binView {

    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
    



}

- (void) viewFrame :(CGSize )size {

    self.size = size;

    self.iv.size = size;
    [self addSubview:self.iv];

    self.btn.size = size;
    [self addSubview:self.btn];



}


- (void)setImplace:(UIImage *)implace {

    self.iv.image = implace;
}

-(void) selectAction {

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];


   [actionSheet showInView:[self getCurrentVC].view];



}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;

    return result;
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;


    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [[self getCurrentVC] presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [[self getCurrentVC] presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //按照按钮的顺序0-N；
    switch (buttonIndex) {
        case 0:
            [self selectImageFromCamera];
            break;

        case 1:
            [self selectImageFromAlbum];
            break;
            
            
        default:
            break;
    }
    
}


#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    self.imCurrent = image;
    self.iv.image = image;
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        self.imCurrent = info[UIImagePickerControllerOriginalImage];
        self.iv.image = info[UIImagePickerControllerOriginalImage];
    }
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  getter
 */

- (UIImageView *)iv {
    if (!_iv) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"1468575158"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        _iv = imageView;
    }
    return _iv;
}

- (UIButton *)btn {
    if (!_btn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];


        _btn = button;
    }
    return _btn;
}


@end
