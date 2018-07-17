//
//  BaichuanModule.m
//  shengduoduo
//
//  Created by wu on 2017/12/29.
//  Copyright © 2017年 haopintui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaichuanModule.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <UIKit/UIKit.h>
#import <WeexSDK/WXBaseViewController.h>
#import "ALiWebViewController.h"
#import "ALiTradeSDKShareParam.h"
#import "WXUtility.h"
#import "WXComponent_internal.h"
#import "WXComponentManager.h"
#import "WXThreadSafeMutableDictionary.h"
#import "ALiDemoMainViewController.h"

@implementation BaichuanModule

WX_EXPORT_METHOD(@selector(setString:))
WX_EXPORT_METHOD(@selector(getString:))
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(openURL:callback:))


WX_EXPORT_METHOD(@selector(open_url:))
- (void)open_url:(NSDictionary *)urlParams {
    
    id<AlibcTradePage> page = nil;
    if( [urlParams[@"page_type"] isEqualToString:@"item"]){
        NSString * value = [WXConvert NSString:urlParams[@"num_iid"]];
        page = [AlibcTradePageFactory itemDetailPage:value];
    }
    else if( [urlParams[@"page_type"] isEqualToString: @"shop"]){
        NSString * value = [WXConvert NSString:urlParams[@"shopid"]];
        page = [AlibcTradePageFactory shopPage: value];
    }
    else if( [urlParams[@"page_type"] isEqualToString: @"addCart"]){
        NSString * value = [WXConvert NSString:urlParams[@"num_iid"]];
        page = [AlibcTradePageFactory addCartPage:value];
    }
    else if( [urlParams[@"page_type"] isEqualToString: @"order"]){
        page = [AlibcTradePageFactory myOrdersPage:0 isAllOrder:YES];
    }
    else if( [urlParams[@"page_type"] isEqualToString: @"cart"]){
        page = [AlibcTradePageFactory myCartsPage];
    }
    else{
        NSString * value = [WXConvert NSString:urlParams[@"url"]];
        page = [AlibcTradePageFactory page:value];
    }
    
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
    showParams.backUrl=@"tbopen24734096";
    if(urlParams[@"backUrl"]){
        NSString *backUrl = [WXConvert NSString:urlParams[@"backUrl"]];
        if([backUrl length] != 0){
            showParams.backUrl=backUrl;
        }
    }
//    showParams.backUrl=@"tbopen24734096";
    showParams.isNeedPush=YES;
    showParams.linkKey=@"taobao_scheme";
    
    AlibcTradeTaokeParams *taoke = [[AlibcTradeTaokeParams alloc] init];
    taoke.pid =[[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"pid"];
    taoke.subPid = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"subPid"];
    taoke.unionId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"unionId"];
    taoke.adzoneId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"adzoneId"];
    taoke.extParams = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"extParams"];
    
    if(urlParams[@"pid"]){
        NSString *pid = [WXConvert NSString:urlParams[@"pid"]];
        if([pid length] != 0){
            NSRange range = [pid rangeOfString:@"mm_"];
            if(range.length != 0){
                pid=[pid stringByReplacingOccurrencesOfString:@"mm_" withString:@""];
            }
            NSArray *pid_arry = [pid componentsSeparatedByString:@"_"];
            if([pid_arry count]>1){
                taoke.unionId =  [pid_arry objectAtIndex:1];
            }
            if([pid_arry count]>2){
                taoke.adzoneId =  [pid_arry objectAtIndex:2];
            }
            taoke.pid = pid;
            taoke.subPid = pid;
        }
        if(urlParams[@"taokeAppkey"]){
            NSString *taokeAppkey = [WXConvert NSString:urlParams[@"taokeAppkey"]];
            if([taokeAppkey length] != 0){
                taoke.extParams = @{@"taokeAppkey":taokeAppkey};
            }
        }
    }
    
    UIViewController *currentVC = (UIViewController *)   [self currentVC];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
         AliWebViewController* viewController = [[AliWebViewController alloc] init];
        
        // @return 0标识跳转到手淘打开了,1标识用h5打开,-1标识出错
        NSInteger res = [service
                         show:showParams.isNeedPush?currentVC.navigationController:currentVC
                     webView:viewController.webView
                     page:page
                     showParams:showParams
                     taoKeParams:nil
                     trackParam:nil
                     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                         
                     }
                     tradeProcessFailedCallback:^(NSError * _Nullable error) {
                         
                     }];
        if (res == 1) {
            [currentVC.navigationController pushViewController:viewController animated:YES];
        }
    });
    
   
//    if ([currentVC isKindOfClass:[UINavigationController class]]) {
//        [(UINavigationController *)currentVC pushViewController:viewController animated:YES];
//    }else{
//        [currentVC.navigationController pushViewController:viewController animated:YES];
//    }
    
    // 绑定WebView
//    UIViewController *currentVC = [self currentVC];
//    AliWebViewController* view = [[AliWebViewController alloc] init];
//    if ([currentVC isKindOfClass:[UINavigationController class]]) {
////        [(UINavigationController *)currentVC pushViewController:viewController animated:YES];
//    }else{
////        [view.navigationController pushViewController:viewController animated:YES];
//        currentVC  = currentVC.navigationController;
//    }

    // @return 0标识跳转到手淘打开了,1标识用h5打开,-1标识出错
//    NSInteger res = [service
//                 show:currentVC
//                                      webView:viewController.webView
//                 page:page
//                 showParams:showParams
//                 taoKeParams:taoke
//                 trackParam:nil
//                 tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//                 }
//                 tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//                 }];
//    // @return 0标识跳转到手淘打开了,1标识用h5打开,-1标识出错
//    if (res == 1) {
////        [currentVC.navigationController pushViewController:view animated:YES];
//
////        AliWebViewController* view = [[AliWebViewController alloc] init];
////        [currentVC.navigationController pushViewController:view animated:YES];
//    }
    
}

- (void)openURL:(NSString *)url callback:(WXModuleCallback)callback
{
    NSString *newURL = url;
    if ([url hasPrefix:@"//"]) {
        newURL = [NSString stringWithFormat:@"http:%@", url];
    } else if (![url hasPrefix:@"http"]) {
        newURL = [NSURL URLWithString:url relativeToURL:weexInstance.scriptURL].absoluteString;
    }
    
//    UIViewController *controller = [[WXDemoViewController alloc] init];
//    ((WXDemoViewController *)controller).url = [NSURL URLWithString:newURL];
//    [[weexInstance.viewController navigationController] pushViewController:controller animated:YES];
    callback(@{@"result":@"success"});
}

WX_EXPORT_METHOD_SYNC(@selector(getString))

- (NSString *)getString
{
    return @"今天的天气很好啊";
}

WX_EXPORT_METHOD(@selector(open_url1:))
- (void)open_url1:(NSString *)num_iid {
    
    //    id<AlibcTradePage> page = [AlibcTradePageFactory page:self.urlTextField.text];
//    id<AlibcTradePage> page = [AlibcTradePageFactory page:@"https://uland.taobao.com/coupon/edetail?activityId=1b35209ae5764f6298168d6c9399f0a1&itemId=553614872356&pid=mm_12345678_16632351_61882985&mt=1&src=tkm_tkmwz"];
//    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
//    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
//    showParams.openType = AlibcOpenTypeNative;
//    showParams.backUrl=@"tbopen24734096://";
//    showParams.isNeedPush=YES;
    
//    AlibcWebViewController* view = [[AlibcWebViewController alloc] init];
//    UIViewController *view = [self currentVC];
//
//    [service
//     show:showParams.isNeedPush ? [view navigationController] : view
//     page:page
//     showParams:showParams
//     taoKeParams:nil
//     trackParam:nil
//     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//     }];
    
//    AlibcWebViewController *viewController =
//    [[ALiWebViewController alloc] initWithNibName:NSStringFromClass([ALiWebViewController class])
//                                               bundle:nil];
//    [[self currentNVC] pushViewController:viewController animated:YES];
    
    AlibcTradeTaokeParams *taoke = [[AlibcTradeTaokeParams alloc] init];
    taoke.pid =[[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"pid"];
    taoke.subPid = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"subPid"];
    taoke.unionId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"unionId"];
    taoke.adzoneId = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"adzoneId"];
    taoke.extParams = [[ALiTradeSDKShareParam sharedInstance].taoKeParams objectForKey:@"extParams"];
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page:@"https://uland.taobao.com/coupon/edetail?activityId=1b35209ae5764f6298168d6c9399f0a1&itemId=553614872356&pid=mm_12345678_16632351_61882985&mt=1&src=tkm_tkmwz"];
    
//    page = [AlibcTradePageFactory itemDetailPage:@"534920269060"];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeNative;
//    showParams.backUrl=@"tbopen24734096://";
    showParams.isNeedPush=YES;
    
    // 绑定WebView
    
//    AlibcWebViewController* vc = [[AlibcWebViewController alloc] init];
    UIViewController *view = [self currentVC];
    
    // @return 0标识跳转到手淘打开了,1标识用h5打开,-1标识出错
    NSInteger res = [service
                     show:view
//                     webView:vc.webView
                     page:page
                     showParams:showParams
                     taoKeParams:taoke
                     trackParam:nil
                     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                         
                     }
                     tradeProcessFailedCallback:^(NSError * _Nullable error) {
                         
                     }];
    // @return 0标识跳转到手淘打开了,1标识用h5打开,-1标识出错
    if (res == 1) {
        [view.navigationController pushViewController:view animated:YES];
    }
    
}

WX_EXPORT_METHOD(@selector(open_item:callback:))
- (void)open_item:(NSString *)num_iid callback:(WXModuleCallback)callback
{
    //打开商品详情页
//    id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage: @"562757894594"];
    
//    //添加商品到购物车
//    id<AlibcTradePage> page = [AlibcTradePageFactory addCartPage: @"123456"];
//
//    //根据链接打开页面
//    id<AlibcTradePage> page = [AlibcTradePageFactory page: @"https://h5.m.taobao.com/cm/snap/index.html?id=527140984722"];
//
//    //打开店铺
//    id<AlibcTradePage> page = [AlibcTradePageFactory shopPage: @”12333333”];
//
//    //打开我的订单页
//    id<AlibcTradePage> page = [AlibcTradePageFactory myOrdersPage:0 isAllOrder:YES];
    
//    //打开我的购物车
//    id<AlibcTradePage> page = [AlibcTradePageFactory myCartsPage];
    
    
    //淘客信息
    AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid=@"mm_116920901_15372983_59176748"; //
    //打开方式
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
//    showParam.openType = AlibcOpenTypeH5;
    
//    showParam.nativeFailMode=AlibcNativeFailModeJumpH5;
    
    showParam.openType = AlibcOpenTypeNative;
//    showParam.backUrl=@"tbopen24734096://";
//    showParam.isNeedPush=YES;
    
//    UIViewController *controller = [[UIViewController alloc] init];
//    UIViewController *controller = [UIViewController new];
//    AlibcWebViewController* view = [[AlibcWebViewController alloc] init];
//    UIViewController *view = [self currentNVC];
//    UIViewController *view = [self currentVC];
    
    AlibcWebViewController* view = [[AlibcWebViewController alloc] init];
//    showParam.backUrl=@"tbopenxxxxxxxx://";
    showParam.isNeedPush=YES;
//    showParam.nativeFailMode=AlibcNativeFailModeJumpH5;
    
//    NSInteger ret = [[AlibcTradeSDK sharedInstance].tradeService show: view page:page showParams:showParam taoKeParams: nil trackParam: nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//    }];
    
    
    
//    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
//    [service
//     show:showParam.isNeedPush ? self.navigationController : self
//     page:page
//     showParams:showParams
//     taoKeParams:nil
//     trackParam:nil
//     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//     }];
    
    
//    callback(@{@"result":@"success"});
    
    id<AlibcTradePage> page = [AlibcTradePageFactory page:@"https://uland.taobao.com/coupon/edetail?activityId=1b35209ae5764f6298168d6c9399f0a1&itemId=553614872356&pid=mm_12345678_16632351_61882985&mt=1&src=tkm_tkmwz"];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    AlibcTradeShowParams *showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeAuto;
    
    [service
     show:showParams.isNeedPush ? [view navigationController] : view
     page:page
     showParams:showParams
     taoKeParams:nil
     trackParam:nil
     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
         
     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         
     }];
    
}

- (dispatch_queue_t)targetExecuteQueue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)setString:(NSString *)content
{
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    clipboard.string = (content ? : @"");
}

- (void)getString:(WXModuleCallback)callback{
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    NSDictionary *result = [@{} mutableCopy];
    if(clipboard.string)
    {
        [result setValue:clipboard.string forKey:@"data"];
        [result setValue:@"success" forKey:@"result"];
    }else
    {
        [result setValue:@"" forKey:@"data"];
        [result setValue:@"fail" forKey:@"result"];
    }
    if (callback) {
        callback(result);
    }
}

//-(void)pushViewController:(NSString *)vcName param:(NSDictionary *)param{
//
//    //获取类
//    Class vcClass = NSClassFromString(vcName);
//    if (vcClass == nil) {
//        return;
//    }
//
//    BaseViewController *vc = [[vcClass alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//
//    //属性数量
//    unsigned int count = 0;
//
//    //获取属性列表
//    objc_property_t *plist = class_copyPropertyList(vcClass, &count);
//
//
//    for (int i = 0; i<count; i++) {
//
//        //取出属性
//        objc_property_t property = plist[i];
//
//        //取出属性名称
//        NSString *propertyName =  [NSString stringWithUTF8String:property_getName(property)];
//
//        //以这个属性名称作为key ,查看传入的字典里是否有这个属性的value
//        if (param[propertyName]) {
//
//            [vc setValue:param[propertyName] forKey:propertyName];
//        }
//    }
//
//    //释放
//    free(plist);
//
//    //获取当前页面控制器
//    /*
//     获取当前页面控制器是根据响应链获取的。
//     */
//    UIViewController *currentVC = [Utils getCurrentVC];
//    if ([currentVC isKindOfClass:[UINavigationController class]]) {
//        [(UINavigationController *)currentVC pushViewController:vc animated:YES];
//    }else{
//        [currentVC.navigationController pushViewController:vc animated:YES];
//    }
//}


//@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(toast:))
WX_EXPORT_METHOD(@selector(alert:callback:))
WX_EXPORT_METHOD(@selector(confirm:callback:))

- (void)confirm:(NSDictionary *)param callback:(WXModuleCallback)callback
{
    NSString *message = [self stringValue:param[@"message"]];
    NSString *okTitle = [self stringValue:param[@"okTitle"]];
    NSString *cancelTitle = [self stringValue:param[@"cancelTitle"]];
    if (okTitle.length==0) {
        okTitle = @"确认";
    }
    if (cancelTitle.length==0) {
        cancelTitle = @"取消";
    }
    /* 此处为自己的弹框组件或者系统的组件 */
    
    /**/
    callback(okTitle);
    
}

- (void)toast:(NSDictionary *)param{
    NSString *message = [NSString stringWithFormat:@"%@",param[@"message"]];
    if (!message) return;
    /* 此处为自己的toast 组件 */
    
    /**/
    
}

- (void)alert:(NSDictionary *)param callback:(WXModuleCallback)callback
{
    NSString *message = [self stringValue:param[@"message"]];
    NSString *okTitle = [self stringValue:param[@"okTitle"]];
    /* 此处为自己的弹框组件或者系统的组件 */
    
    /**/
    callback(okTitle);
}

// 获取当前NVC
-(UINavigationController *)currentNVC{
    return [self.weexInstance.viewController navigationController];
}
// 获取当前VC
-(UIViewController *)currentVC{
    return self.weexInstance.viewController;
}

- (NSString*)stringValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (void)simpleUIWebViewTest {
    // 1.创建webview，并设置大小，"20"为状态栏高度
    CGFloat width = weexInstance.rootView.frame.size.width;
    CGFloat height = weexInstance.rootView.frame.size.height - 20;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, width, height)];
    // 2.创建URL
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [webView loadRequest:request];
    // 5.最后将webView添加到界面
    [weexInstance.rootView addSubview:webView];
    weexInstance.rootView = webView;
}

@end
