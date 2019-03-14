//
//  CapacityDetailsViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//
#import "CapacityDetailsViewController.h"
#import "CapacityDetailsViewModel.h"


@interface ArticleView : UIView
@property (nonatomic, copy  ) NSString    * textL;
@property (nonatomic, copy  ) NSString    * textR;
@property (nonatomic, copy  ) NSString    * imageName;
@property (nonatomic, strong) UILabel     * labelL;
@property (nonatomic, strong) UILabel     * labelR;
@property (nonatomic, strong) UIImageView * img;
@end
@implementation ArticleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI {
    _labelL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame) * 0.35, CGRectGetHeight(self.frame))];
    _labelL.textAlignment = NSTextAlignmentRight;
    _labelL.textColor = APP_COLOR_GRAY_TEXT;
    [self addSubview:_labelL];
    
    _labelR = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_labelL.frame) + 10, _labelL.frame.origin.y, CGRectGetWidth(self.frame) - CGRectGetWidth(_labelL.frame) - 10, CGRectGetHeight(_labelL.frame))];
    [self addSubview:_labelR];
    
    int sideLength = 20;
    _img = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_labelL.frame) - sideLength,CGRectGetHeight(self.frame) / 2 - sideLength / 2, sideLength, sideLength)];
    _img.hidden = YES;
    [self addSubview:_img];
}

-(void)setTextL:(NSString *)textL {
    _textL = [NSString stringWithString:textL];
    _img.hidden = YES;
    _labelL.text = _textL;
}

-(void)setTextR:(NSString *)textR {
    _textR = [NSString stringWithString:textR];
    _labelR.numberOfLines = [_textR componentsSeparatedByString:@"\n"].count;
    int textHeight = 20;
    _labelR.frame = CGRectMake(CGRectGetMinX(_labelR.frame), CGRectGetMinY(_labelR.frame), CGRectGetWidth(_labelR.frame), CGRectGetHeight(_labelR.frame) + (_labelR.numberOfLines - 1) * textHeight);
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) + (_labelR.numberOfLines - 1) * textHeight);
    _labelR.text = _textR;
}

-(void)setImageName:(NSString *)imageName {
    _imageName = [NSString stringWithString:imageName];
    _img.image = [UIImage imageNamed:_imageName];
    _labelR.textColor = APP_COLOR_GRAY_TEXT;
    _img.hidden = NO;
}

@end

@interface CapacityDetailsViewController()<UIActionSheetDelegate>
@property (nonatomic, strong) NSMutableArray * articleTexts;
@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UIImageView * bgView;
@property (nonatomic, strong) UILabel * titleview;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * agreedBtn;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) CapacityModel * model;
@end

@implementation CapacityDetailsViewController

-(void)setCapacityID:(int)capacityID {
    _capacityID = capacityID;
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出售运力详情";
    self.btnLeft.hidden = NO;
    self.btnRight.hidden = NO;
}

- (void)loadData {
    WS(ws);
    [[[CapacityDetailsViewModel alloc]init]getCapacityDetailsWithPoolid:_capacityID callback:^(CapacityModel *info) {
        [ws.articleTexts removeAllObjects];
        ws.model = info;
        UserInfoModel * user = USER_INFO;
        if (ws.model.status == 1) {
            ws.titleview.text = [NSString stringWithFormat:@"待评估"];
        }else
        {
            ws.titleview.text = [NSString stringWithFormat:@"¥%d",ws.model.standardPrice + ws.model.awardPrice];
            [ws.articleTexts addObject:[NSString stringWithFormat:@"标准估价--灰色$$标准估价:¥%d",ws.model.standardPrice]];
            [ws.articleTexts addObject:[NSString stringWithFormat: @"星级---灰色$$星级奖励:¥%d",ws.model.awardPrice]];
        }
        [ws.articleTexts addObject:[NSString stringWithFormat:@"单号:$$%d",ws.model.ID]];
        switch (ws.model.status) {
            case 1:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"状态:$$待评估"]];
                break;
            case 2:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"状态:$$待确认"]];
                break;
            case 3:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"状态:$$未派单"]];
                break;
            case 4:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"状态:$$已派单"]];
                break;
            case 5:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"状态:$$待结算"]];
                break;
            case 6:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"状态:$$已结算"]];
                break;
            default:
                break;
        }
        [ws.articleTexts addObject:[NSString stringWithFormat:@"下单时间:$$%@",[ws.model.createTime componentsSeparatedByString:@" "][0]]];
        switch (ws.model.type) {
            case 1:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"出售类型:$$按时间段"]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"起止日期:$$%@至\n%@",[ws.model.dispatchStartTime componentsSeparatedByString:@" "][0],[ws.model.dispatchEndTime componentsSeparatedByString:@" "][0]]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"车牌号:$$%@",user.vehicle_code]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"车辆类型:$$%@",user.vehicle_code]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"优选路线:$$%@",[ws.model.line stringByReplacingOccurrencesOfString:@"," withString:@"\n"]]];
                break;
            case 2:
                [ws.articleTexts addObject:[NSString stringWithFormat:@"出售类型:$$按线路"]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"出发时间:$$%@(最早)",[ws.model.dispatchStartTime componentsSeparatedByString:@" "][0]]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"出发时间:$$%@(最晚)",[ws.model.dispatchEndTime componentsSeparatedByString:@" "][0]]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"车牌号:$$%@",user.vehicle_code]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"车辆类型:$$%@",user.vehicle_code]];
                [ws.articleTexts addObject:[NSString stringWithFormat:@"线路:$$%@-%@",ws.model.startPosition,ws.model.endPosition]];
                break;
            default:
                break;
        }
        [ws bindView];
    }];
}

-(void)bindView {
    self.bgScrollView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 60);
    [self.view addSubview:self.bgScrollView];
    
    self.titleview.frame = CGRectMake(0, 30, SCREEN_W - 30, 60);
    [self.bgView addSubview:self.titleview];
    
    if (self.model.status == 2) {
        self.agreedBtn.hidden = NO;
        self.cancelBtn.hidden = NO;
    }
    else
    {
        self.agreedBtn.hidden = YES;
        self.cancelBtn.hidden = YES;

    }
    
    UIView * ve1 = self.titleview;
    ArticleView * ve2;
    NSArray * arr;
    if (self.model.status == 1) {
        self.titleview.textColor = [UIColor blackColor];
        UIView * ve = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(ve1.frame),CGRectGetMaxY(ve1.frame) + 10,CGRectGetWidth(ve1.frame), 30)];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(ve.frame), 2)];
        line.backgroundColor = APP_COLOR_GRAY_LINE;
        [ve addSubview:line];
        [self.bgView addSubview:ve];
        
        ve1 = ve;
        for (int i = 0; i < self.articleTexts.count; i ++)
        {
            ve2 = [[ArticleView alloc]initWithFrame:CGRectMake(CGRectGetMinX(ve1.frame),CGRectGetMaxY(ve1.frame) + 10,CGRectGetWidth(ve1.frame), 30)];
            arr = [self.articleTexts[i] componentsSeparatedByString:@"$$"];
            ve2.textL = arr[0];
            ve2.textR = arr[1];
            [self.bgView addSubview:ve2];
            ve1 = ve2;
        }
    }
    else
    {
        for (int i = 0; i < self.articleTexts.count; i ++)
        {
            ve2 = [[ArticleView alloc]initWithFrame:CGRectMake(CGRectGetMinX(ve1.frame),CGRectGetMaxY(ve1.frame) + 10,CGRectGetWidth(ve1.frame), 30)];
            arr = [self.articleTexts[i] componentsSeparatedByString:@"$$"];
            if ([arr[0] rangeOfString:@":"].length)
            {
                ve2.textL = arr[0];
                ve2.textR = arr[1];
            }
            else
            {
                ve2.imageName = arr[0];
                ve2.textR = arr[1];
            }
            [self.bgView addSubview:ve2];
            ve1 = ve2;
            
            if (i == 1)
            {
                UIView * ve = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(ve1.frame),CGRectGetMaxY(ve1.frame) + 10,CGRectGetWidth(ve1.frame), CGRectGetHeight(ve1.frame))];
                
                UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(ve.frame), 2)];
                line.backgroundColor = APP_COLOR_GRAY_LINE;
                [ve addSubview:line];
                [self.bgView addSubview:ve];
                
                ve1 = ve;
            }
        }

    }
    self.bgView.frame = CGRectMake(15, 20, SCREEN_W - 30,  MAX(CGRectGetHeight(self.bgScrollView.frame),CGRectGetMaxY(ve2.frame)) + 20);
    [self.bgScrollView addSubview:self.bgView];
    
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_W,CGRectGetMaxY(self.bgView.frame));
    self.bottomView.frame = CGRectMake(0, SCREEN_H - 64 - 60,  SCREEN_W, 60);
    [self.view addSubview:self.bottomView];
    
    self.cancelBtn.frame = CGRectMake(20, 10, SCREEN_W / 2 - 40, 40);
    [self.bottomView addSubview:self.cancelBtn];
    
    self.agreedBtn.frame = CGRectMake(SCREEN_W / 2 + 20, 10, SCREEN_W / 2 - 40, 40);
    [self.bottomView addSubview:self.agreedBtn];
    
}

- (void)bindAction {
    WS(ws);
    [[self.agreedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws agreedBtnActon];
    }];
    [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws cancelBtnActon];
    }];
}

-(void)bindModel {
}

- (NSMutableArray *)articleTexts {
    if (!_articleTexts) {
        _articleTexts = [NSMutableArray new];
    }
    return _articleTexts;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [UIScrollView new];
        _bgScrollView.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _bgScrollView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"背景 (2)"];
        imageView.userInteractionEnabled = YES;
        _bgView = imageView;
    }
    return _bgView;
}

- (UILabel *)titleview {
    if (!_titleview) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_ORANGR;
        label.font = [UIFont systemFontOfSize:30.0f];
        label.textAlignment = NSTextAlignmentCenter;
        _titleview = label;
    }
    return _titleview;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = APP_COLOR_GRAY_LINE;
    }
    return _bottomView;
}

- (UIButton *)agreedBtn {
    if (!_agreedBtn) {
        UIButton *button = [[UIButton alloc]init];
          [button setBackgroundImage:[UIImage  getImageWithColor:APP_COLOR_ORANGR2 andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button setTitle:@"同意" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _agreedBtn = button;
    }
    return _agreedBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"放弃" forState:UIControlStateNormal];
          [button setBackgroundImage:[UIImage  getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = APP_COLOR_BLUE.CGColor;
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _cancelBtn = button;
    }
    return _cancelBtn;
}

- (void)agreedBtnActon {
    UserInfoModel * user = USER_INFO;
    WS(ws);
    [[[CapacityDetailsViewModel alloc]init]agreeCapacityWithUsername:user.iden WithPoolid:_model.ID WithType:1 WithRejectReason:[NSString string] callback:^(BOOL info) {
        if (info)
        {
            [ws.capacityDetailsDelegate agreeORdisagreeCapacityDetails];
            [ws onBackAction];
        }
    }];
}

- (void)cancelBtnActon {
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"放弃理由" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"价格不合适",@"改主意了",@"下错单了",@"其他", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString * title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"取消"]) {
        return ;
    }
    UserInfoModel * user = USER_INFO;
    WS(ws);
    [[[CapacityDetailsViewModel alloc]init]agreeCapacityWithUsername:user.iden WithPoolid:_model.ID WithType:2 WithRejectReason:title callback:^(BOOL info) {
        if (info == NO)
        {
            [ws.capacityDetailsDelegate agreeORdisagreeCapacityDetails];
            [ws onBackAction];
        }
    }];
}
@end
