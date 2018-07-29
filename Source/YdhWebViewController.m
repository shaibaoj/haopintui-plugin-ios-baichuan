//
//  YdhWebViewController.m
//  shengduoduo
//
//  Created by wu on 2017/12/29.
//  Copyright © 2017年 haopintui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YdhWebViewController.h"

@interface YdhWebViewController()

@end

@implementation YdhWebViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.scrollView.scrollEnabled = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return self;
}

- (void)viewDidLoad
{
    self.title=@"淘你喜欢";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
    //    [AppMonitor turnOnAppMonitorRealtimeDebug:@{@"debug_api_url":@"http://muvp.alibaba-inc.com/online/UploadRecords.do",@"debug_key":@"baichuan_sdk_utDetection"}];
    
}

@end
