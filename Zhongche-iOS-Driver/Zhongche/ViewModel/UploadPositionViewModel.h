//
//  UploadPositionViewModel.h
//  Zhongche
//
//  Created by 中车_LL_iMac on 16/8/19.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"

@interface UploadPositionViewModel : BaseViewModel
/**
 *  上传定位信息
 *
 *  @param userId    用户ID
 *  @param location  位置坐标  格式 [aaa,bbb]
 *  @param timeStamp 时间转换成秒
 *  @param callback  回调
 */
-(void)uploadPositionWithUserID:(NSString *)userId WithLocation:(NSString *)location WithTimeStamp:(NSString *)timeStamp  callback:(void(^)(BOOL success))callback;
@end
