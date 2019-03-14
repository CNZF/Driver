//
//  CapacityDetailsViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"

@protocol CapacityDetailsDelegate <NSObject>

- (void)agreeORdisagreeCapacityDetails;
@end
@interface CapacityDetailsViewController : BaseViewController
@property (nonatomic,assign) int capacityID;
@property (nonatomic, weak) id<CapacityDetailsDelegate>capacityDetailsDelegate;
@end
