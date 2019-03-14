//
//  UserImgInfo.h
//  Zhongche
//
//  Created by lxy on 16/7/21.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserImgInfo : NSObject

@property (nonatomic, strong) UIImage *idimagefront;//身份证正面
@property (nonatomic, strong) UIImage *idimageback;//身份证反面
@property (nonatomic, strong) UIImage *drivelicensefront;//驾驶证
@property (nonatomic, strong) UIImage *certifiedfront;//从业证

@end
