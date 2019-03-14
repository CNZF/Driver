//
//  ContentView.h
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/9/3.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SBRING = 0,
    SBACK,
    JCARK,
    HCARD,
    COMMIT,
} IMAGETYPE;
typedef void (^ClickBlock)(IMAGETYPE index);
@interface ContentView : UIView

@property (nonatomic, copy)ClickBlock block;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *idCardField;


@end
