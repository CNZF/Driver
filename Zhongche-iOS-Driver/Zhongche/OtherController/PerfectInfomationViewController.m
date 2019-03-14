//
//  PerfectInfomationViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/21.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PerfectInfomationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UserImgInfo.h"
#import "UserInfoViewModel.h"
#import "UserInfoModel.h"
#import "PerfectCarInfomationViewController.h"
#import "WaitForCheckViewController.h"

#import "ContentView.h"

@interface PerfectInfomationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) ContentView * contentView;
@property (nonatomic, assign) IMAGETYPE imageType;

@property (nonatomic, strong) UIView * headView;

@property (nonatomic, copy) UILabel * topLabel;
@property (nonatomic, copy) UILabel * topDetailLabel;

@property (nonatomic, strong) UILabel      *lbName;
@property (nonatomic, strong) UITextField  *tfName;
@property (nonatomic, strong) UILabel      *lbIdentity;
@property (nonatomic, strong) UITextField  *tfIdentity;
@property (nonatomic, strong) UILabel      *lbIdentityImg;
@property (nonatomic, strong) UIImageView  *ivIdentityFront;//身份证正面照片
@property (nonatomic, strong) UIImageView  *ivIdentityBack;//身份证背面照片
@property (nonatomic, strong) UILabel      *lbDrivingLicenceImg;
@property (nonatomic, strong) UIImageView  *ivDrivingLicence;//驾驶证照片
@property (nonatomic, strong) UILabel      *lbPower;
@property (nonatomic, strong) UIImageView  *ivPowerImg;//资格证照片
@property (nonatomic, strong) UIButton     *btnNext;

@property (nonatomic, strong) UIButton     *btnIdentityFront;
@property (nonatomic, strong) UIButton     *btnIdentityBack;
@property (nonatomic, strong) UIButton     *btnDrivingLicence;
@property (nonatomic, strong) UIButton     *btnPowerImg;

@property (nonatomic, strong) UIImageView  *ivCurrent;

@property (nonatomic, strong) UIImage      *idimagefront;//身份证正面
@property (nonatomic, strong) UIImage      *idimageback;//身份证反面
@property (nonatomic, strong) UIImage      *drivelicensefront;//驾驶证
@property (nonatomic, strong) UIImage      *certifiedfront;//从业证

@property (nonatomic, strong) UIView       *viBottom;

@end

@implementation PerfectInfomationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.btnRight.hidden =  NO;
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
     self.view.backgroundColor = APP_COLOR_PHOTOGRAY;
}

- (void)bindView {

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"完善个人信息";
    
    self.ivCurrent = [[UIImageView alloc] init];
    self.scroView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H- kiPhoneFooterHeight);
    self.scroView.contentSize = CGSizeMake(0, 800);
    [self.view addSubview:self.scroView];
    
    [self.scroView addSubview:self.contentView];
    
//    self.topLabel.frame = CGRectMake(20, 15,80, 20);
//    self.topDetailLabel.frame = CGRectMake(110, 15,SCREEN_W- 120, 20);
//    
//    [self.scroView addSubview:self.topLabel];
//    [self.scroView addSubview:self.topDetailLabel];
//    
//    self.lbName.frame = CGRectMake(20, 40, 80, 44);
//    [self.scroView addSubview:self.lbName];
//
//    self.tfName.frame = CGRectMake(self.lbName.right + 10, 10, SCREEN_W - self.lbName.right, 44);
//    [self.scroView addSubview:self.tfName];
//
//    UILabel *lbLine1 = [UILabel new];
//    lbLine1.frame = CGRectMake(0, self.tfName.bottom, SCREEN_W, 0.5);
//    lbLine1.backgroundColor = [UIColor lightGrayColor];
//    [self.scroView addSubview:lbLine1];
//
//    self.lbIdentity.frame = CGRectMake(20, lbLine1.bottom, 80, 44);
//    [self.scroView addSubview:self.lbIdentity];
//
//    self.tfIdentity.frame = CGRectMake(self.lbName.right + 10, lbLine1.bottom, SCREEN_W - self.lbIdentity.right, 44);
//    [self.scroView addSubview:self.tfIdentity];
//
//    UILabel *lbLine2 = [UILabel new];
//    lbLine2.frame = CGRectMake(0, self.tfIdentity.bottom, SCREEN_W, 0.5);
//    lbLine2.backgroundColor = [UIColor lightGrayColor];
//    [self.scroView addSubview:lbLine2];
//
//    self.lbIdentityImg.frame = CGRectMake(20, lbLine2.bottom, SCREEN_W - 40, 44);
//    [self.scroView addSubview:self.lbIdentityImg];
//
//    self.ivIdentityFront.frame = CGRectMake(10, self.contentView.bottom + 10, 150, 100);
//    [self.scroView addSubview:self.ivIdentityFront];
////
//    self.btnIdentityFront.frame = CGRectMake(10, self.lbIdentityImg.bottom + 10,  150, 100);
//
//
//    [self.scroView addSubview:self.btnIdentityFront];
////
//    self.ivIdentityBack.frame = CGRectMake(SCREEN_W/2 + 5, self.contentView.bottom  + 10,  150, 100);
//
//    [self.scroView addSubview:self.ivIdentityBack];
////
//    self.btnIdentityBack.frame = CGRectMake(SCREEN_W/2 + 5, self.lbIdentityImg.bottom + 10,  150, 100);
//
//
//    [self.scroView addSubview:self.btnIdentityBack];
////
//    self.lbDrivingLicenceImg.frame = CGRectMake(20, self.ivIdentityBack.bottom, SCREEN_W - 40, 44);
//    [self.scroView addSubview:self.lbDrivingLicenceImg];
////
//    self.ivDrivingLicence.frame = CGRectMake(10, self.lbDrivingLicenceImg.bottom + 10, 180, 120);
//
//    [self.scroView addSubview:self.ivDrivingLicence];
////
//    self.btnDrivingLicence.frame = CGRectMake(10, self.lbDrivingLicenceImg.bottom + 10, 180, 120);
//    [self.scroView addSubview:self.btnDrivingLicence];
////
//    self.lbPower.frame = CGRectMake(20, self.ivDrivingLicence.bottom, SCREEN_W - 40, 44);
//    [self.scroView addSubview:self.lbPower];
//
//    self.ivPowerImg.frame = CGRectMake(10, self.lbPower.bottom + 10, 180, 120);
//    [self.scroView addSubview:self.ivPowerImg];
//
//    self.btnPowerImg.frame = CGRectMake(10, self.lbPower.bottom + 10, 180, 120);
//
//    [self.scroView addSubview:self.btnPowerImg];
//
//    self.scroView.contentSize = CGSizeMake(SCREEN_W, self.btnPowerImg.bottom + 80);
//
//    self.viBottom.frame = CGRectMake(0, SCREEN_H - 75 - 64, SCREEN_W, 80);
//    [self.view addSubview:self.viBottom];
//
//    self.btnNext.frame = CGRectMake(20, 15, SCREEN_W - 40, 44);
//    [self.viBottom addSubview:self.btnNext];

}

- (void)chooseImage:(UIButton *)btn {

    [self.view endEditing:YES];

    if (btn.tag == 11) {
        self.ivCurrent = self.ivIdentityFront;
    }
    if (btn.tag == 12) {
        self.ivCurrent = self.ivIdentityBack;
    }
    if (btn.tag == 13) {
        self.ivCurrent = self.ivDrivingLicence;
    }
    if (btn.tag == 14) {
        self.ivCurrent = self.ivPowerImg;
    }
      self.ivCurrent.tag = btn.tag;
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
     [actionSheet showInView:self.view];

}

- (void)nextAction{

    UserInfoViewModel *vm =  [UserInfoViewModel new];
    UserImgInfo *info = [UserImgInfo new];
    info.idimagefront = self.contentView.imageView1.image;
    info.idimageback = self.contentView.imageView2.image;
    info.drivelicensefront = self.contentView.imageView3.image;
    info.certifiedfront = self.contentView.imageView4.image;

   UserInfoModel *user = USER_INFO;

    NSString *searchText = self.contentView.idCardField.text;
    NSError *error = NULL;
    //十五位身份证号
    
    //        NSRegularExpression *regex15 = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$" options:NSRegularExpressionCaseInsensitive error:&error];
    //        NSTextCheckingResult *result15 = [regex15 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    NSRegularExpression *regex18 = [NSRegularExpression regularExpressionWithPattern:@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result18 = [regex18 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (result18) {
        WS(ws);
        [vm perfectDriverInformation:user.iden WithType:0 WithRealname:self.contentView.nameField.text WithIdnumber:self.contentView.idCardField.text WithUserImgInfo:info callback:^(NSString *st) {
            
            
            if ([st isEqualToString:@"10000"]) {
                [ws.navigationController pushViewController:[WaitForCheckViewController new] animated:YES];
            }
            
            
        }];
    }else{
        [[Toast shareToast]makeText:@"身份证号码格式错误" aDuration:1];
    }

}

- (void)imgSet{

    if (self.imageType == SBRING) {
        self.contentView.imageView1.image = self.ivCurrent.image;
    }
    if (self.imageType == SBACK) {
        self.contentView.imageView2.image = self.ivCurrent.image;
    }
    if (self.imageType == JCARK) {
        self.contentView.imageView3.image = self.ivCurrent.image;
    }
    if (self.imageType == HCARD) {
        self.contentView.imageView4.image = self.ivCurrent.image;
    }
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;


    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum {
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:_imagePickerController animated:YES completion:nil];
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
    self.ivCurrent.image = image;
    [self imgSet];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        self.ivCurrent.image = info[UIImagePickerControllerOriginalImage];
        [self imgSet];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

/**
 *  get(懒加载)
 */

- (UIScrollView *)scroView {
    if (!_scroView) {
        _scroView = [UIScrollView new];
        _scroView.delegate = self;

    }
    return _scroView;
}
- (UILabel *)topLabel {
    if (!_topLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
//        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        label.text = @"基本信息";
        
        
        
        _topLabel = label;
    }
    return _topLabel;
}

- (UILabel *)topDetailLabel {
    if (!_topDetailLabel) {
        UILabel* label = [[UILabel alloc]init];
//        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"审核通过后不能修改，请填写真实信息";
        
        
        
        _topDetailLabel = label;
    }
    return _topDetailLabel;
}
- (UILabel *)lbName {
    if (!_lbName) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        label.text = @"姓名";



        _lbName = label;
    }
    return _lbName;
}

- (UITextField *)tfName {

    if (!_tfName) {
        _tfName = [UITextField new];
        _tfName.placeholder = @"请输入姓名";
        _tfName.font = [UIFont systemFontOfSize:18.0f];
    }
    return _tfName;
}

- (UILabel *)lbIdentity {
    if (!_lbIdentity) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        label.text = @"身份证";


        _lbIdentity = label;
    }
    return _lbIdentity;
}

- (UITextField *)tfIdentity {
    if (!_tfIdentity) {
        _tfIdentity = [UITextField new];
        _tfIdentity.placeholder = @"请输入您的身份证";
        _tfIdentity.font = [UIFont systemFontOfSize:18.0f];
    }
    return _tfIdentity;
}

- (UILabel *)lbIdentityImg {
    if (!_lbIdentityImg) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"身份证正反面照片";


        _lbIdentityImg = label;
    }
    return _lbIdentityImg;
}

- (UIImageView *)ivIdentityFront {
    if (!_ivIdentityFront) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;

        _ivIdentityFront = imageView;
    }
    return _ivIdentityFront;
}

- (UIImageView *)ivIdentityBack {
    if (!_ivIdentityBack) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;

        _ivIdentityBack = imageView;
    }
    return _ivIdentityBack;
}

- (UILabel *)lbDrivingLicenceImg {
    if (!_lbDrivingLicenceImg) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"驾驶证照片";



        _lbDrivingLicenceImg = label;
    }
    return _lbDrivingLicenceImg;
}

- (UILabel *)lbPower {
    if (!_lbPower) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"货运从业资格证";

        _lbPower = label;
    }
    return _lbPower;
}

- (UIImageView *)ivPowerImg {
    if (!_ivPowerImg) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;

        _ivPowerImg = imageView;
    }
    return _ivPowerImg;
}

- (UIImageView *)ivDrivingLicence {
    if (!_ivDrivingLicence) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;



        _ivDrivingLicence = imageView;
    }
    return _ivDrivingLicence;
}

- (UIButton *)btnNext {
    if (!_btnNext) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];


        _btnNext = button;
    }
    return _btnNext;
}

- (UIButton *)btnIdentityFront {
    if (!_btnIdentityFront) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

        button.tag = 11;

        _btnIdentityFront = button;
    }
    return _btnIdentityFront;
}

- (UIButton *)btnIdentityBack {
    if (!_btnIdentityBack) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

         button.tag = 12;

        _btnIdentityBack = button;
    }
    return _btnIdentityBack;
}

- (UIButton *)btnDrivingLicence {
    if (!_btnDrivingLicence) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

         button.tag = 13;

        _btnDrivingLicence = button;
    }
    return _btnDrivingLicence;
}

- (UIButton *)btnPowerImg {
    if (!_btnPowerImg) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

         button.tag = 14;

        _btnPowerImg = button;
    }
    return _btnPowerImg;
}

- (UIView *)viBottom {
    if (!_viBottom) {
        _viBottom = [UIView new];
        _viBottom.backgroundColor = [UIColor whiteColor];
        _viBottom.layer.shadowOffset =  CGSizeMake(1, 1);
        _viBottom.layer.shadowOpacity = 0.5;
        _viBottom.layer.shadowColor =  [UIColor grayColor].CGColor;

    }
    return _viBottom;
}

- (void)getAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)checkField
{
    if (self.contentView.nameField.text.length <1 || self.contentView.idCardField.text.length <1 ) {
        [[Toast shareToast] makeText:@"请完善基本信息" aDuration:1];
        return;
    }
    if (!self.contentView.imageView1.image) {
        [[Toast shareToast] makeText:@"请上传身份证正面" aDuration:1];
        return;
    }
    if (!self.contentView.imageView2.image) {
        [[Toast shareToast] makeText:@"请上传身份证反面" aDuration:1];
        return;
    }
    if (!self.contentView.imageView3.image) {
        [[Toast shareToast] makeText:@"请上传驾驶证资质" aDuration:1];
        return;
    }
    if (!self.contentView.imageView4.image) {
        [[Toast shareToast] makeText:@"请上货运资格证资质" aDuration:1];
        return;
    }
    [self nextAction];
}
- (ContentView *)contentView
{
    __weak typeof(self) WeakSelf = self;
    if (!_contentView) {
        _contentView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ContentView class]) owner:self options:nil] firstObject];
        _contentView.frame = CGRectMake(0, 0, SCREEN_W, 630);
        [_contentView setBlock:^(IMAGETYPE index) {
            switch (index) {
                case SBRING:
                     WeakSelf.imageType = SBRING;
                     [WeakSelf getAction];
                    break;
                case SBACK:
                     WeakSelf.imageType = SBACK;
                     [WeakSelf getAction];
                  
                    break;
                case JCARK:
                     WeakSelf.imageType = JCARK;
                    [WeakSelf getAction];
                    break;
                case HCARD:
                     WeakSelf.imageType = HCARD;
                     [WeakSelf getAction];
                    break;
                case COMMIT:
                    [self checkField];
                    break;
               
                default:
                    break;
                    
            }
        }];
    }
    return _contentView;
}

@end
