//
//  LYWKWebView.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface NSString (Category)

/**
 字符串UTF-8编码
 
 @return 编码后的字符串
 */
- (nullable NSString *)customEncodingString;

@end

@interface NSURL (Category)

/**
 网址字符串转为可加载的url(主要针对有汉字的网址字符串)
 
 @param URLString url字符串
 @return url
 */
+ (nullable NSURL *)customURLWithString:(nonnull NSString *)URLString;

@end

typedef NS_ENUM(NSInteger, WKWebViewMode) {
    WKWebViewDebugMode,     //联调模式(会打印日志)
    WKWebViewReleaseMode    //生产模式
};

@protocol LYWKWebViewDelegate;

@interface LYWKWebView : UIView

//webView
@property (nonatomic, strong, nonnull, readonly) WKWebView *webView;
//代理
@property (nonatomic, weak, nullable) id<LYWKWebViewDelegate> delegate;
//模式
@property (nonatomic, assign) WKWebViewMode webViewMode;

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

- (void)webView:(nonnull LYWKWebView *)webView didStartProvisionalNavigation:(nullable WKNavigation *)navigation;
- (void)webView:(nonnull LYWKWebView *)webView didCommitNavigation:(nullable WKNavigation *)navigation;
- (void)webView:(nonnull LYWKWebView *)webView didFinishNavigation:(nullable WKNavigation *)navigation;
- (void)webView:(nonnull LYWKWebView *)webView didFailProvisionalNavigation:(nullable WKNavigation *)navigation withError:(nullable NSError *)error;

- (void)webView:(nonnull LYWKWebView *)webView
        runJavaScriptTextInputPanelWithPrompt:(nullable NSString *)prompt
        defaultText:(nullable NSString *)defaultText
        initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(NSString * __nullable result))completionHandler;

- (void)webView:(nonnull LYWKWebView *)webView
        runJavaScriptConfirmPanelWithMessage:(nullable NSString *)message
        initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(BOOL result))completionHandler;

- (void)webView:(nonnull LYWKWebView *)webView
        runJavaScriptAlertPanelWithMessage:(nullable NSString *)message
        initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(void))completionHandler;

@end
