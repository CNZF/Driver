//
//  UploadingPosition.h
//  Zhongche
//
//  Created by 中车_LL_iMac on 16/8/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"

@interface UploadingPosition : BaseViewModel
/**
 *  上传定位信息
 *
 *  @param date     时间
 *  @param userId   UID
 *  @param gps      定位坐标
 *  @param callback 回调
 */
-(void)uploadWithDate:(NSDate *)date WithUserID:(NSString *)userId WithGps:(NSString *)gps callback:(void(^)(BOOL success))callback;
@end
