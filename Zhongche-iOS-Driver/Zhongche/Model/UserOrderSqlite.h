//
//  UserOrderSqlite.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/15.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushModel.h"
#import "FMDatabase.h"

@interface UserOrderSqlite : NSObject
+(UserOrderSqlite *)shareUserOrderSqlite;
/**
 *  添加记录
 *
 *  @param data 
 */
- (void)increaseOneOrderData:(PushModel *)data;
/**
 *  删除data数据字段
 *
 *  @param data
 */
- (void)deleteOneOrderData:(PushModel *)data;
/**
 *  查找表 结果按时间排序
 *
 *  @return OrderModel列表数组
 */
- (NSMutableArray *)selectAllOrderData;
@end
