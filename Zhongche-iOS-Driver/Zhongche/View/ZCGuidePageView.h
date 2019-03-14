//
//  ZCGuidePageView.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZCGuidePageViewDelegate <NSObject>
- (void)guidePageViewEnd:(UIView *)guidePageView;
@end
@interface ZCGuidePageView : UIView

@property (nonatomic,weak)id <ZCGuidePageViewDelegate> delegate;

@end
