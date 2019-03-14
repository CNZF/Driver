//
//  ZCGuidePageView.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCGuidePageView.h"
#define VIEWKEY 1024
#define ANCHORPOINTCOORDINATECONVERSION(view) CGRectMake(view.frame.origin.x, view.frame.origin.y + 0.5 * view.frame.size.height, view.frame.size.width, view.frame.size.height)
@interface ZCGuidePageView()<UIScrollViewAccessibilityDelegate>
@property (nonatomic,assign) float        coefficientX;
@property (nonatomic,assign) float        coefficientY;
@property (nonatomic,assign) int          currentPage;
@property (nonatomic,strong) UIScrollView * scrollview;
@property (nonatomic,strong) UIView       * pageView1;
@property (nonatomic,strong) UIView       * pageView2;
@property (nonatomic,strong) UIView       * pageView3;
@property (nonatomic,strong) UIView       * pageView4;
@end

@implementation ZCGuidePageView
/**
 *  初始化
 *
 *  @return
 */
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initializeCoefficient];
        [self creatUI];
    }
    return self;
}
/**
 *  初始化页面相关
 */
- (void)initializeCoefficient
{
    self.frame = [UIScreen mainScreen].bounds;
    _coefficientX = self.frame.size.width / 720.0;
    _coefficientY = self.frame.size.height / 1280.0;
    _currentPage = 1;
}
/**
 *  绘制引导页UI
 */
- (void)creatUI
{
    /**
     引导页最底层 scrollview
     */
    _scrollview = [[UIScrollView alloc]initWithFrame:self.frame];
    _scrollview.delegate = self;
    [self addSubview:_scrollview];
    _scrollview.bounces = NO;
    _scrollview.contentSize = CGSizeMake(4 * self.frame.size.width, self.frame.size.height);
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.pagingEnabled = YES;
    CGPoint point = {0,0};
    _scrollview.contentOffset = point;
    
    /**
     页面一
     */
    _pageView1 = [[UIView alloc]initWithFrame:self.frame];
    _pageView1.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:212 / 255.0 blue:91 / 255.0 alpha:1];
    UIImageView * bigImage_01 = [[UIImageView alloc]initWithFrame:CGRectMake(62*_coefficientX,246*_coefficientY,569*_coefficientX,522*_coefficientY)];
    bigImage_01.image = [UIImage imageNamed:@"大图_01.png"];
    [_pageView1 addSubview:bigImage_01];
    UIImageView * airBubbles_01 = [[UIImageView alloc]initWithFrame:CGRectMake(200*_coefficientX,270*_coefficientY,138*_coefficientX,181*_coefficientY)];
    airBubbles_01.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_01.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_01);
    airBubbles_01.tag = 1 + VIEWKEY;
    airBubbles_01.image = [UIImage imageNamed:@"气泡_01_01.png"];
    [_pageView1 addSubview:airBubbles_01];
    UIImageView * airBubbles_02 = [[UIImageView alloc]initWithFrame:CGRectMake(419*_coefficientX,244*_coefficientY,208*_coefficientX,274*_coefficientY)];
    airBubbles_02.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_02.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_02);
    airBubbles_02.tag = 2 + VIEWKEY;
    airBubbles_02.image = [UIImage imageNamed:@"气泡_01_02.png"];
    [_pageView1 addSubview:airBubbles_02];
    UIImageView * airBubbles_03 = [[UIImageView alloc]initWithFrame:CGRectMake(80*_coefficientX,530*_coefficientY,112*_coefficientX,148*_coefficientY)];
    airBubbles_03.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_03.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_03);
    airBubbles_03.tag = 3 + VIEWKEY;
    airBubbles_03.image = [UIImage imageNamed:@"气泡_01_03.png"];
    [_pageView1 addSubview:airBubbles_03];
    UIImageView * textView_01 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,850*_coefficientY,720*_coefficientX,211*_coefficientY)];
    textView_01.image = [UIImage imageNamed:@"文字_01.png"];
    [_pageView1 addSubview:textView_01];
    UIImageView * cloudView_01 = [[UIImageView alloc]initWithFrame:CGRectMake(518*_coefficientX,128*_coefficientY,93* 1.3*_coefficientX,64* 1.3*_coefficientY)];
    cloudView_01.tag = 4 + VIEWKEY;
    cloudView_01.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView1 addSubview:cloudView_01];
    UIImageView * cloudView_02 = [[UIImageView alloc]initWithFrame:CGRectMake(90*_coefficientX,300*_coefficientY,93*0.8*_coefficientX,64*0.8*_coefficientY)];
    cloudView_02.tag = 5 + VIEWKEY;
    cloudView_02.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView1 addSubview:cloudView_02];
    UIImageView * pageView_01 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,1150*_coefficientY,720*_coefficientX,20*_coefficientY)];
    pageView_01.image = [UIImage imageNamed:@"轮播圈_01.png"];
    [_pageView1 addSubview:pageView_01];
    [_scrollview addSubview:_pageView1];
    
    /**
     页面二
     */
    _pageView2 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    UIImageView * cloudView_02_01 = [[UIImageView alloc]initWithFrame:CGRectMake(130*_coefficientX,220*_coefficientY,93* 0.5*_coefficientX,64* 0.5*_coefficientY)];
    cloudView_02_01.tag = 3 + VIEWKEY;
    cloudView_02_01.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView2 addSubview:cloudView_02_01];
    UIImageView * cloudView_02_02 = [[UIImageView alloc]initWithFrame:CGRectMake(600*_coefficientX,300*_coefficientY,93* 0.8*_coefficientX,64* 0.8*_coefficientY)];
    cloudView_02_02.tag = 4 + VIEWKEY;
    cloudView_02_02.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView2 addSubview:cloudView_02_02];
    _pageView2.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:158 / 255.0 blue:245 / 255.0 alpha:1];
    UIImageView * bigImage_02 = [[UIImageView alloc]initWithFrame:CGRectMake(100*_coefficientX,176*_coefficientY, 526*_coefficientX, 590*_coefficientY)];
    bigImage_02.image = [UIImage imageNamed:@"大图_02.png"];
    [_pageView2 addSubview:bigImage_02];
    UIImageView * cloudView_02_03 = [[UIImageView alloc]initWithFrame:CGRectMake(370*_coefficientX,64*_coefficientY,93* 1.4*_coefficientX,64* 1.4*_coefficientY)];
    cloudView_02_03.tag = 5 + VIEWKEY;
    cloudView_02_03.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView2 addSubview:cloudView_02_03];
    UIImageView * airBubbles_02_01 = [[UIImageView alloc]initWithFrame:CGRectMake(190*_coefficientX,580*_coefficientY, 76*_coefficientX, 100*_coefficientY)];
    airBubbles_02_01.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_02_01.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_02_01);
    airBubbles_02_01.tag = 1 + VIEWKEY;
    airBubbles_02_01.image = [UIImage imageNamed:@"气泡_02_01.png"];
    [_pageView2 addSubview:airBubbles_02_01];
    UIImageView * airBubbles_02_02 = [[UIImageView alloc]initWithFrame:CGRectMake(370*_coefficientX,330*_coefficientY, 131*_coefficientX, 173*_coefficientY)];
    airBubbles_02_02.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_02_02.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_02_02);
    airBubbles_02_02.tag = 2 + VIEWKEY;
    airBubbles_02_02.image = [UIImage imageNamed:@"气泡_02_02.png"];
    [_pageView2 addSubview:airBubbles_02_02];
    UIImageView * textView_02 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,850*_coefficientY,720*_coefficientX,211*_coefficientY)];
    textView_02.image = [UIImage imageNamed:@"文字_02.png"];
    [_pageView2 addSubview:textView_02];
    UIImageView * pageView_02 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,1150*_coefficientY,720*_coefficientX,20*_coefficientY)];
    pageView_02.image = [UIImage imageNamed:@"轮播圈_02.png"];
    [_pageView2 addSubview:pageView_02];
    [_scrollview addSubview:_pageView2];
    
    /**
     页面三
     */
    _pageView3 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height)];
    UIImageView * cloudView_03_01 = [[UIImageView alloc]initWithFrame:CGRectMake(130*_coefficientX,220*_coefficientY,93* 0.5*_coefficientX,64* 0.5*_coefficientY)];
    cloudView_03_01.tag = 5 + VIEWKEY;
    cloudView_03_01.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView3 addSubview:cloudView_03_01];
    UIImageView * cloudView_03_02 = [[UIImageView alloc]initWithFrame:CGRectMake(600*_coefficientX,300*_coefficientY,93* 0.8*_coefficientX,64* 0.8*_coefficientY)];
    cloudView_03_02.tag = 6 + VIEWKEY;
    cloudView_03_02.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView3 addSubview:cloudView_03_02];
    _pageView3.backgroundColor = [UIColor colorWithRed:144 / 255.0 green:205 / 255.0 blue:102 / 255.0 alpha:1];
    UIImageView * bigImage_03 = [[UIImageView alloc]initWithFrame:CGRectMake(98*_coefficientX,184*_coefficientY, 522*_coefficientX, 584*_coefficientY)];
    bigImage_03.image = [UIImage imageNamed:@"大图_03.png"];
    [_pageView3 addSubview:bigImage_03];
    UIImageView * cloudView_03_03 = [[UIImageView alloc]initWithFrame:CGRectMake(370*_coefficientX,64*_coefficientY,93* 1.4*_coefficientX,64* 1.4*_coefficientY)];
    cloudView_03_03.tag = 7 + VIEWKEY;
    cloudView_03_03.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView3 addSubview:cloudView_03_03];
    UIImageView * truck_03_01 = [[UIImageView alloc]initWithFrame:CGRectMake(480*_coefficientX,340*_coefficientY, 70*_coefficientX, 104*_coefficientY)];
    truck_03_01.image = [UIImage imageNamed:@"卡车_03_01.png"];
    truck_03_01.tag = 1 + VIEWKEY;
    [_pageView3 addSubview:truck_03_01];
    UIImageView * truck_03_02 = [[UIImageView alloc]initWithFrame:CGRectMake(360*_coefficientX,425*_coefficientY, 76*_coefficientX, 121*_coefficientY)];
    truck_03_02.image = [UIImage imageNamed:@"卡车_03_02.png"];
    truck_03_02.tag = 2 + VIEWKEY;
    [_pageView3 addSubview:truck_03_02];
    UIImageView * truck_03_03 = [[UIImageView alloc]initWithFrame:CGRectMake(320*_coefficientX,515*_coefficientY, 86*_coefficientX, 142*_coefficientY)];
    truck_03_03.image = [UIImage imageNamed:@"卡车_03_03.png"];
    truck_03_03.tag = 3 + VIEWKEY;
    [_pageView3 addSubview:truck_03_03];
    UIImageView * truck_03_04 = [[UIImageView alloc]initWithFrame:CGRectMake(400*_coefficientX,600*_coefficientY, 90*_coefficientX, 163*_coefficientY)];
    truck_03_04.image = [UIImage imageNamed:@"卡车_03_04.png"];
    truck_03_04.tag = 4 + VIEWKEY;
    [_pageView3 addSubview:truck_03_04];
    UIImageView * textView_03 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,850*_coefficientY,720*_coefficientX,211*_coefficientY)];
    textView_03.image = [UIImage imageNamed:@"文字_03.png"];
    [_pageView3 addSubview:textView_03];
    UIImageView * pageView_03 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,1150*_coefficientY,720*_coefficientX,20*_coefficientY)];
    pageView_03.image = [UIImage imageNamed:@"轮播圈_03.png"];
    [_pageView3 addSubview:pageView_03];
    [_scrollview addSubview:_pageView3];

    /**
     页面四
     */
    _pageView4 = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*3, 0, self.frame.size.width, self.frame.size.height)];
    UIImageView * cloudView_04_01 = [[UIImageView alloc]initWithFrame:CGRectMake(130*_coefficientX,220*_coefficientY,93* 0.5*_coefficientX,64* 0.5*_coefficientY)];
    cloudView_04_01.tag = 5 + VIEWKEY;
    cloudView_04_01.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView4 addSubview:cloudView_04_01];
    UIImageView * cloudView_04_02 = [[UIImageView alloc]initWithFrame:CGRectMake(600*_coefficientX,300*_coefficientY,93* 0.8*_coefficientX,64* 0.8*_coefficientY)];
    cloudView_04_02.tag = 6 + VIEWKEY;
    cloudView_04_02.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView4 addSubview:cloudView_04_02];
    _pageView4.backgroundColor = [UIColor colorWithRed:122 / 255.0 green:189 / 255.0 blue:238 / 255.0 alpha:1];
    UIImageView * bigImage_04 = [[UIImageView alloc]initWithFrame:CGRectMake(102*_coefficientX,245*_coefficientY, 522*_coefficientX, 522*_coefficientY)];
    bigImage_04.image = [UIImage imageNamed:@"大图_04.png"];
    [_pageView4 addSubview:bigImage_04];
    UIImageView * cloudView_04_03 = [[UIImageView alloc]initWithFrame:CGRectMake(370*_coefficientX,64*_coefficientY,93* 1.4*_coefficientX,64* 1.4*_coefficientY)];
    cloudView_04_03.tag = 7 + VIEWKEY;
    cloudView_04_03.image = [UIImage imageNamed:@"云朵_01.png"];
    [_pageView4 addSubview:cloudView_04_03];
    UIImageView * airBubbles_04_01 = [[UIImageView alloc]initWithFrame:CGRectMake(245*_coefficientX,200*_coefficientY, 76*_coefficientX, 97*_coefficientY)];
    airBubbles_04_01.image = [UIImage imageNamed:@"气泡_04_01.png"];
    airBubbles_04_01.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_04_01.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_04_01);
    airBubbles_04_01.tag = 1 + VIEWKEY;
    [_pageView4 addSubview:airBubbles_04_01];
    UIImageView * airBubbles_04_02 = [[UIImageView alloc]initWithFrame:CGRectMake(500*_coefficientX,295*_coefficientY, 66*_coefficientX, 81*_coefficientY)];
    airBubbles_04_02.image = [UIImage imageNamed:@"气泡_04_02.png"];
    airBubbles_04_02.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_04_02.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_04_02);
    airBubbles_04_02.tag = 2 + VIEWKEY;
    [_pageView4 addSubview:airBubbles_04_02];
    UIImageView * airBubbles_04_03 = [[UIImageView alloc]initWithFrame:CGRectMake(120*_coefficientX,350*_coefficientY, 68*_coefficientX, 89*_coefficientY)];
    airBubbles_04_03.image = [UIImage imageNamed:@"气泡_04_03.png"];
    airBubbles_04_03.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_04_03.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_04_03);
    airBubbles_04_03.tag = 3 + VIEWKEY;
    [_pageView4 addSubview:airBubbles_04_03];
    UIImageView * airBubbles_04_04 = [[UIImageView alloc]initWithFrame:CGRectMake(275*_coefficientX,400*_coefficientY, 55*_coefficientX, 66*_coefficientY)];
    airBubbles_04_04.image = [UIImage imageNamed:@"气泡_04_04.png"];
    airBubbles_04_04.layer.anchorPoint = CGPointMake(0.5, 1);
    airBubbles_04_04.frame  = ANCHORPOINTCOORDINATECONVERSION(airBubbles_04_04);
    airBubbles_04_04.tag = 4 + VIEWKEY;
    [_pageView4 addSubview:airBubbles_04_04];
    UIImageView * textView_04 = [[UIImageView alloc]initWithFrame:CGRectMake(0*_coefficientX,850*_coefficientY,720*_coefficientX,211*_coefficientY)];
    textView_04.image = [UIImage imageNamed:@"文字_04.png"];
    [_pageView4 addSubview:textView_04];
    UIButton * pageView_04 = [[UIButton alloc]initWithFrame:CGRectMake(0*_coefficientX,1130*_coefficientY,720*_coefficientX,80*_coefficientY)];
    [pageView_04 setImage:[UIImage imageNamed:@"按钮_04.png"] forState:UIControlStateSelected];
    [pageView_04 setImage:[UIImage imageNamed:@"按钮_04.png"] forState:UIControlStateNormal];
    [pageView_04 addTarget:self action:@selector(guideButtonClick) forControlEvents:UIControlEventTouchDown];
    [_pageView4 addSubview:pageView_04];
    [_scrollview addSubview:_pageView4];
    [self runAnimationForPage_01];
}
/**
 *  scrollView代理方法,实现页面轮播确认开始播放动画
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x/ self.frame.size.width) + 1;
    if (page == _currentPage) {
        return ;
    }
    _currentPage = page;
    switch (_currentPage) {
        case 1:
            [self runAnimationForPage_01];
            break;
        case 2:
            [self runAnimationForPage_02];
            break;
        case 3:
            [self runAnimationForPage_03];
            break;
        case 4:
            [self runAnimationForPage_04];
            break;
        default:
            break;
    }
}
/**
 *  页面一、二、三、四动画
 */
- (void)runAnimationForPage_01
{
    UIView * airBubbles_01 = [_pageView1 viewWithTag:1 + VIEWKEY];
    UIView * airBubbles_02 = [_pageView1 viewWithTag:2 + VIEWKEY];
    UIView * airBubbles_03 = [_pageView1 viewWithTag:3 + VIEWKEY];
    UIView * cloudView_01 = [_pageView1 viewWithTag:4 + VIEWKEY];
    UIView * cloudView_02 = [_pageView1 viewWithTag:5 + VIEWKEY];
    airBubbles_01.transform = CGAffineTransformMakeScale(0.05, 0.05);
    airBubbles_02.transform = CGAffineTransformMakeScale(0.05, 0.05);
    airBubbles_03.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        airBubbles_01.transform = CGAffineTransformMakeScale(1.0, 1.0);
        airBubbles_02.transform = CGAffineTransformMakeScale(1.0, 1.0);
        airBubbles_03.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
    [self runAnimationForView:cloudView_01 withDistance:70];
    [self runAnimationForView:cloudView_02 withDistance:-60];
}
- (void)runAnimationForPage_02
{
    UIView * airBubbles_01 = [_pageView2 viewWithTag:1 + VIEWKEY];
    UIView * airBubbles_02 = [_pageView2 viewWithTag:2 + VIEWKEY];
    UIView * cloudView_01 = [_pageView2 viewWithTag:3 + VIEWKEY];
    UIView * cloudView_02 = [_pageView2 viewWithTag:4 + VIEWKEY];
    UIView * cloudView_03 = [_pageView2 viewWithTag:5 + VIEWKEY];
    airBubbles_01.transform = CGAffineTransformMakeScale(0.05, 0.05);
    airBubbles_02.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        airBubbles_01.transform = CGAffineTransformMakeScale(1.0, 1.0);
        airBubbles_02.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
    [self runAnimationForView:cloudView_01 withDistance:60];
    [self runAnimationForView:cloudView_02 withDistance:70];
    [self runAnimationForView:cloudView_03 withDistance:-100];
}
- (void)runAnimationForPage_03
{
    UIView * truck_01 = [_pageView3 viewWithTag:1 + VIEWKEY];
    UIView * truck_02 = [_pageView3 viewWithTag:2 + VIEWKEY];
    UIView * truck_03 = [_pageView3 viewWithTag:3 + VIEWKEY];
    UIView * truck_04 = [_pageView3 viewWithTag:4 + VIEWKEY];
    UIView * cloudView_01 = [_pageView3 viewWithTag:5 + VIEWKEY];
    UIView * cloudView_02 = [_pageView3 viewWithTag:6 + VIEWKEY];
    UIView * cloudView_03 = [_pageView3 viewWithTag:7 + VIEWKEY];
    truck_01.frame = CGRectMake(480*_coefficientX,340*_coefficientY, 70*_coefficientX, 104*_coefficientY);
    truck_02.frame = CGRectMake(360*_coefficientX,425*_coefficientY, 76*_coefficientX, 121*_coefficientY);
    truck_03.frame = CGRectMake(320*_coefficientX,515*_coefficientY, 86*_coefficientX, 142*_coefficientY);
    truck_04.frame = CGRectMake(400*_coefficientX,600*_coefficientY, 90*_coefficientX, 163*_coefficientY);
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        truck_01.frame = CGRectMake(380*_coefficientX,340*_coefficientY, 70*_coefficientX, 104*_coefficientY);
        truck_02.frame = CGRectMake(210*_coefficientX,425*_coefficientY, 76*_coefficientX, 121*_coefficientY);
        truck_03.frame = CGRectMake(400*_coefficientX,515*_coefficientY, 86*_coefficientX, 142*_coefficientY);
        truck_04.frame = CGRectMake(300*_coefficientX,600*_coefficientY, 90*_coefficientX, 163*_coefficientY);
    } completion:^(BOOL finished) {
    }];
    [self runAnimationForView:cloudView_01 withDistance:60];
    [self runAnimationForView:cloudView_02 withDistance:70];
    [self runAnimationForView:cloudView_03 withDistance:-100];
}
- (void)runAnimationForPage_04
{
    UIView * airBubbles_01 = [_pageView4 viewWithTag:1 + VIEWKEY];
    UIView * airBubbles_02 = [_pageView4 viewWithTag:2 + VIEWKEY];
    UIView * airBubbles_03 = [_pageView4 viewWithTag:3 + VIEWKEY];
    UIView * airBubbles_04 = [_pageView4 viewWithTag:4 + VIEWKEY];
    UIView * cloudView_01 = [_pageView4 viewWithTag:5 + VIEWKEY];
    UIView * cloudView_02 = [_pageView4 viewWithTag:6 + VIEWKEY];
    UIView * cloudView_03 = [_pageView4 viewWithTag:7 + VIEWKEY];
    airBubbles_01.transform = CGAffineTransformMakeScale(0.05, 0.05);
    airBubbles_02.transform = CGAffineTransformMakeScale(0.05, 0.05);
    airBubbles_03.transform = CGAffineTransformMakeScale(0.05, 0.05);
    airBubbles_04.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        airBubbles_01.transform = CGAffineTransformMakeScale(1.0, 1.0);
        airBubbles_02.transform = CGAffineTransformMakeScale(1.0, 1.0);
        airBubbles_03.transform = CGAffineTransformMakeScale(1.0, 1.0);
        airBubbles_04.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
    [self runAnimationForView:cloudView_01 withDistance:60];
    [self runAnimationForView:cloudView_02 withDistance:70];
    [self runAnimationForView:cloudView_03 withDistance:-100];
}
- (void)runAnimationForView:(UIView *)view withDistance:(float)distance
{
    [UIView animateWithDuration:1.2 animations:^{
        view.frame = CGRectMake(view.frame.origin.x + distance, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }];
    [UIView animateWithDuration:1.2 delay:1.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        view.frame = CGRectMake(view.frame.origin.x - distance, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
/**
 *  立即体验按钮绑定方法
 */
- (void)guideButtonClick
{
    [_delegate guidePageViewEnd:self];
}
@end
