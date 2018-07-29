//
//  AliWebViewController.h
//  shengduoduo
//
//  Created by wu on 2017/12/30.
//  Copyright © 2017年 haopintui. All rights reserved.
//

#ifndef AliWebViewController_h
#define AliWebViewController_h

#import <UIKit/UIKit.h>

@interface AliWebViewController : UIViewController<UIWebViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, copy) NSString *openUrl;
@property (strong, nonatomic) UIWebView *webView;

-(UIWebView *)getWebView;

@end

#endif /* AliWebViewController_h */
