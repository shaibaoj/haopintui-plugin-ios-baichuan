//
//  ALiWebViewController.m
//  shengduoduo
//
//  Created by wu on 2017/12/30.
//  Copyright © 2017年 haopintui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliWebViewController.h"

@interface AliWebViewController()

@end

@implementation AliWebViewController

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
    [super viewDidLoad];
    self.title=@"淘你喜欢";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}
-(void)dealloc
{
    NSLog(@"dealloc  view");
    _webView =  nil;
}

-(UIWebView *)getWebView{
    return  _webView;
}

- (UIWebView *)webView
{
//    if (!_webView) {
////        NSUInteger *K_SCREEN_WIDTH = 1000;
////        CGFloat *K_SCREEN_HEIGHT = [NSNumber numberWithFloat:10.01];
//
////        CGFloat height = K_SCREEN_HEIGHT - 64;
////        if (!self.routerInfo.navShow) {
////            height = K_SCREEN_HEIGHT;
////        }
////        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1000, 10)];
//        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, 320, 10)];
//
////        _webView.backgroundColor = K_BACKGROUND_COLOR;
//        _webView.delegate = self;
//        [self.view addSubview:_webView];
//    }
    return _webView;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}


@end
