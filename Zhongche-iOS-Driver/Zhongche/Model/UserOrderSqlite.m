//
//  UserOrderSqlite.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/15.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "UserOrderSqlite.h"
//定义一个静态变量用于接收实例对象，初始化为nil
static UserOrderSqlite * userOrderSqlite = nil;
@interface UserOrderSqlite ()

@property (nonatomic,retain)FMDatabase * database;

@end

@implementation UserOrderSqlite



+(UserOrderSqlite *)shareUserOrderSqlite{
    @synchronized(self){//线程保护，增加同步锁
        if (userOrderSqlite ==nil ) {
            userOrderSqlite = [[self alloc] init];
        }
    }
    return userOrderSqlite;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createSqliteAndTable];
    }
    return self;
}


//创建数据库和表
- (void)createSqliteAndTable
{
    //数据库路径
    NSString * sqlitePath = [NSString stringWithFormat:@"%@/userOrderSql.rdb",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    
    _database = [[FMDatabase alloc]initWithPath:sqlitePath];
    if (_database.open == NO)
    {
        NSLog(@"创建数据库失败");
        return ;
    }

    /**
     *   "end_region_center_lat" = "39.084158";
     "end_region_center_lng" = "117.200983";
     "start_region_center_lat" = "39.90403";
     "start_region_center_lng" = "116.407526";

     */
    NSString * createTablestr = @"CREATE TABLE IF NOT EXISTS OrderInformation(capacity_apply_order_id int,type int,price int,waybillId int,waybill_group_id int,containerType varchar(100),endTime varchar(100),end_address varchar(100),end_contacts varchar(100),end_contacts_phone varchar(100),end_region varchar(100),end_region_code varchar(100),goods_name varchar(100),startTime varchar(100),start_address varchar(100),start_contacts varchar(100),start_contacts_phone varchar(100),start_region varchar(100),start_region_code varchar(100),start_region_center_lat float,start_region_center_lng float,end_region_center_lat float,end_region_center_lng float)";
    if ([_database executeUpdate:createTablestr] == NO)
    {
        NSLog(@"创建表失败");
    }
    else
    {
        NSLog(@"创建表成功");
    }
}
//添加数据
- (void)increaseOneOrderData:(PushModel *)data
{
    [self deleteOneOrderData:data];
    NSString * insertSql = @"INSERT INTO OrderInformation(capacity_apply_order_id,type,price,waybillId,waybill_group_id,containerType,endTime,end_address,end_contacts,end_contacts_phone,end_region,end_region_code,goods_name,startTime,start_address,start_contacts,start_contacts_phone,start_region,start_region_code,start_region_center_lat,start_region_center_lng,end_region_center_lat,end_region_center_lng) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    BOOL isSuc           = [_database executeUpdate:insertSql,[NSString stringWithFormat:@"%d",data.capacity_apply_order_id],[NSString stringWithFormat:@"%d",data.type],[NSString stringWithFormat:@"%d",data.price],[NSString stringWithFormat:@"%d",data.waybillId],[NSString stringWithFormat:@"%d",data.waybill_group_id],data.containerType,data.endTime,data.end_address,data.end_contacts,data.end_contacts_phone,data.end_region,data.end_region_code,data.goods_name,data.startTime,data.start_address,data.start_contacts,data.start_contacts_phone,data.start_region,data.start_region_code,data.start_region_center_lat,data.start_region_center_lng,data.end_region_center_lat,data.end_region_center_lng];
    if (isSuc == NO)
    {
        NSLog(@"增加失败");
    }
    else
    {
        NSLog(@"增加成功");
    }
}
//删除数据
- (void)deleteOneOrderData:(PushModel *)data
{
    NSString * deleteSql = @"DELETE FROM OrderInformation WHERE waybillId = ?";
    BOOL isSuc = [_database executeUpdate:deleteSql,[NSString stringWithFormat:@"%d",data.waybillId]];
    if (isSuc == NO)
    {
        NSLog(@"删除失败");
    }
    else
    {
        NSLog(@"删除成功");
    }
}


/**
 @property (nonatomic, assign) int      capacity_apply_order_id;
 @property (nonatomic, assign) int      type;// 1. 派单; 2. 抢单 ; 3. 外采',
 @property (nonatomic, assign) int      waybillId;
 @property (nonatomic, assign) int      waybill_group_id;
 @property (nonatomic, strong  ) NSString *containerType;
 @property (nonatomic, strong  ) NSString *endTime;
 @property (nonatomic, strong  ) NSString *end_address;
 @property (nonatomic, strong  ) NSString *end_contacts;
 @property (nonatomic, strong  ) NSString *end_contacts_phone;
 @property (nonatomic, strong  ) NSString *end_region;
 @property (nonatomic, strong  ) NSString *end_region_code;
 @property (nonatomic, strong  ) NSString *goods_name;//2016-05-06
 @property (nonatomic, strong  ) NSString *startTime;//2016-05-06
 @property (nonatomic, strong  ) NSString *start_address;
 @property (nonatomic, strong  ) NSString *start_contacts;
 @property (nonatomic, strong  ) NSString *start_contacts_phone;
 @property (nonatomic, strong) NSString *start_region;//新加字段 货物名称
 @property (nonatomic, strong) NSString *start_region_code;//新加字段 货物尺寸
 */
//查找全部数据(按开始时间排序)
- (NSMutableArray *)selectAllOrderData
{
    NSString * selectSql = @"SELECT * FROM OrderInformation ORDER BY endtime DESC";
    FMResultSet * set = [_database executeQuery:selectSql];
    NSMutableArray * OrderDataArray = [NSMutableArray array];
    PushModel * orderData;
    while ([set next])
    {
        orderData                         = [[PushModel alloc]init];
        orderData.capacity_apply_order_id = [set intForColumn:@"capacity_apply_order_id"];
        orderData.type                    = [set intForColumn:@"type"];
        orderData.price                    = [set intForColumn:@"price"];
        orderData.waybillId               = [set intForColumn:@"waybillId"];
        orderData.waybill_group_id        = [set intForColumn:@"waybill_group_id"];
        orderData.containerType           = [set stringForColumn:@"containerType"];
        orderData.endTime                 = [set stringForColumn:@"endTime"];
        orderData.end_address             = [set stringForColumn:@"end_address"];
        orderData.end_contacts            = [set stringForColumn:@"end_contacts"];
        orderData.end_contacts_phone      = [set stringForColumn:@"end_contacts_phone"];
        orderData.end_region              = [set stringForColumn:@"end_region"];
        orderData.end_region_code         = [set stringForColumn:@"end_region_code"];
        orderData.goods_name              = [set stringForColumn:@"goods_name"];
        orderData.startTime               = [set stringForColumn:@"startTime"];
        orderData.start_address           = [set stringForColumn:@"start_address"];
        orderData.start_contacts          = [set stringForColumn:@"start_contacts"];
        orderData.start_contacts_phone    = [set stringForColumn:@"start_contacts_phone"];
        orderData.start_region    = [set stringForColumn:@"start_region"];
        orderData.start_region_code    = [set stringForColumn:@"start_region_code"];
        orderData.start_region_center_lat = [set doubleForColumn:@"start_region_center_lat"];
        orderData.start_region_center_lng = [set doubleForColumn:@"start_region_center_lng"];
        orderData.end_region_center_lat = [set doubleForColumn:@"end_region_center_lat"];
        orderData.end_region_center_lng = [set doubleForColumn:@"end_region_center_lng"];
        [OrderDataArray addObject:orderData];
        orderData = nil;
    }
    //删除过期抢单
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date;
    NSDate * nowDate = [NSDate date];
    for (NSInteger i = OrderDataArray.count - 1; i >= 0; i --)
    {
        orderData = OrderDataArray[i];
//        date = [formatter dateFromString:orderData.endtime];
        if ([[date laterDate:nowDate] isEqualToDate:nowDate])
        {
            [OrderDataArray removeObjectAtIndex:i];
            [self deleteOneOrderData:orderData];
        }
    }
    return OrderDataArray;
}
@end
