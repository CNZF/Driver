//
//  LinesViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseRouteViewController.h"
#import "PreferLineViewModel.h"

@protocol LinesDelegate <NSObject>
-(void)getLines:(NSArray *)models;
@end

@interface LinesViewController : BaseRouteViewController
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int citycode;
@property (nonatomic, weak) id<LinesDelegate>linesDeldgate;
@end
