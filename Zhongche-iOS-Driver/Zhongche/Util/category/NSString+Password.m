//
//  NSString+Password.m
//  Zhongche
//
//  Created by 刘磊 on 16/8/1.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "NSString+Password.h"

@implementation NSString (Password)
- (int)theComplexity
{
    int tmp = 0;
    UniChar a;
    for(int i =0; i < [self length]; i++)
    {
        a = [self characterAtIndex:i];
        if ((a >= 'a' && a <= 'z') || (a >= 'A' && a <= 'Z'))
        {
            if (tmp % 10 == 0) {
                tmp += 1;
            }
        }
        else if (a >= '0' && a <= '9')
        {
            if ((tmp % 100) / 10 == 0) {
                tmp += 10;
            }
        }
        else
        {
            if ((tmp % 1000) / 100 == 0) {
                tmp += 100;
            }
        }
    }
    tmp = tmp % 10 + (tmp % 100) / 10 + (tmp % 1000) / 100;
    return tmp;
}
@end
