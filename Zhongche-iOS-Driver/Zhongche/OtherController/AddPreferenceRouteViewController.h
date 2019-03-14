//
//  addPreferenceRouteViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/25.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseRouteViewController.h"

@protocol AddPreferenceRouteViewControllerDelegate <NSObject>

- (void)addPreferenceSuccessful;

@end

@interface AddPreferenceRouteViewController : BaseRouteViewController
@property (nonatomic, weak) id<AddPreferenceRouteViewControllerDelegate>addSuccessfulDelegate;
@end
