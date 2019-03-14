//
//  ZCChangePayPWDViewController.h
//  Zhongche
//
//  Created by lxy on 2016/11/3.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"

@interface ZCChangePayPWDViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tfOldPWD;
@property (weak, nonatomic) IBOutlet UITextField *tfGetCode;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPWD;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPWD2;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmite;

@end
