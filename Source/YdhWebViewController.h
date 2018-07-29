//
//  YdhWebViewController.h
//  shengduoduo
//
//  Created by wu on 2017/12/29.
//  Copyright © 2017年 haopintui. All rights reserved.
//

#ifndef YdhWebViewController_h
#define YdhWebViewController_h

#import <UIKit/UIKit.h>
@interface YdhWebViewController : UIViewController<UIWebViewDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

#endif /* YdhWebViewController_h */
