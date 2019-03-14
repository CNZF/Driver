//
//  ZCWalletViewModel.h
//  Zhongche
//
//  Created by lxy on 2016/10/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "ZCBankCardModel.h"
#import "ZCBankCardMessageInfo.h"
#import "ZCWalletInfo.h"

@interface ZCWalletViewModel : BaseViewModel

/**
 *  绑定钱包
 *
 *  @param userName     用户名
 *  @param bankCardNum  银行卡号
 *  @param verifyCode   验证码
 *  @param bankCardName 银行
 *  @param bankCardCode 银行卡code
 */


-(void)bindWalletWithUserName:(NSString *)userName WithBankCardNum:(NSString *)bankCardNum WithVerifyCode:(NSString *)verifyCode WithBankCardName:(NSString *)bankCardName WithBankCardCode:(NSString *)bankCardCode callback:(void(^)(NSString *st))callback;

/**
 *  获得银行卡信息
 *
 *  @param bankCardNum 银行卡号
 *  @param callback    银行卡信息对象
 */
-(void)getBankRelativeWithBankCardNum:(NSString *)bankCardNum callback:(void(^)(ZCBankCardModel *info))callback;

/**
 *  绑定银行卡获取验证码
 */

- (void)getRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback;

/**
 *  设置支付密码获取验证码
 */

- (void)getPayPWDRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback;

/**
 *  获取钱包信息
 */
- (void)getWalletInfocallback:(void(^)(ZCWalletInfo *info))callback;

/**
 *  获取钱包信息
 */
- (void)getgetBindingBankCardcallback:(void(^)(ZCBankCardMessageInfo *info))callback;

/**
 *  设置支付密码
 *
 *  @param idCard     身份证号
 *  @param password   密码
 *  @param verifyCode 验证码
 */
- (void)setPayPWDWithIdCard:(NSString *)idCard WithPassword:(NSString *)password WithVerifyCode:(NSString *)verifyCode callback:(void(^)(NSString *st))callback;


/**
 *  查询账单
 *
 *  @param callback 账单数组
 */

- (void)selectWalletMoneyOrderListcallback:(void(^)(NSMutableArray *arrInfo))callback;

/**
 *  解绑银行卡
 *
 *  @param pwd 支付密码
 */
- (void)unBindingBankCardWithPWD:(NSString *)pwd callback:(void(^)(NSString *st))callback;

/**
 *  修改支付密码
 *
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *  @param verifyCode  验证码
 *  @param callback    返回状态
 */

- (void)setPayPWDWithOldPassword:(NSString *)oldPassword WithNewPassword:(NSString *)newPassword WithVerifyCode:(NSString *)verifyCode callback:(void(^)(NSString *st))callback;

/**
 *  提现
 *
 *  @param amount      金额
 *  @param payPassword 支付密码
 *  @param callback    返回
 */
- (void)withdrawMoneyWithAmount:(NSString *)amount WithPayPassword:(NSString *)payPassword callback:(void(^)(NSString *st))callback;

/**
 *  检验支付密码
 *
 *  @param pwd 支付密码
 */
- (void)checkWithPWD:(NSString *)pwd callback:(void(^)(NSString *st))callback;

@end
