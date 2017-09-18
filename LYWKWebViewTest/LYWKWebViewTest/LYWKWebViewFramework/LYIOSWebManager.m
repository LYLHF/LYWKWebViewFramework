//
//  LYIOSWebManager.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 2017/8/31.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYIOSWebManager.h"
#import <objc/runtime.h>

static NSString * const bridgedWebViewAssociatedKey = @"bridgedWebViewAssociatedKey";

@interface LYIOSWebManager()

@property (weak, nonatomic) LYWKWebView *bridgedWebView;

@property (strong, nonatomic) NSMutableDictionary <NSString *, FunctionBlock> *scriptMessageDic;

@end

@implementation LYIOSWebManager

#pragma mark - overwrite

- (void)dealloc
{
    if (self.bridgedWebView.webViewMode == WKWebViewDebugMode)
    {
        NSLog(@"LYIOSWebManager dealloc");
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.scriptMessageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return self;
}

#pragma mark - property

//- (void)setBridgedWebView:(LYWKWebView *)tempBridgedWebView
//{
//    objc_setAssociatedObject(self, &bridgedWebViewAssociatedKey, tempBridgedWebView, OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (LYWKWebView *)bridgedWebView
//{
//    if ([objc_getAssociatedObject(self, &bridgedWebViewAssociatedKey) isKindOfClass:[LYWKWebView class]])
//    {
//        return objc_getAssociatedObject(self, &bridgedWebViewAssociatedKey);
//    }
//    
//    return nil;
//}

#pragma mark - func

/**
 为webView创建native-web桥接对象
 
 @param webView webView
 @return native-web桥接对象
 */
+ (nonnull LYIOSWebManager *)managerForWebView:(nonnull LYWKWebView *)webView
{
    LYIOSWebManager *iOSWebManager = [[LYIOSWebManager alloc] init];
    iOSWebManager.bridgedWebView = webView;

    return iOSWebManager;
}

/**
 为webViewController创建native-web桥接对象
 
 @param webViewController webViewController
 @return native-web桥接对象
 */
+ (LYIOSWebManager *)managerForWebViewController:(LYWKWebViewController *)webViewController
{
    LYIOSWebManager *iOSWebManager = [[LYIOSWebManager alloc] init];
    iOSWebManager.bridgedWebView = webViewController.webView;
    
    return iOSWebManager;
}

/**
 注册函数
 
 @param funcName 函数名
 @param funcBlock 函数内容block
 */
- (void)registerFuncName:(NSString * _Nonnull)funcName funcBlock:(FunctionBlock _Nonnull)funcBlock
{
    if (([funcName length] > 0) &&
        (funcBlock != nil))
    {
        [self.scriptMessageDic setValue:funcBlock forKey:funcName];
    }
    
    [self.bridgedWebView customAddScriptMessageHandler:self name:funcName];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (message.webView != self.bridgedWebView.webView)
    {
        return;
    }
    
    NSString *funcName = message.name;
    if ([[self.scriptMessageDic allKeys] containsObject:funcName])
    {
        FunctionBlock functionBlock = self.scriptMessageDic[funcName];
        if (functionBlock)
        {
            functionBlock(message.body);
        }
    }
}

@end
