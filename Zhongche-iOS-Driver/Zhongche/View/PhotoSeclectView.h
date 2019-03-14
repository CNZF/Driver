//
//  PhotoSeclectView.h
//  Zhongche
//
//  Created by lxy on 16/9/6.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseView.h"

@interface PhotoSeclectView : BaseView

- (void) viewFrame :(CGSize )size;

@property (nonatomic, strong) UIImage *implace;
@property (nonatomic, strong) UIImage *imCurrent;

@end
