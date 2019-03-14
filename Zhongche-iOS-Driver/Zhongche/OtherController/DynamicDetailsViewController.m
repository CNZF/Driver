//
//  DynamicDetailsViewController.m
//  LogisticsAssistant
//
//  Created by 中车_LL_iMac on 16/9/2.
//  Copyright © 2016年 com.chongche.cn. All rights reserved.
//

#import "DynamicDetailsViewController.h"
#import <WebKit/WebKit.h>

@interface DynamicDetailsViewController()
@property (nonatomic, strong) UIView * web;


@end

@implementation DynamicDetailsViewController

-(void)bindView {
    self.web.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.web];
}

//URL加载网页
-(void)setUrlStr:(NSString *)urlStr {

    if ([urlStr isEqualToString:@""]) {
        urlStr = AboutUsUrl;
    }
    _urlStr = [urlStr copy];
    NSURL* url = [NSURL URLWithString:_urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.web performSelector:@selector(loadRequest:) withObject:request];
}

- (UIView *)web {
    if (!_web) {
             _web = [UIWebView new];
    }
    return _web;
}

@end
