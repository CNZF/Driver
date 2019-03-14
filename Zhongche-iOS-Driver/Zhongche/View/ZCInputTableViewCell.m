//
//  ZCInputTableViewCell.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/12.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCInputTableViewCell.h"

@interface ZCInputTableViewCell()<UITextFieldDelegate>
@property (nonatomic, assign) int validationSurplusTime;
@property (nonatomic, strong) NSTimer * validationTimer;
@end

@implementation ZCInputTableViewCell

-(void)bindView
{
    self.titleLabel.frame = CGRectMake(20*SCREEN_W_COEFFICIENT, 0*SCREEN_H_COEFFICIENT,90*SCREEN_W_COEFFICIENT, 64*SCREEN_H_COEFFICIENT);
    [self addSubview:self.titleLabel];

    self.inputTextField.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) +10*SCREEN_W_COEFFICIENT,0*SCREEN_H_COEFFICIENT, SCREEN_W - CGRectGetMaxX(self.titleLabel.frame) - 10*SCREEN_W_COEFFICIENT - 20*SCREEN_W_COEFFICIENT , 64*SCREEN_H_COEFFICIENT);
    [self addSubview:self.inputTextField];
    
    self.eyeBut.frame = CGRectMake(SCREEN_W - 20*SCREEN_W_COEFFICIENT - 26*SCREEN_W_COEFFICIENT , CGRectGetMidY(self.inputTextField.frame) - 13*SCREEN_H_COEFFICIENT, 26*SCREEN_W_COEFFICIENT, 16*SCREEN_H_COEFFICIENT);
    [self addSubview:self.eyeBut];
    
    self.validationBut.frame = CGRectMake(SCREEN_W - 120*SCREEN_W_COEFFICIENT, 0*SCREEN_H_COEFFICIENT, 120*SCREEN_W_COEFFICIENT, 64*SCREEN_H_COEFFICIENT);
    [self addSubview:self.validationBut];
}
- (void)bindAction
{
    WS(ws);
    [[self.eyeBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws eyeButAction];
    }];
    [[self.validationBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [ws validationButAction];
    }];

}
-(void)bindModel
{
    self.validationSurplusTime = 0;
    self.textFieldMaxLength = INT_MAX;
}
-(void)eyeButAction
{
    self.eyeBut.selected = !self.eyeBut.selected;
    self.inputTextField.secureTextEntry = !self.inputTextField.secureTextEntry;
}
- (void)validationButAction
{
    self.validationBut.userInteractionEnabled = NO;
    self.validationSurplusTime = 60;
    [self.validationBut setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];
    
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:20.0f*SCREEN_W_COEFFICIENT];
        _titleLabel = label;
    }
    return _titleLabel;
}
- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [UITextField new];
        _inputTextField.delegate = self;
        _inputTextField.font = [UIFont systemFontOfSize:20.0f*SCREEN_W_COEFFICIENT];
    }
    return _inputTextField;
}
- (UIButton *)eyeBut
{
    if (!_eyeBut) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"眼睛"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"眼睛-拷贝"] forState:UIControlStateSelected];
        _eyeBut = button;
    }
    return _eyeBut;
}
- (UIButton *)validationBut
{
    if (!_validationBut) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18 * SCREEN_H_COEFFICIENT];
        [button setTitleColor:APP_COLOR_BLUE forState:UIControlStateNormal];
        _validationBut = button;
    }
    return _validationBut;
}
/**
 *  更新验证码时间
 */
-(void)updateVerificatetime
{
    self.validationSurplusTime --;
    [self.validationBut setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    if (self.validationSurplusTime == 0) {
        [self.validationBut setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_validationTimer invalidate];
        self.validationBut.userInteractionEnabled = YES;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= self.textFieldMaxLength) {
        return NO;
    }
    return YES;
}
@end
