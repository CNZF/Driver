//
//  BaseViewModel.m
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "Toast.h"
#import "AFHTTPSessionManager.h"
#import "RACSignal.h"
#import "OrderedDictionary.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"
#import <SDVersion/SDVersion.h>
#import <GTSDK/GeTuiSdk.h>
#import "Reachability.h"



typedef BOOL(^WSTestBlock) (NSURLResponse *response, id responseObject, NSError *error);

@interface BaseViewModel ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, copy  ) WSTestBlock          wsTestBlock;
@property (nonatomic, assign) int                  status;

@end

@implementation BaseViewModel

- (instancetype)init {
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if ([conn currentReachabilityStatus] != NotReachable)
    {
        self = [super init];
        if (self) {
            [self initManagerWithBaseURL:BASEURL];

            [self initParam];
            [self initHeadDic];
            self.userInfo = USER_INFO;
        }


           return self;
    }
    else
    {
        //没有网络
        [[Toast shareToast]makeText:@"没有网络!" aDuration:1];
        return nil;
    }

}

- (void)initParam {
    WS(ws)
    self.errorBlock = ^(NSError *error) {
        [ws handleError:error];
    };
    
    self.wsTestBlock = ^BOOL(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode >= 500) {
            return YES;
        }
        else {
            return NO;
        }
    };
}

- (void)initManagerWithBaseURL:(NSString *)URL {
    
    self.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:URL]];
    [self reachability];
    self.manager.requestSerializer.timeoutInterval = INTERVAL;
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpg", nil]];
}



/**
 *  加载头请求字典
 */
- (void)initHeadDic {
    self.dicHead = [NSMutableDictionary dictionary];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //手机型号
    NSString* phoneModel = [self getDeviceName];
    
    NSString *device = [[phoneModel append:@","]append:phoneVersion];
    
    NSString *platform = @"IOS";
    
    NSString *clientid = [GeTuiSdk clientId];
    
    NSString *version = @"0.0.0.1";
    UserInfoModel *info = USER_INFO;
    
    [self.dicHead setValue:device forKey:@"device"];
    [self.dicHead setValue:platform forKey:@"platform"];
    [self.dicHead setValue:clientid forKey:@"clientid"];
    [self.dicHead setValue:version forKey:@"version"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];

    NSString * token  = [[NSUserDefaults standardUserDefaults] objectForKey:@"TOKEN"];
    if (info) {
        NSString *stId  = [NSString stringWithFormat:@"%i",info.iden];
        [self.dicHead setValue:stId forKey:@"userId"];
    }else{
        [self.dicHead setValue:@"" forKey:@"userid"];
    }
    if (token.length) {
        [self.dicHead setValue:token forKey:@"token"];
    }else{
        [self.dicHead setValue:@"" forKey:@"token"];
    }
    
    self.dicRequest = [NSMutableDictionary dictionary];

   }


- (RACSignal *)GETWithTimeSp:(NSString *)method Param:(NSDictionary *)param {
    NSMutableDictionary *mutiDict = [NSMutableDictionary dictionaryWithDictionary:param];
    [mutiDict setValue:[NSString timesp] forKey:@"timesp"];
    return [self GET:method Param:[mutiDict copy]];
}

- (RACSignal *)GET:(NSString *)method Param:(NSDictionary *)param {

    return [self.manager rac_GET:method parameters:param retries:RETRIES interval:INTERVAL test:self.wsTestBlock];
}

/**
 *  Post请求
 *
 */
- (RACSignal *)POST:(NSString *)method Param:(NSDictionary *)param {
  
    return [self.manager rac_POST:method parameters:param retries:RETRIES interval:INTERVAL test:self.wsTestBlock];
}
/**
 *  Post请求（传图片）
 *
 */
- (RACSignal *)POST:(NSString *)method
              Param:(NSDictionary *)param
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock{
    [self setRequestSerializer:param];
    self.manager.requestSerializer.timeoutInterval = IMGINTERVAL;
    return [self.manager rac_POST:method
                       parameters:param
        constructingBodyWithBlock:formDataBlock
                          retries:RETRIES
                         interval:INTERVAL
                             test:self.wsTestBlock];
    
}

- (void)handleError:(NSError *)error {
    NSLog(@"net error :%@",error);
    [SVProgressHUD dismiss];
}
/**
 *  设置请求头部
 *
 *  @param param 请求参数
 */
- (void)setRequestSerializer:(NSDictionary *)param {
//    OrderedDictionary *dict = [self orderDict:param];

}


- (id)getResponseData:(RACTuple *)tuple {
    return [tuple first];
}


/**
 *  获取设备型号名称
 *
 *  @return <#return value description#>
 */
- (NSString *)getDeviceName{
    NSArray *modelArray = @[
                            
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,2",
                            @"iPhone7,1",
                            @"iPhone8,1",
                            @"iPhone8,2",
                            @"iPhone8,4",
                            @"iPhone9,1",
                            @"iPhone9,2",


                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator",
                                @"iPhone Simulator",
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iPhone 6",
                                @"iPhone 6 Plus",
                                @"iPhone 6s",
                                @"iPhone 6s Plus",
                                @"iPhone SE",
                                @"iPhone 7",
                                @"iPhone 7 Plus",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
                 NSInteger modelIndex = [modelArray indexOfObject:[SDVersion deviceNameString]];
    //模拟器机型
    if (modelIndex >= modelNameArray.count ||modelIndex < 0) {
        modelIndex = 18;
    }
    return modelNameArray[modelIndex];
}

//字典转换为字符串

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}



//压缩、AES加密
- (NSString *)stringZipWithDic:(NSDictionary *)dic withZip:(BOOL)isZip withisEncrypt:(BOOL)isEncrypt{

    NSString *stJson = [self dictionaryToJson:dic];
    //压缩
    if (isZip) {

        NSData *data =[stJson dataUsingEncoding:NSUTF8StringEncoding];
        zipAndUnzip *zipTools = [[zipAndUnzip alloc] init];

        NSData *datazip = [zipTools gzipDeflate:data];

        stJson = datazip.base64Encoding;

        //iOS7 以后

        //stJson = [datazip base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];

    }

    return stJson;


}

//MD5加密
- (NSString *)stringWithMd5:(NSString *)st {

    MD5Util *md5util = [MD5Util new];


    return  [md5util md5:st];
}

//图片命名
- (NSString *)imgNameWith:(NSString *)st {
    UserInfoModel *info = [UserInfoModel new];
    NSString *stId = [NSString stringWithFormat:@"%i",info.iden];
    NSString *fileName = [NSString stringWithFormat:@"%@%@",stId,st];
    NSData *data =[fileName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filejpgName = [NSString stringWithFormat:@"%@.jpg",data.base64Encoding];
    return filejpgName;
}

- (void)reachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                [self.manager.operationQueue cancelAllOperations];
                self.status = 1;
                [[Toast shareToast]makeText:@"无网络" aDuration:1 ];

                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    // 3.开始监控
    [mgr startMonitoring];
}


#pragma mark - utils

- (OrderedDictionary *)orderDict:(NSDictionary *)param {
    NSArray *arr = [param keysSortedByValueUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch range:range];
    }];
    
    MutableOrderedDictionary *orderDicts = [MutableOrderedDictionary dictionaryWithCapacity:param.count];
    for (int i=0; i<arr.count; i++) {
        NSString *key = arr[i];
        [orderDicts insertObject:param[key] forKey:key atIndex:i];
    }
    return orderDicts;
}
@end
