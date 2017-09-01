//
//  LYWKWebView.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYWKWebView.h"

@interface LYWKWebView()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKUserContentController *userContentController;

//html文件下载进度条
@property (nonatomic, strong) UIProgressView *progressView;
//是否应该显示进度条
@property (assign, nonatomic) BOOL shouldShowProgress;

@end

@implementation LYWKWebView

#pragma mark - overwrite

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

/**
 初始化接口

 @param frame frame
 @return instance
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self buildView];
    }
    
    return self;
}

#pragma mark - func

/**
 搭建界面
 */
- (void)buildView
{
    //OC和JS交互控制器
    self.userContentController = [[WKUserContentController alloc] init];
    
    //webView配置
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
    webViewConfig.userContentController = self.userContentController;
    
    //webView
    self.webView = [[WKWebView alloc] initWithFrame:self.bounds
                                      configuration:webViewConfig];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self addSubview:self.webView];
    
    //进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.webView.frame.size.width, self.webView.frame.size.height)];
    self.progressView.progress = 0;
    self.progressView.hidden = YES;
    [self.webView addSubview:self.progressView];
    
    //KVO监听加载进度
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
}

/**
 KVO监听触发方法

 @param keyPath 监听路径
 @param object object
 @param change 被监听对象更新信息
 @param context context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (!self.shouldShowProgress)
    {
        return;
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.estimatedProgress;
        self.progressView.hidden = self.webView.estimatedProgress == 1 ? YES : NO;
    }
}

/**
 加载URL
 
 @param urlString URL地址
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadURLString:(nonnull NSString *)urlString shouldShowProgress:(BOOL)shouldShow
{
    self.shouldShowProgress = shouldShow;
    if ([urlString length] > 0)
    {
        if (!([urlString containsString:@"http://"] || [urlString containsString:@"https://"]))
        {
            urlString = [NSString stringWithFormat:@"http://%@",urlString];
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [self.webView loadRequest:urlRequest];
    }
#ifdef DEBUG
    else
    {
//        [MBProgressHUD showFailHUDwithMsg:@"url为空,加载失败."];
    }
#endif
}

/**
 加载本地文件

 @param source 文件名
 @param extension 文件扩展
 */
- (void)loadLocalSource:(nullable NSString *)source extension:(nullable NSString *)extension
{
    NSURL *localURL = [[NSBundle mainBundle] URLForResource:source withExtension:extension];
    NSURLRequest *localURLRequest = [NSURLRequest requestWithURL:localURL];
    [self.webView loadRequest:localURLRequest];
}

/**
 添加一个script方法

 @param scriptMessageHandler native-web桥接对象
 @param name 方法名
 */
- (void)customAddScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    [self.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    // 页面开始加载时调用
    NSLog(@"didStartProvisionalNavigation:%@", navigation);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    // 当内容开始返回时调用
    NSLog(@"didCommitNavigation:%@", navigation);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 页面加载完成之后调用
    NSLog(@"didFinishNavigation:%@", navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    // 页面加载失败时调用
    NSLog(@"didFinishNavigation:%@", navigation);
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView
        runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
        defaultText:(nullable NSString *)defaultText
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    // 输入框
    completionHandler(@"http");
}

- (void)webView:(WKWebView *)webView
        runJavaScriptConfirmPanelWithMessage:(NSString *)message
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(BOOL result))completionHandler
{
    // 确认框
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView
        runJavaScriptAlertPanelWithMessage:(NSString *)message
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(void))completionHandler
{
    // 警告框
    NSLog(@"%@",message);
    completionHandler();
}


@end
