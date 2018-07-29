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

@end
