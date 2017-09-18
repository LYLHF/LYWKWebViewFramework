//
//  LYIOSWebManager.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 2017/8/31.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "LYWKWebViewController.h"
#import "LYWKWebView.h"

typedef void(^FunctionBlock)(id _Nullable param);

@interface LYIOSWebManager : NSObject<WKScriptMessageHandler>

/**
 为webView创建native-web桥接对象

 @param webView webView
 @return native-web桥接对象
 */
+ (nonnull LYIOSWebManager *)managerForWebView:(nonnull LYWKWebView *)webView;

/**
 为webViewController创建native-web桥接对象
 
 @param webViewController webViewController
 @return native-web桥接对象
 */
+ (nonnull LYIOSWebManager *)managerForWebViewController:(nonnull LYWKWebViewController *)webViewController;

/**
 注册函数

 @param funcName 函数名
 @param funcBlock 函数内容block
 */
- (void)registerFuncName:(NSString * _Nonnull)funcName funcBlock:(FunctionBlock _Nonnull)funcBlock;

@end
