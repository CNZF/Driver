//
//  GetGeographicalPosition.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/17.
//  Copyright © 2016年 lxy. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GetGeographicalPosition : NSObject
@property (nonatomic, copy)void (^castPosition)(CLLocation *);
- (void)getGeographicalPosition:(void (^)(CLLocation * location))block;
+(GetGeographicalPosition *)shareGetGeographicalPosition;
- (void)start;
- (void)stop;
@end
