//
//  LYWKWebView.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol LYWKWebViewDelegate;

@interface LYWKWebView : UIView

//webView
@property (nonatomic, strong, nonnull) WKWebView *webView;

@property (nonatomic, assign, nullable) id<LYWKWebViewDelegate> delegate;

/**
 加载URL
 
 @param urlString URL地址
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadURLString:(NSString * _Nonnull )urlString shouldShowProgress:(BOOL)shouldShow;

/**
 加载本地文件
 
 @param source 文件名
 @param extension 文件扩展
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadLocalSource:(nullable NSString *)source
              extension:(nullable NSString *)extension
     shouldShowProgress:(BOOL)shouldShow;

/**
 添加一个script方法
 
 @param scriptMessageHandler native-web桥接对象
 @param name 方法名
 */
- (void)customAddScriptMessageHandler:(id <WKScriptMessageHandler> _Nonnull)scriptMessageHandler name:(NSString * _Nonnull)name;

@end

@protocol LYWKWebViewDelegate <NSObject>

- (void)webView:(LYWKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)webView:(LYWKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
- (void)webView:(LYWKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
- (void)webView:(LYWKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;

- (void)webView:(LYWKWebView *)webView
        runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
        defaultText:(nullable NSString *)defaultText
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)webView:(LYWKWebView *)webView
        runJavaScriptConfirmPanelWithMessage:(NSString *)message
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(BOOL result))completionHandler;

- (void)webView:(LYWKWebView *)webView
        runJavaScriptAlertPanelWithMessage:(NSString *)message
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(void))completionHandler;

@end
