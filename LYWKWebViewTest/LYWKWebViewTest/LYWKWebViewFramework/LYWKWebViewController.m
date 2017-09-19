//
//  LYWKWebViewController.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 2017/9/1.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYWKWebViewController.h"

@interface LYWKWebViewController ()<LYWKWebViewDelegate>

@property (nonatomic, strong, nonnull, readwrite) LYWKWebView *webView;

@end

@implementation LYWKWebViewController

#pragma mark - overwrite

- (void)dealloc
{
    if (self.webViewControllerMode == WKWebViewDebugMode)
    {
        NSLog(@"LYWKWebViewController dealloc");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazyLoading

- (LYWKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[LYWKWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.webViewMode = self.webViewControllerMode;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

#pragma mark - func

/**
 加载URL
 
 @param urlString URL地址
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadURLString:(NSString * _Nonnull )urlString shouldShowProgress:(BOOL)shouldShow
{
    [self.webView loadURLString:urlString shouldShowProgress:shouldShow];
}

/**
 加载本地文件
 
 @param source 文件名
 @param extension 文件扩展
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadLocalSource:(nullable NSString *)source
              extension:(nullable NSString *)extension
     shouldShowProgress:(BOOL)shouldShow
{
    [self.webView loadLocalSource:source extension:extension shouldShowProgress:shouldShow];
}

/**
 加载javascript字符串
 
 @param javaScriptString javascript字符串
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadJavaScriptString:(NSString *_Nonnull)javaScriptString
          shouldShowProgress:(BOOL)shouldShow
{
    [self.webView loadJavaScriptString:javaScriptString shouldShowProgress:shouldShow];
}

#pragma mark - LYWKWebViewDelegate

- (void)webView:(nonnull LYWKWebView *)webView didStartProvisionalNavigation:(nullable WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:didStartProvisionalNavigation:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
           didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(nonnull LYWKWebView *)webView didCommitNavigation:(nullable WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:didCommitNavigation:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
                     didCommitNavigation:navigation];
    }
}

- (void)webView:(nonnull LYWKWebView *)webView didFinishNavigation:(nullable WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:didFinishNavigation:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
                     didFinishNavigation:navigation];
    }
}

- (void)webView:(nonnull LYWKWebView *)webView didFailProvisionalNavigation:(nullable WKNavigation *)navigation withError:(nullable NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:didFailProvisionalNavigation:withError:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
            didFailProvisionalNavigation:navigation
                               withError:error];
    }
}

- (void)webView:(nonnull LYWKWebView *)webView
        runJavaScriptTextInputPanelWithPrompt:(nullable NSString *)prompt
        defaultText:(nullable NSString *)defaultText
        initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(NSString * __nullable result))completionHandler
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
   runJavaScriptTextInputPanelWithPrompt:prompt
                             defaultText:defaultText
                        initiatedByFrame:frame
                       completionHandler:completionHandler];
    }
}

- (void)webView:(nonnull LYWKWebView *)webView
        runJavaScriptConfirmPanelWithMessage:(nullable NSString *)message
        initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(BOOL result))completionHandler
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
    runJavaScriptConfirmPanelWithMessage:message
                        initiatedByFrame:frame
                       completionHandler:completionHandler];
    }
}

- (void)webView:(nonnull LYWKWebView *)webView
        runJavaScriptAlertPanelWithMessage:(nullable NSString *)message
        initiatedByFrame:(nullable WKFrameInfo *)frame
        completionHandler:(void (^_Nullable)(void))completionHandler
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)])
    {
        [self.delegate webViewController:self
                                 webView:webView
      runJavaScriptAlertPanelWithMessage:message
                        initiatedByFrame:frame
                       completionHandler:completionHandler];
    }
}

@end
