//
//  LYIOSWebManager.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 2017/8/31.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYIOSWebManager.h"

@interface LYIOSWebManager()

@property (strong, nonatomic) LYWKWebView *bridgedWebView;

@property (strong, nonatomic) NSMutableDictionary <NSString *, FunctionBlock> *scriptMessageDic;

@end

@implementation LYIOSWebManager

#pragma mark - overwrite

- (id)init
{
    if (self = [super init])
    {
        self.scriptMessageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return self;
}

#pragma mark - func

/**
 为webView创建native-web桥接对象
 
 @param webView webView
 @return native-web桥接对象
 */
+ (LYIOSWebManager *)managerFor:(LYWKWebView *)webView
{
    LYIOSWebManager *iOSWebManager = [[LYIOSWebManager alloc] init];
    iOSWebManager.bridgedWebView = webView;

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
    
#warning 存在内存泄露！！！
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
