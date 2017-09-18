//
//  LYWKWebViewController.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 2017/9/1.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYWKWebView.h"

@protocol LYWKWebViewControllerDelegate;

@interface LYWKWebViewController : UIViewController

@property (nonatomic, strong, nonnull, readonly) LYWKWebView *webView;
//代理
@property (nonatomic, weak, nullable) id<LYWKWebViewControllerDelegate> delegate;
//模式
@property (nonatomic, assign) WKWebViewMode webViewControllerMode;

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

@end

@protocol LYWKWebViewControllerDelegate <NSObject>

- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
        didStartProvisionalNavigation:(nullable WKNavigation *)navigation;
- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
      didCommitNavigation:(nullable WKNavigation *)navigation;
- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
      didFinishNavigation:(nullable WKNavigation *)navigation;
- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
        didFailProvisionalNavigation:(nullable WKNavigation *)navigation
                withError:(nullable NSError *)error;

- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
        runJavaScriptTextInputPanelWithPrompt:(nullable NSString *)prompt
              defaultText:(nullable NSString *)defaultText
         initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(NSString * __nullable result))completionHandler;

- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
        runJavaScriptConfirmPanelWithMessage:(nullable NSString *)message
         initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(BOOL result))completionHandler;

- (void)webViewController:(nonnull LYWKWebViewController *)webViewController
                  webView:(nonnull LYWKWebView *)webView
        runJavaScriptAlertPanelWithMessage:(nullable NSString *)message
         initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(void))completionHandler;

@end
