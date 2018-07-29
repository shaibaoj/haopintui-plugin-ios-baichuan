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
#import <WeexPluginLoader/WeexPluginLoader/WeexPluginLoader.h>

WX_PlUGIN_EXPORT_MODULE(baichuan, BaichuanModule)

@implementation BaichuanModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(open_url:))
WX_EXPORT_METHOD(@selector(open_item:callback:))
WX_EXPORT_METHOD(@selector(openURL:callback:))

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

@end
