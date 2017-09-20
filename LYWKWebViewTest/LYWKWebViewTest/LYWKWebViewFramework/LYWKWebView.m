//
//  LYWKWebView.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYWKWebView.h"

@implementation NSString (Category)

/**
 字符串UTF-8编码
 
 @return 编码后的字符串
 */
- (nullable NSString *)customEncodingString
{
    if (self.length > 0)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
        {
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:self];
            return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        }else{
            return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    return nil;
}

@end

@implementation NSURL (Category)

/**
 网址字符串转为可加载的url(主要针对有汉字的网址字符串)
 
 @param URLString url字符串
 @return url
 */
+ (nullable NSURL *)customURLWithString:(nonnull NSString *)URLString
{
    if ([URLString length] > 0)
    {
        return [NSURL URLWithString:[URLString customEncodingString]];
    }
    
    return nil;
}

@end

@interface LYWKWebView()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKUserContentController *userContentController;
//webView
@property (nonatomic, strong, nonnull, readwrite) WKWebView *webView;
//注册的方法的列表
@property (nonatomic, strong) NSMutableArray<NSString *> *scriptMessageNameArray;

//html文件下载进度条
@property (nonatomic, strong) UIProgressView *progressView;
//是否应该显示进度条
@property (assign, nonatomic) BOOL shouldShowProgress;

@end

@implementation LYWKWebView

#pragma mark - overwrite

- (void)dealloc
{
    for (int index = 0; index < [self.scriptMessageNameArray count]; index ++)
    {
        [self.userContentController removeScriptMessageHandlerForName:self.scriptMessageNameArray[index]];
    }
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    if (self.webViewMode == WKWebViewDebugMode)
    {
        NSLog(@"LYWKWebView dealloc");
    }
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
        self.scriptMessageNameArray = [NSMutableArray arrayWithCapacity:0];
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
    [self.webView.scrollView addSubview:self.progressView];
    
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
                        change:(NSDictionary<NSString *,id> *)change
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
- (void)loadURLString:(NSString * _Nonnull )urlString shouldShowProgress:(BOOL)shouldShow
{
    self.shouldShowProgress = shouldShow;
    if ([urlString length] > 0)
    {
        if (!([urlString containsString:@"http://"] || [urlString containsString:@"https://"]))
        {
            urlString = [NSString stringWithFormat:@"http://%@",urlString];
        }
        if (self.webViewMode == WKWebViewDebugMode)
        {
            NSLog(@"URLString:%@", urlString);
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL customURLWithString:urlString]];
        [self.webView loadRequest:urlRequest];
    }else if(self.webViewMode == WKWebViewDebugMode)
    {
        NSLog(@"url为空,加载失败");        
    }
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
    self.shouldShowProgress = shouldShow;
    NSURL *localURL = [[NSBundle mainBundle] URLForResource:source withExtension:extension];
    if (self.webViewMode == WKWebViewDebugMode)
    {
        NSLog(@"localSourcePath:%@", localURL);
    }
    NSURLRequest *localURLRequest = [NSURLRequest requestWithURL:localURL];
    [self.webView loadRequest:localURLRequest];
}

/**
 加载javascript字符串
 
 @param javaScriptString javascript字符串
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadJavaScriptString:(NSString *_Nonnull)javaScriptString
          shouldShowProgress:(BOOL)shouldShow
{
    self.shouldShowProgress = shouldShow;
    if (self.webViewMode == WKWebViewDebugMode)
    {
        NSLog(@"loadJavaScriptString:%@", javaScriptString);
    }
    __weak typeof(self) weakSelf = self;
    [self.webView evaluateJavaScript:javaScriptString
                   completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                       if ((weakSelf.webViewMode == WKWebViewDebugMode) &&
                           (error != nil))
                       {
                           NSLog(@"javaScript load fail:%@", error);
                       }
                   }];
}

/**
 添加一个script方法

 @param scriptMessageHandler native-web桥接对象
 @param name 方法名
 */
- (void)customAddScriptMessageHandler:(id <WKScriptMessageHandler> _Nonnull)scriptMessageHandler name:(NSString * _Nonnull)name
{
    if (([name length] > 0) && (scriptMessageHandler != nil))
    {
        [self.scriptMessageNameArray addObject:name];
        [self.userContentController addScriptMessageHandler:scriptMessageHandler name:name];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    //页面开始加载时调用
    if ([self.delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)])
    {
        [self.delegate webView:self didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    //当内容开始返回时调用
    if ([self.delegate respondsToSelector:@selector(webView:didCommitNavigation:)])
    {
        [self.delegate webView:self didCommitNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    //页面加载完成之后调用
    if ([self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)])
    {
        [self.delegate webView:self didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    //页面加载失败时调用
    if ([self.delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)])
    {
        [self.delegate webView:self didFailProvisionalNavigation:navigation withError:error];
    }
    NSLog(@"didFinishNavigation:%@", navigation);
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView
        runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
        defaultText:(nullable NSString *)defaultText
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    //输入框
    if ([self.delegate respondsToSelector:@selector(webView:
                                                    runJavaScriptTextInputPanelWithPrompt:
                                                    defaultText:
                                                    initiatedByFrame:
                                                    completionHandler:)])
    {
        [self.delegate webView:self
                       runJavaScriptTextInputPanelWithPrompt:prompt
                       defaultText:defaultText
                       initiatedByFrame:frame
                       completionHandler:completionHandler];
    }
}

- (void)webView:(WKWebView *)webView
        runJavaScriptConfirmPanelWithMessage:(NSString *)message
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(BOOL result))completionHandler
{
    //确认框
    if ([self.delegate respondsToSelector:@selector(webView:
                                                    runJavaScriptConfirmPanelWithMessage:
                                                    initiatedByFrame:
                                                    completionHandler:)])
    {
        [self.delegate webView:self
                       runJavaScriptConfirmPanelWithMessage:message
                       initiatedByFrame:frame
                       completionHandler:completionHandler];
    }
}

- (void)webView:(WKWebView *)webView
        runJavaScriptAlertPanelWithMessage:(NSString *)message
        initiatedByFrame:(WKFrameInfo *)frame
        completionHandler:(void (^)(void))completionHandler
{
    //提示框
    if ([self.delegate respondsToSelector:@selector(webView:
                                                    runJavaScriptAlertPanelWithMessage:
                                                    initiatedByFrame:)])
    {
        [self.delegate webView:self
                       runJavaScriptAlertPanelWithMessage:message
                       initiatedByFrame:frame];
    }
    if (self.webView != nil)
    {
        completionHandler();
    }
}

@end
