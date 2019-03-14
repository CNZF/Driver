//
//  QCodeViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "QCodeViewController.h"
#import "BaseTapSound.h"
#import <AVFoundation/AVFoundation.h>
#import "AdViewController.h"



@interface QCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>{
    SystemSoundID soundID;
    float move;
}
@property (strong , nonatomic) AVCaptureDevice            * device;
@property (strong , nonatomic) AVCaptureDeviceInput       * input;
@property (strong , nonatomic) AVCaptureMetadataOutput    * output;
@property (strong , nonatomic) AVCaptureSession           * session;
@property (strong , nonatomic) AVCaptureVideoPreviewLayer * preview;
@property (strong , nonatomic) UIImageView                *qrView;
@property (strong , nonatomic) UIImageView                *lineLabel;
@property (strong , nonatomic) NSTimer                    *lineTimer;
@property (strong , nonatomic) UIView                     *otherPlatformLoginView;
@property (nonatomic, strong ) NSString                   *str;
@property (nonatomic, assign) BOOL                        success;

@end

@implementation QCodeViewController

- (void)dealloc{
    if ([_lineTimer isValid]) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)viewWillDisappear:(BOOL)animated {

    if (self.success) {
        if (self.returnTextBlock != nil) {
            self.returnTextBlock(self.str);
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if (_session) {
        [_session startRunning ];
        if (_lineTimer) {
            [_lineTimer invalidate];
            _lineTimer = nil;
        }
        _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        _lineLabel.hidden = NO;
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    move = 1.0;
    //扫描区域宽、高大小
    float QRWIDTH = 200/320.0*SCREEN_W;
    
    //创建扫描区域框
    _qrView=[[UIImageView alloc]init];
    _qrView.bounds = CGRectMake(0, 0, QRWIDTH, QRWIDTH);
    _qrView.center = CGPointMake(SCREEN_W/2.0, SCREEN_H/2.0 - 80);
    _qrView.backgroundColor = [UIColor clearColor];
    _qrView.image = [UIImage imageNamed:@"扫描框"];
    [self.view addSubview:_qrView];
    
    _lineLabel = [[UIImageView alloc]initWithFrame:CGRectMake(_qrView.frame.origin.x+2.0, _qrView.frame.origin.y + 2.0, _qrView.frame.size.width - 4.0, 3.0)];
    _lineLabel.image = [UIImage imageNamed:@"扫描条"];
    [self.view addSubview:_lineLabel];
    
    
    //半透明背景
    UIView *qrBacView = [[UIView alloc]init];//上
    qrBacView.frame = CGRectMake(0, 0, SCREEN_W, _qrView.frame.origin.y );
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    qrBacView = [[UIView alloc]init];//左
    qrBacView.frame = CGRectMake(0, _qrView.frame.origin.y, _qrView.frame.origin.x,SCREEN_H - _qrView.frame.origin.y);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    qrBacView = [[UIView alloc]init];//下
    qrBacView.frame = CGRectMake(_qrView.frame.origin.x, _qrView.frame.origin.y + QRWIDTH, SCREEN_W - _qrView.frame.origin.x, SCREEN_H - _qrView.frame.origin.y - QRWIDTH);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    qrBacView = [[UIView alloc]init];//右
    qrBacView.frame = CGRectMake(_qrView.frame.origin.x + QRWIDTH, _qrView.frame.origin.y, SCREEN_W - _qrView.frame.origin.x - QRWIDTH, QRWIDTH);
    qrBacView.backgroundColor = [UIColor blackColor];
    qrBacView.alpha = 0.6;
    [self.view addSubview:qrBacView];
    
    
    [self canUseSystemCamera];
    //[self createOtherPlatformLoginView];
    
    
}

-(void)bindView {

    self.title = @"扫描";
    self.btnRight.hidden = NO;
}


//创建扫描
- (void)createQRView{
    
    //扫描区域宽、高大小
    float QRWIDTH = 200/320.0*SCREEN_W;
    
    //手电筒开关
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(_qrView.frame.origin.x + QRWIDTH/2.0 - 20, _qrView.frame.origin.y + _qrView.frame.size.height + 20, 40, 40);
    btn.selected = NO;
    //    [btn setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    //    [btn setTitle:@"关闭闪光灯" forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:@"ocr_flash-off.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ocr_flash-on.png"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [ _output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue ()];
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]){
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output]){
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //设置扫描有效区域(上、左、下、右)
    [_output setRectOfInterest : CGRectMake (( _qrView.frame.origin.y )/ SCREEN_H ,(_qrView.frame.origin.x)/ SCREEN_W , QRWIDTH / SCREEN_H , QRWIDTH / SCREEN_W )];
    // Preview
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    _preview.frame = self.view.layer.bounds ;
    [self.view.layer insertSublayer:_preview atIndex:0];
    // Start
    [_session startRunning];
    
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
}

- (void)leftButtonHaveClick:(UIButton *)sender{
    if ([_lineTimer isValid]) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    [_device lockForConfiguration:nil];
    [_device setTorchMode:AVCaptureTorchModeOff];
    [_device unlockForConfiguration];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)moveLine{
    float upY = _qrView.frame.origin.y + _qrView.frame.size.height - 2.0 - 3.0;
    float y = _lineLabel.frame.origin.y;
    y = y+move;
    CGRect lineFrame=CGRectMake(_lineLabel.frame.origin.x, y, _qrView.frame.size.width - 4.0, 3.0);
    _lineLabel.frame = lineFrame;
    if (y < _qrView.frame.origin.y + 2.0 || y > upY) {
        move = -move;
    }
    
}


//扫描成功后的代理方法
- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
{
    [_session stopRunning];
    [SVProgressHUD showWithStatus:LOADING];

    NSString *stringValue;//扫描结果
    if ([metadataObjects count ] > 0 ){
        [NSThread sleepForTimeInterval:2];
        // 停止扫描
        [_session stopRunning];
        if ([_lineTimer isValid]) {
            [_lineTimer invalidate];
            _lineTimer = nil;
            _lineLabel.hidden = YES;
        }
        [[BaseTapSound shareTapSound]playSystemSound];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        stringValue = metadataObject. stringValue ;
        self.str = stringValue;
        [SVProgressHUD dismiss];
        self.success = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self startingQRCode];
}

- (void)openOrClose:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([sender isSelected]) {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device unlockForConfiguration];
    }else{
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    }
}


- (void)canUseSystemCamera{
    if (![BaseTapSound ifCanUseSystemCamera]) {
        _lineLabel.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此应用已被禁用系统相机" message:@"请在iPhone的 \"设置->隐私->相机\" 选项中,允许 \"中车司机端\" 访问你的相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        alert.tag = 100;
        [alert show];
    }else{
        _lineLabel.hidden = NO;
        [self createQRView];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startingQRCode{
    if (self.session) {
        [self.session startRunning ];
        if (self.lineTimer) {
            [self.lineTimer invalidate];
            self.lineTimer = nil;
        }
        self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];
        self.lineLabel.hidden = NO;
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
