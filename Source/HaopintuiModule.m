//
//  HaopintuiModule.m
//  PluginHaopintui
//
//  Created by wu on 2018/7/20.
//

#import <Foundation/Foundation.h>
#import "HaopintuiModule.h"
#import <UIKit/UIKit.h>
#import <WeexSDK/WXBaseViewController.h>
#import "ALiTradeSDKShareParam.h"
#import "WXUtility.h"
#import "WXComponent_internal.h"
#import "WXComponentManager.h"
#import "WXThreadSafeMutableDictionary.h"
#import <WeexPluginLoader/WeexPluginLoader/WeexPluginLoader.h>
#import "BMConfigManager.h"
#import <CoreTelephony/CTCellularData.h>

WX_PlUGIN_EXPORT_MODULE(haopintui, HaopintuiModule)

@implementation HaopintuiModule

@synthesize weexInstance;

WX_EXPORT_METHOD_SYNC(@selector(getAppName))
WX_EXPORT_METHOD_SYNC(@selector(isInstall:))

- (NSString*)getAppName
{
    return [BMConfigManager shareInstance].platform.appName;
//    return nil;
}

/**
 检测网络权限
 @return 是否有权限 0 关闭 1 仅wifi 2 流量+wifi
 */
+ (int)checkNetWorkPermission
{
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc]init];
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        return state;
    } else {
        // Fallback on earlier versions
        return 2;
    }
}

/** 判断是否安装了微信 */
-(BOOL)isInstall:(NSDictionary *)urlParams
{
//    NSString* packageName; // 结果字符串
    NSString *scheme = nil;
    NSString *packageName = nil;
    
    if(urlParams[@"scheme"]){
        scheme = [WXConvert NSString:urlParams[@"scheme"]];
    }
    if(urlParams[@"packageName"]){
        packageName = [WXConvert NSString:urlParams[@"packageName"]];
    }
    
    scheme = [scheme stringByAppendingString: @"://"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]){
        return true;
    }else{
        return false;
    }
}

/** 打开其他app */
-(BOOL)open:(NSDictionary *)urlParams
{
    NSString *scheme = nil;
    NSString *packageName = nil;
    NSString *url = nil;
    
    if(urlParams[@"scheme"]){
        scheme = [WXConvert NSString:urlParams[@"scheme"]];
    }
    if(urlParams[@"packageName"]){
        packageName = [WXConvert NSString:urlParams[@"packageName"]];
    }
    if(urlParams[@"url"]){
        url = [WXConvert NSString:urlParams[@"url"]];
    }
    
    if ([[UIApplication sharedApplication]
         canOpenURL:[NSURL URLWithString:url]])
    {
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL error"
                    message:[NSString stringWithFormat:
                             @"没有定义的访问连接%@", url]
                   delegate:self cancelButtonTitle:@"Ok"
          otherButtonTitles:nil];
        [alert show];
        return false;
    }
}

@end
