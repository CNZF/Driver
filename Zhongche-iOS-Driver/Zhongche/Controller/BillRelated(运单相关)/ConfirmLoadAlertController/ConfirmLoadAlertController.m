//
//  ConfirmLoadAlertController.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/7/6.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "ConfirmLoadAlertController.h"
#import "ZCTransportOrderViewModel.h"

@interface ConfirmLoadAlertController ()

@end

@implementation ConfirmLoadAlertController

+ (instancetype)alertWithModel:(ZCTransportOrderModel *)model target:(UIViewController *)target completion:(void(^)(BOOL success))completion
{
    
    NSString * title;
    if (model.container_code) {
        title = @"集装箱编号";
    }else{
        title = @"请输入集装箱编号";
    }
    title = [NSString stringWithFormat:@"\n%@",title];
    
    ConfirmLoadAlertController * alert = [super alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:noAction];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert centainActionWithModel:model];
    }];
    [alert addAction:yesAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        if (model.container_code){
            textField.textAlignment = NSTextAlignmentCenter;
            textField.text = model.container_code;
            textField.userInteractionEnabled = NO;
        }else{
            
        }
    }];
    
    [alert customAlertStyle];
    
    return alert;
}

- (void) centainActionWithModel:(ZCTransportOrderModel *) model
{
    
    WS(ws);
    ZCTransportOrderViewModel *vm = [ZCTransportOrderViewModel new];
    UITextField * field = self.textFields[0];
    if (!model.container_code) {
        if ([field.text isEqualToString:@""]) {
            [[Toast shareToast]makeText:@"装箱码不能为空" aDuration:1];
        }else{
            
            NSString *searchText = field.text;
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z0-9]{11}$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (result) {
                [vm finishShipmentWithType:0 WithQrcode:model.parentCode WithBillid:model.waybill_id WithContainercode:searchText callback:^(NSString *message) {
                    if (message) {
                        [[Toast shareToast]makeText:@"装载成功" aDuration:1];
                        if (ws.successBlock) {
                            ws.successBlock(YES);
                        }
                    }
                }];
                
            }else{
                [[Toast shareToast]makeText:@"装箱码必须为11位的数字或字母" aDuration:1];
            }
        }
    }else{
        
        //取消注释
        [vm finishShipmentWithType:1 WithQrcode:field.text WithBillid:model.waybill_id WithContainercode:model.container_code callback:^(NSString *message) {
            if (message) {
                [[Toast shareToast]makeText:@"抵达成功" aDuration:1];
                if (ws.successBlock) {
                    ws.successBlock(YES);
                }
            }

        }];
        
    }
}

#pragma mark - 自定义alert的样式
- (void)customAlertStyle {
    //修改message颜色
//    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:self
//                                                            .message];
//    NSRange range1 = [self.message rangeOfString:@"是否取消车检订单？"];
//    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:RGBA(0x666666, 1) range:range1];
//    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range1];
//    NSRange range2 = [self.message rangeOfString:@"(每天最多取消3次)"];
//    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:RGBA(0xEF6D36, 1) range:range2];
//    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:range2];
//    [self setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    //修改action颜色
    for (UIAlertAction *action in self.actions) {
        //修改按钮
        if ([action.title isEqualToString:@"取消"]) {
            [action setValue:RGBA(0x999999, 1) forKey:@"titleTextColor"];
        } else if ([action.title isEqualToString:@"确定"]) {
            [action setValue:RGBA(0xEF6D36, 1) forKey:@"titleTextColor"];
        }
    }
    
    UITextField * field = self.textFields[0];
    field.borderStyle = UITextBorderStyleNone;
}

@end
