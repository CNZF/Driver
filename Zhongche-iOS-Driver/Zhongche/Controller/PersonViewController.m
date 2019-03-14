//
//  PersonViewController.m
//  Zhongche
//
//  Created by lxy on 16/7/15.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "PersonViewController.h"
#import "PreferenceRouteViewController.h"
#import "ResetPasswordViewController.h"
#import "UserHeadTableViewCell.h"
#import "UserInfoModel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UserInfoViewModel.h"
#import "ZCEWCodeViewController.h"
#import "CarInfoModel.h"
#import "ZCChangePhoneViewController.h"
#import "ZCCityListViewController.h"

@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,ZCCityListViewControllerDelagate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UITableView   *tvList;
@property (nonatomic, strong) NSArray       *arrModel;
@property (nonatomic, strong) UserInfoModel *info;
@property (nonatomic, strong) UIImage       *imHead;
@property (nonatomic, strong) UIView        *viFoot;
@property (nonatomic, strong) UIButton      *btnLogout;

@end

@implementation PersonViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UserInfoViewModel *vm = [UserInfoViewModel new];

    WS(ws);
    [vm getUserInfoWithUserId:^(UserInfoModel *userInfo) {

        [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
        ws.info = USER_INFO;
        [ws.tvList reloadData];


        
    }];

    [vm getBindCarListWithUserId:self.info.iden callback:^(CarInfoModel *info) {

        [NSKeyedArchiver archiveRootObject:info toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];

    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
}

- (void)bindView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.btnRight.hidden = NO;
    self.title = @"个人信息";
    
    self.tvList.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 44);
    [self.view addSubview:self.tvList];

    self.viFoot.frame = CGRectMake(0, 0, SCREEN_W, 120);
    self.tvList.tableFooterView = self.viFoot;

    self.btnLogout.frame = CGRectMake(0, 10, SCREEN_W, 50);
    [self.viFoot addSubview:self.btnLogout];

    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [[self.view viewWithTag:1024] setTransform:CGAffineTransformRotate([self.view viewWithTag:1024].transform,M_PI)];
    } completion:^(BOOL finished){


    }];
}

- (void)bindModel {
//
//    //检测信号量
//
//    [RACObserve(self, arrModel) subscribeNext:^(id x) {
////        [ws.imagePlayer reloadData:ws.pageNum];
//    }];
////

    self.arrModel = @[@[@"头像",@"姓名",@"联系方式",@"基地",@"车牌号",@"我的二维码"],@[@"用户类型",@"所属公司"],@[@"修改登录密码"]];
    self.info = USER_INFO;
}

- (void)onBackAction {

    [self.navigationController popViewControllerAnimated:YES];


}

- (void)LogoutAction{
    
    UserInfoModel *us = nil;
    [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];

    CarInfoModel *car = nil;

     [NSKeyedArchiver archiveRootObject:car toFile:[MyFilePlist documentFilePathStr:@"CarInfo.archive"]];
    [[Toast shareToast]makeText:@"注销成功" aDuration:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)changeHeadImg {

    UserInfoModel *us = USER_INFO;
    UserInfoViewModel *vm = [UserInfoViewModel new];
    WS(ws);
    [vm upUserAvatarwithId:us.iden withAvatar:self.imHead callback:^(NSString *st) {


        if (st) {
            [[Toast shareToast]makeText:@"上传成功" aDuration:1];
            UserInfoViewModel *vm = [UserInfoViewModel new];
            [vm getUserInfoWithUserId:^(UserInfoModel *userInfo) {

                 self.info = userInfo;

                [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
                 [ws.tvList reloadData];
                
            }];

        }
    }];
    
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

/**
 *
 *  @param tableView delegate
 *
 *  @return
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.arrModel objectAtIndex:section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        static NSString *CellIdentifier = @"Celled";
        
        UserHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserHeadTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];


        NSString *url;

        if (_info.icon) {
            url = [NSString stringWithFormat:@"%@%@",BASEIMGURL,[_info.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        }
        cell.ivHead.layer.cornerRadius = cell.ivHead.frame.size.width / 2;
        cell.ivHead.layer.masksToBounds = YES;

        [cell.ivHead sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


        return cell;
        
    }else  if (indexPath.section == 0 && indexPath.row == 5) {

        static NSString *CellIdentifier = @"Celled";

        UserHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"UserHeadTableViewCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//           

            cell.ivHead.image = [UIImage imageNamed:@"erweima1"];

            cell.ivHead.size = CGSizeMake(20, 20);


            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.lbHead.text = @"二维码";



        }
        return cell;
        
    }
 
    else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
        }
        
        cell.textLabel.text = self.arrModel[indexPath.section][indexPath.row];

        
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.detailTextLabel.text = _info.phone;
            if (_info.real_name) {

                 cell.detailTextLabel.text = _info.real_name;
            }

        }
        if (indexPath.section == 0 && indexPath.row == 2) {
            cell.detailTextLabel.text = _info.phone;
        }
        if (indexPath.section == 0 && indexPath.row == 3) {
            cell.detailTextLabel.text = _info.region_name;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0 && indexPath.row == 4) {
            CarInfoModel *model = CAR_INFO;
            cell.detailTextLabel.text = model.code;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 0 && indexPath.row == 5) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.section == 1 && indexPath.row == 0) {

            //1 认证承运商司机 2 签约承运商司机 3 注册用户 4 实名用户

            int typ = [_info.auth_type intValue];

            switch (typ) {
                case 1:
                    cell.detailTextLabel.text = @"认证承运商司机";
                    break;
                case 2:
                    cell.detailTextLabel.text = @"签约承运商司机";
                    break;
                case 3:
                    cell.detailTextLabel.text = @"注册用户";
                    break;
                case 4:
                    cell.detailTextLabel.text = @"实名用户";
                    break;

                default:
                    break;
            }

        }
        
        if (indexPath.section == 1 && indexPath.row == 1) {
            cell.detailTextLabel.text =  _info.organization_name;
        }
        
        if (indexPath.section == 1&& indexPath.row == 2) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",_info.userPoints];
        }


        if (indexPath.section == 2) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             cell.detailTextLabel.text = @"";
        }
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        ResetPasswordViewController *vc = [ResetPasswordViewController new];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 3 && indexPath.section == 0) {
        ZCCityListViewController * vC = [[ZCCityListViewController alloc]init];
        vC.type = @"user";
        vC.getCityDelagate = self;
        [self.navigationController pushViewController:vC animated:YES] ;
    }
//    if (indexPath.row == 0 && indexPath.section == 2) {
//        PreferenceRouteViewController * vc  = [[PreferenceRouteViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }

    if (indexPath.row == 2 && indexPath.section == 0) {
        ZCChangePhoneViewController * vc  = [[ZCChangePhoneViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    if (indexPath.row == 0 && indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }

    if (indexPath.section == 0 && indexPath.row == 5) {

        ZCEWCodeViewController *vc = [ZCEWCodeViewController new];
        vc.message = [NSString stringWithFormat:@"%i",self.info.iden];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
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
    self.imHead = image;
    [self changeHeadImg];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        self.imHead = info[UIImagePickerControllerOriginalImage];
        [self changeHeadImg];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//获取基地城市代理
- (void)getCityModel:(CityModel *)cityModel{

    UserInfoViewModel *vm = [UserInfoViewModel new];

    WS(ws);

    [vm resetRegionWith:cityModel.startPositionCode callback:^(NSString *st) {
        ws.info.region_name = cityModel.startPosition;
        [ws.tvList reloadData];
    }];
}
/**
 *  getting
 *
 */
- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView    = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
        tableView.delegate        = self;
        tableView.dataSource      = self;

        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;//分割线
        _tvList                   = tableView;
    }
    return _tvList;
}

- (UIView *)viFoot {
    if (!_viFoot) {
        _viFoot = [UIView new];
        _viFoot.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _viFoot;
}

- (UIButton *)btnLogout {
    if (!_btnLogout) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_ORANGR2 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(LogoutAction) forControlEvents:UIControlEventTouchUpInside];
         [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];


        _btnLogout = button;
    }
    return _btnLogout;
}



@end