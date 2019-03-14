//
//  ZCWithdrawViewController.h
//  Zhongche
//
//  Created by lxy on 2016/11/8.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "ZCWalletInfo.h"

@interface ZCWithdrawViewController : BaseViewController

@property (nonatomic, strong) ZCWalletInfo          *walletModel;
@property (weak, nonatomic  ) IBOutlet UIImageView  *ivBankCard;
@property (weak, nonatomic  ) IBOutlet UILabel      *lbBankName;
@property (weak, nonatomic  ) IBOutlet UILabel      *lbBankNum;
@property (weak, nonatomic  ) IBOutlet UITextField  *tfMoney;
@property (weak, nonatomic  ) IBOutlet UIButton     *btnWithdraw;
@property (weak, nonatomic  ) IBOutlet UILabel      *lbNow;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;



@end
