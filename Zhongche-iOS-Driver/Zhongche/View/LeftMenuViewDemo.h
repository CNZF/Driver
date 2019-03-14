//
//  LeftMenuViewDemo.h
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import "UserInfoModel.h"


@protocol HomeMenuViewDelegate <NSObject>

-(void)LeftMenuViewClick:(NSInteger)tag;
-(void)HeadClick;
- (void)ShareClick;

@end

@interface LeftMenuViewDemo : UIView

@property (nonatomic ,weak)id <HomeMenuViewDelegate> customDelegate;
@property (nonatomic, strong) UIView      *vilevel;
@property (nonatomic, strong) UserInfoModel *info;;

@end
