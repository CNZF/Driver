//
//  ContentView.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/9/3.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.commitBtn.layer.cornerRadius = 4.0f;
    self.commitBtn.layer.masksToBounds = YES;
}

- (IBAction)onBtn1:(id)sender {
    if (self.block) {
        self.block(SBRING);
    }
}
- (IBAction)onBtn2:(id)sender {
    if (self.block) {
        self.block(SBACK);
    }
}
- (IBAction)onBtn3:(id)sender {
    if (self.block) {
        self.block(JCARK);
    }
}
- (IBAction)onBtn4:(id)sender {
    if (self.block) {
        self.block(HCARD);
    }
}
- (IBAction)onConmitBtn:(id)sender {
    if (self.block) {
        self.block(COMMIT);
    }
}

@end
