//
//  LeftMenuViewDemo.m
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//
#define ImageviewWidth    18
#define Frame_Width       self.frame.size.width//200

#import "LeftMenuViewDemo.h"
#import "UIView+Frame.h"
#import "LeftTableViewCell.h"
#import "UserInfoModel.h"
#import "MyFilePlist.h"
#import "UIImageView+WebCache.h"

@interface LeftMenuViewDemo ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *contentTableView;


@property (nonatomic, strong) UIButton    *btnHead;

@property (nonatomic, strong) UILabel     *lbFoot;

@property (nonatomic, strong) UIImageView *ivFoot;
@property (nonatomic, strong) UIButton    *btnShare;

@end

@implementation LeftMenuViewDemo

 
-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{
    
    _info = USER_INFO;

    //添加头部
    UIView *headerView     = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Frame_Width, 150)];
    [headerView setBackgroundColor:APP_COLOR_PURPLE1];

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 80, 80)];
    imageview.layer.cornerRadius = imageview.frame.size.width / 2;
    imageview.layer.masksToBounds = YES;
    if (_info.icon) {
        NSString *url = [NSString stringWithFormat:@"%@%@",BASEIMGURL,[_info.icon stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        _info.icon  = url;
    }

        [imageview sd_setImageWithURL:[NSURL URLWithString:_info.icon]placeholderImage:[UIImage imageNamed:@"head"]];



    [headerView addSubview:imageview];
    
    
   
    
    UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width + imageview.frame.origin.x * 2, imageview.frame.origin.y - 10, 130, imageview.frame.size.height)];

    [NameLabel setText:_info.phone];
    if (_info.real_name) {
        [NameLabel setText:_info.real_name];
    }

    NameLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:NameLabel];
    
    
    UIImageView *arrow     = [[UIImageView alloc]initWithFrame:CGRectMake(Frame_Width - 20, 63, 7, 15)];
    [arrow setImage:[UIImage imageNamed:@"arrowhead"]];
    [headerView addSubview:arrow];
    
//    /**
//     *  用户等级
//     */
//    [self levelViewWithLevel:_info.userPoints * 1.00/20];
//    self.vilevel.frame = CGRectMake(imageview.right + 17, imageview.bottom - 30, 200, 30);
//    [headerView addSubview:self.vilevel];

    
    self.btnHead = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Frame_Width, 150)];
    [self.btnHead addTarget:self action:@selector(HeadClickAction) forControlEvents:UIControlEventTouchUpInside];

    

    
    //中间tableview
    UITableView *contentTableView        = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom - 30, Frame_Width, SCREEN_H - 180)
                                                                       style:UITableViewStyleGrouped];
    contentTableView.scrollEnabled = NO;

    
    [contentTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    contentTableView.dataSource          = self;
    contentTableView.delegate            = self;
    contentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [contentTableView setBackgroundColor:APP_COLOR_PURPLE];
    contentTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    contentTableView.tableFooterView = [UIView new];
    self.contentTableView = contentTableView;
    [self addSubview:contentTableView];

    [self addSubview:headerView];

    [self addSubview:self.btnHead];

    self.lbFoot.frame = CGRectMake(40, SCREEN_H - 60, 100, 20);
    if (SCREEN_W <350) {
        self.lbFoot.frame = CGRectMake(30, SCREEN_H - 40, 100, 20);
    }
    [self addSubview:self.lbFoot];

    self.ivFoot.frame = CGRectMake(self.lbFoot.left + 10, self.lbFoot.top - 50, 40, 40);
    [self addSubview:self.ivFoot];

    self.btnShare.frame = CGRectMake(40, self.ivFoot.top, 100, 100);
    [self addSubview:self.btnShare];

   
    self.backgroundColor = APP_COLOR_PURPLE;
}

- (void)levelViewWithLevel:(float)level{
    
    self.vilevel = [UIView new];
    int x=0;
    int a = level;
    for (int i = 0; i<a; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star2"]];
        iv.frame = CGRectMake(x, 0, 15, 15);
        [self.vilevel addSubview:iv];
        
        x = x + 25;
    }
    
    if (level - a >0.5) {
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"半角星"]];
        iv.frame = CGRectMake(x , 0, 15, 15);
        [self.vilevel addSubview:iv];
        
        x = x + 25;
        level ++;
    }
    
    for (int j = level; j<5 ; j++) {
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star1"]];
        iv.frame = CGRectMake(x, 0, 15, 15);
        [self.vilevel addSubview:iv];
        
        x = x + 25;
    }
    
}

-(void)HeadClickAction{
    [self.customDelegate HeadClick];
}


- (void)ShareAction {

    [self.customDelegate ShareClick];

}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LeftTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = APP_COLOR_PURPLE;
    if (indexPath.row == 0) {
        cell.lb.text = @"钱包";
        cell.img.image = [UIImage imageNamed:@"wallet"];
    } else if (indexPath.row == 1) {
        cell.lb.text = @"车辆管理";
        cell.img.image = [UIImage imageNamed:@"carMenager"];
    } else if (indexPath.row == 2) {
        cell.lb.text = @"出售运力记录";
        cell.img.image = [UIImage imageNamed:@"sall"];
    } else if (indexPath.row == 3) {
        cell.lb.text = @"历史运单";
        cell.img.image = [UIImage imageNamed:@"sall"];
    } else if (indexPath.row == 4) {
        cell.lb.text = @"联系客服";
        cell.img.image = [UIImage imageNamed:@"phoneContact"];
    }else if (indexPath.row == 5) {
        cell.lb.text = @"关于";
        cell.img.image = [UIImage imageNamed:@"about"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]){
        [self.customDelegate LeftMenuViewClick:indexPath.row];
    }
    
}


- (UILabel *)lbFoot
{
    if (!_lbFoot) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = @"推荐有奖";

        _lbFoot = label;
    }
    return _lbFoot;
}


- (UIImageView *)ivFoot
{
    if (!_ivFoot) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"share"];


        _ivFoot = imageView;
    }
    return _ivFoot;
}

- (UIButton *)btnShare
{
    if (!_btnShare) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];


        _btnShare = button;
    }
    return _btnShare;
}


@end
