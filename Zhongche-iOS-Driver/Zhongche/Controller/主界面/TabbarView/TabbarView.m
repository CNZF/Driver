//
//  TabbarView.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/29.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "TabbarView.h"
@interface TabbarView ()
@property (weak, nonatomic) IBOutlet UIButton *billBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;

@property (weak, nonatomic) IBOutlet UIButton *billContentBtn;
@property (weak, nonatomic) IBOutlet UIButton *personContentBtn;

@end

@implementation TabbarView


- (IBAction)pressSellBtn:(id)sender {
    self.sellBtn.selected = YES;
    self.billBtn.selected = YES;
    self.personBtn.selected = NO;

    if (self.block) {
        self.block(SellController);
    }
}


- (IBAction)pressBillContentBtn:(id)sender {
    self.billBtn.selected = NO;
    self.sellBtn.selected = NO;
    self.personBtn.selected = NO;
    
    if (self.block) {
        self.block(BillController);
    }
}

- (IBAction)pressPersonContentBtn:(id)sender {
    self.personBtn.selected = YES;
    self.billBtn.selected = YES;
    self.sellBtn.selected = NO;
    
    if (self.block) {
        self.block(PersonController);
    }
}


@end
