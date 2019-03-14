//
//  ZCBindBankCardViewController.h
//  Zhongche
//
//  Created by lxy on 2016/10/28.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"

@interface ZCBindBankCardViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfBankCardNum;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UITextField *tfBankName;

@end
