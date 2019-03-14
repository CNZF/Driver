//
//  PerfectCarInfomationViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/22.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PerfectCarInfomationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZCCarInfomationTableViewCell.h"
#import "UserInfoViewModel.h"
#import "ChooseCarViewController.h"
#import "CarImgInfo.h"
#import "UserInfoViewModel.h"
#import "WaitForCheckViewController.h"
#import "BoxInfoModel.h"
#import "CarInfoModel.h"

@interface PerfectCarInfomationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImagePickerController *_imagePickerController;
}
@property (nonatomic, strong) UITableView    *tvList;
@property (nonatomic, strong) NSString       *type;
@property (nonatomic, strong) NSString       *form;
@property (nonatomic, strong) NSArray        *arrBoxType;
@property (nonatomic, strong) UIView         *viFoot;
@property (nonatomic, strong) UILabel        *lbDrive;//行驶证
@property (nonatomic, strong) UILabel        *lbDriverAndCar;//本人与汽车合影
@property (nonatomic, strong) UILabel        *lbLendCar;//贷车营运证
@property (nonatomic, strong) UIImageView    *ivDrive;//行驶证
@property (nonatomic, strong) UIImageView    *ivDriverAndCar;//本人与汽车合影
@property (nonatomic, strong) UIImageView    *ivLendCar;//贷车营运证
@property (nonatomic, strong) UIButton       *btnDrive;
@property (nonatomic, strong) UIButton       *btnDriverAndCar;
@property (nonatomic, strong) UIButton       *btnLendCar;
@property (nonatomic, strong) UIImage        *imDrive;
@property (nonatomic, strong) UIImage        *imDriverAndCar;
@property (nonatomic, strong) UIImage        *imLendCar;

@property (nonatomic, strong) UILabel        *lbMessage;

@property (nonatomic, strong) NSDictionary   *dicInfo;

@property (nonatomic, strong) NSString       *stTyep;
@property (nonatomic, strong) NSString       *stTyepCode;

@property (nonatomic, strong) NSString       *stForm;
@property (nonatomic, strong) NSString       *stFormCode;
@property (nonatomic, strong) NSString       *stBox;
@property (nonatomic, strong) UIImageView    *ivCurrent;

@property (nonatomic, strong) YMTextView     *carNumTextView;
@property (nonatomic, strong) YMTextView     *carLenthTextView;
@property (nonatomic, strong) YMTextView     *carWeightTextView;
@property (nonatomic, strong) NSMutableArray *boxIds;

@property (nonatomic, strong) UIView         *viBottom;

@property (nonatomic, strong) UIButton       *btnNext;

@property (nonatomic, strong) CarInfoModel   *carInfo;

@end

@implementation PerfectCarInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
}


- (void)bindView{

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.title = @"添加新车";


    if ([self.tvList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tvList setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }

    if ([self.tvList respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tvList setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }


    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 75);
    [self.view addSubview:self.tvList];


    [self viFootSet];

    self.viFoot.frame = CGRectMake(0, 0, SCREEN_W,self.ivLendCar.bottom + 100);
    self.tvList.tableFooterView = self.viFoot;

    self.viBottom.frame = CGRectMake(0, SCREEN_H - 75 - 64, SCREEN_W, 80);
    [self.view addSubview:self.viBottom];

    self.btnNext.frame = CGRectMake(20, 15, SCREEN_W - 40, 44);
    [self.viBottom addSubview:self.btnNext];



}

- (void) viFootSet {



    UILabel *lbLine= [UILabel new];
    lbLine.frame = CGRectMake(0, 0, SCREEN_W, 20);
    lbLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.viFoot addSubview:lbLine];

    self.lbDrive.frame = CGRectMake(20, 30, SCREEN_W - 40, 40 );
    [self.viFoot addSubview:self.lbDrive];

    self.ivDrive.frame = CGRectMake(20, self.lbDrive.bottom , 240, 160);
    [self.viFoot addSubview:self.ivDrive];

    self.btnDrive.frame = CGRectMake(20, self.lbDrive.bottom , 240, 160);
    [self.viFoot addSubview:self.btnDrive];

    self.lbDriverAndCar.frame = CGRectMake(20, self.ivDrive.bottom + 10, SCREEN_W - 40, 40 );
    [self.viFoot addSubview:self.lbDriverAndCar];

    self.lbMessage.frame = CGRectMake(80, self.ivDrive.bottom + 10, SCREEN_W - 50, 40);
    [self.viFoot addSubview:self.lbMessage];

    self.ivDriverAndCar.frame = CGRectMake(20, self.lbDriverAndCar.bottom ,  240, 160);
    [self.viFoot addSubview:self.ivDriverAndCar];

    self.btnDriverAndCar.frame = CGRectMake(20, self.lbDriverAndCar.bottom , 240, 160);
    [self.viFoot addSubview:self.btnDriverAndCar];



    self.lbLendCar.frame = CGRectMake(20, self.ivDriverAndCar.bottom + 10, SCREEN_W - 40, 40 );
    [self.viFoot addSubview:self.lbLendCar];

    self.ivLendCar.frame = CGRectMake(20, self.lbLendCar.bottom , 240, 160);
    [self.viFoot addSubview:self.ivLendCar];

    self.btnLendCar.frame = CGRectMake(20, self.lbLendCar.bottom , 240, 160);
    [self.viFoot addSubview:self.btnLendCar];




}

-(void)bindModel {

    UserInfoViewModel *vm = [UserInfoViewModel new];
    WS(ws);
    [vm getCarMessagecallback:^(NSDictionary *dic) {
        
        ws.dicInfo  =  dic;
    }];

    self.boxIds = [NSMutableArray array];


}

- (void)chooseImage:(UIButton *)btn {


    [self.view endEditing:YES];

    if (btn.tag == 11) {
        self.ivCurrent = self.ivDrive;
    }
    if (btn.tag == 12) {
        self.ivCurrent = self.ivDriverAndCar;
    }
    if (btn.tag == 13) {
        self.ivCurrent = self.ivLendCar;
    }

    self.ivCurrent.tag = btn.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];


}
- (void)imgSet{
    if (self.ivCurrent.tag ==11) {
        self.imDrive = self.ivCurrent.image;
    }
    if (self.ivCurrent.tag ==12) {
        self.imDriverAndCar = self.ivCurrent.image;
    }
    if (self.ivCurrent.tag ==13) {
        self.imLendCar = self.ivCurrent.image;
    }

}

- (void)nextAction {

    CarImgInfo *info = [CarImgInfo new];
    info.carlicensefront = self.imDrive;
    info.groupphoto = self.imDriverAndCar;
    info.truckoperator = self.imLendCar;

    UserInfoViewModel *vm = [UserInfoViewModel new];
    if ([self.carNumTextView.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"车牌号不能为空" aDuration:1];
    }else if (!self.stTyep){

        [[Toast shareToast]makeText:@"车辆类型未选择" aDuration:1];

    }else if (!self.stForm){

        [[Toast shareToast]makeText:@"拖拽形式未选择" aDuration:1];
        
    }else if (!self.stBox){

        [[Toast shareToast]makeText:@"箱型未选择" aDuration:1];
        
    }else if ([self.carLenthTextView.text isEqualToString:@""]){

        [[Toast shareToast]makeText:@"车长未填写" aDuration:1];

    }else if ([self.carWeightTextView.text isEqualToString:@""]){

        [[Toast shareToast]makeText:@"车重未填写" aDuration:1];

    }else{


        self.carInfo = [CarInfoModel new];
        self.carInfo.code = self.carNumTextView.text;
        self.carInfo.vehicle_type = self.stTyepCode;
        self.carInfo.formCode = self.stFormCode;
        self.carInfo.boxType = self.boxIds;
        self.carInfo.carWeight = self.carWeightTextView.text;
        self.carInfo.carLenth = self.carLenthTextView.text;

        [vm perfectCarInformationWithCar:self.carInfo WithUserImgInfo:info callback:^(NSString *st) {


            WS(ws);
            
        if ([st isEqualToString:@"成功"]) {
            
            [ws.navigationController popViewControllerAnimated:YES];
            
          }
        }];

    }
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;


    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
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


/**
 *
 *  @param tableView delegate
 *
 *  @return
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        NSString *temp = nil;
        int num = 0;
        for(int i =0; i < [self.stBox length]; i++)
        {
            temp = [self.stBox substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@","]) {

                num ++;

            }
        }
        if (num>0) {
            return 20 + num * 30;
        }

    }

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZCCarInfomationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ZCCarInfomationTableViewCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.lbTitle.text = @"车牌号";
        cell.textView.editable = YES;
        cell.lb.hidden = YES;
        self.carNumTextView = cell.textView;
        cell.textView.placeholder = @"请输入您的车牌号";

    }

    if (indexPath.row == 1) {
        cell.lbTitle.text = @"车辆类型";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textView.hidden = YES;
        if (self.stTyep) {
            NSArray *arrInfo = self.dicInfo[@"truckTypeList"];
            int index = [self.stTyep intValue];
            CarInfoModel *info = [arrInfo objectAtIndex:index];
            cell.lb.text =info.name;
            self.stTyepCode = info.code;
            cell.lb.textColor = [UIColor blackColor];
        }

    }

    if (indexPath.row == 2) {
        cell.lbTitle.text = @"拖挂形式";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textView.hidden = YES;
        if (self.stForm) {
            NSArray *arrInfo = self.dicInfo[@"trainlerTypeList"];
            int index = [self.stForm intValue];
            CarInfoModel *info = [arrInfo objectAtIndex:index];
            cell.lb.text =info.name;
            self.stFormCode = info.code;
            cell.lb.textColor = [UIColor blackColor];
        }

    }

    if (indexPath.row == 3) {
        cell.lbTitle.text = @"箱型箱类";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textView.hidden = YES;
        if (self.stBox) {
            NSString *temp = nil;
            int num = 0;
            for(int i =0; i < [self.stBox length]; i++)
            {
                temp = [self.stBox substringWithRange:NSMakeRange(i, 1)];
                if ([temp isEqualToString:@","]) {

                    num ++;

                }
            }
            if (num>0) {
                cell.lb.frame = CGRectMake(cell.lbTitle.right + 15, 10, 200, 20 + 30*num);
            }

            NSArray * arrIndex = [self.stBox componentsSeparatedByString:@","];
            NSString *st = @"";
            for (int i =0; i< arrIndex.count -1; i++) {
                NSString *index = [arrIndex objectAtIndex:i];
                int indexNum = [index intValue];
                NSArray *arrInfo = self.dicInfo[@"containerTypeList"];
                BoxInfoModel *info = [arrInfo objectAtIndex:indexNum];
                st = [NSString stringWithFormat:@"%@%@, \n",st,info.name];
                [self.boxIds addObject:[NSString stringWithFormat:@"%i",info.iden]];
            }

            cell.lb.text =st;
            cell.lb.numberOfLines = 0;
            cell.lb.textColor = [UIColor blackColor];
        }

    }

    if (indexPath.row == 4) {
        cell.lbTitle.text = @"车长";
        cell.textView.editable = YES;
        cell.lb.hidden = YES;
        self.carLenthTextView = cell.textView;
        cell.textView.placeholder = @"请输入车长(单位米)";

    }

    if (indexPath.row == 5) {
        cell.lbTitle.text = @"车重";
        cell.textView.editable = YES;
        cell.lb.hidden = YES;
        self.carWeightTextView = cell.textView;
        cell.textView.placeholder = @"请输入车重(单位吨)";

    }



//    NSString *a = @"ddnjinkdnkdn\njdijdi";
//    NSString *b =[a stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//    cell.textView.text = b;
    return cell;



}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 2) {

        NSArray *arrInfo = self.dicInfo[@"trainlerTypeList"];
        ChooseCarViewController *vc = [ChooseCarViewController new];
        vc.title = @"拖挂形式";
        vc.arrInfo = arrInfo;
        [self.navigationController pushViewController:vc animated:YES];
        WS(ws);
        [vc returnText:^(NSString *showText) {

            if(showText){

                ws.stForm = showText;
                [ws.tvList reloadData];

            }

        }];

    }

    if (indexPath.row == 1) {

        NSArray *arrInfo = self.dicInfo[@"truckTypeList"];
        ChooseCarViewController *vc = [ChooseCarViewController new];
        vc.title = @"车辆类型";
        vc.arrInfo = arrInfo;
        [self.navigationController pushViewController:vc animated:YES];
        WS(ws);
        [vc returnText:^(NSString *showText) {

            if(showText){

                ws.stTyep = showText;
                [ws.tvList reloadData];
            }

        }];
        
    }

    if (indexPath.row == 3) {

        NSArray *arrInfo = self.dicInfo[@"containerTypeList"];
        ChooseCarViewController *vc = [ChooseCarViewController new];
        vc.title = @"箱型箱类";
        vc.arrInfo = arrInfo;
        [self.navigationController pushViewController:vc animated:YES];
        WS(ws);
        [vc returnText:^(NSString *showText) {

            if(showText){

               ws.stBox = showText;
               [ws.tvList reloadData];

            }

        }];

    }




}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/**
 *  getting
 *
 */

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;

        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
        [tableView registerClass:[ZCCarInfomationTableViewCell class] forCellReuseIdentifier:@"ZCCarInfomationTableViewCell"];


        _tvList = tableView;
    }
    return _tvList;
}

- (UIView *)viFoot {
    if (!_viFoot) {
        _viFoot = [UIView new];

    }
    return _viFoot;
}

- (UILabel *)lbDrive{
    if (!_lbDrive) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"车辆行驶证照片";

        _lbDrive = label;
    }
    return _lbDrive;
}

- (UILabel *)lbDriverAndCar{
    if (!_lbDriverAndCar) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = @"本人与车辆合影";


        _lbDriverAndCar = label;
    }
    return _lbDriverAndCar;
}

- (UILabel *)lbLendCar{
    if (!_lbLendCar) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];

        label.text = @"货车营业证";

        _lbLendCar = label;
    }
    return _lbLendCar;
}

- (UIImageView *)ivDrive{
    if (!_ivDrive) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;


        _ivDrive = imageView;
    }
    return _ivDrive;
}

- (UIImageView *)ivDriverAndCar{
    if (!_ivDriverAndCar) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;
        _ivDriverAndCar = imageView;
    }
    return _ivDriverAndCar;
}

- (UIImageView *)ivLendCar{
    if (!_ivLendCar) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"photo"];
        imageView.backgroundColor = APP_COLOR_PHOTOGRAY;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5;

        _ivLendCar = imageView;
    }
    return _ivLendCar;
}

- (UILabel *)lbMessage{
    if (!_lbMessage) {
        UILabel* label = [[UILabel alloc]init];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12.0f];

        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"  (能够看清车牌号和人脸)";

        _lbMessage = label;
    }
    return _lbMessage;
}

- (UIButton *)btnNext {
    if (!_btnNext) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        [button addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];


        _btnNext = button;
    }
    return _btnNext;
}

- (UIButton *)btnDrive {
    if (!_btnDrive) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

        button.tag = 11;

        _btnDrive = button;
    }
    return _btnDrive;
}

- (UIButton *)btnDriverAndCar{
    if (!_btnDriverAndCar) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

        button.tag = 12;

        _btnDriverAndCar = button;
    }
    return _btnDriverAndCar;
}

- (UIButton *)btnLendCar{
    if (!_btnLendCar) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

        button.tag = 13;

        _btnLendCar = button;
    }
    return _btnLendCar;
}

- (UIView *)viBottom{
    if (!_viBottom) {
        _viBottom = [UIView new];
        _viBottom.backgroundColor = [UIColor whiteColor];
        _viBottom.layer.shadowOffset =  CGSizeMake(1, 1);
        _viBottom.layer.shadowOpacity = 0.5;
        _viBottom.layer.shadowColor =  [UIColor grayColor].CGColor;

    }
    return _viBottom;
}


@end
