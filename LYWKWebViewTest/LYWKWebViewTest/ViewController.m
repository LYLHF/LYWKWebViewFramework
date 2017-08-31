//
//  ViewController.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/8.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "LQWebView.h"

@interface ViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) WKUserContentController *userContentController;

@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation ViewController

#pragma mark - overwrite

- (void)dealloc
{
    [self.userContentController removeScriptMessageHandlerForName:@"readyPay"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self buildView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - func

/**
 搭建界面
 */
- (void)buildView
{
    LQWebView *webView = [[LQWebView alloc] initWithFrame:self.view.bounds];
    [webView loadLocalSource:@"index" extension:@"html"];
    [webView addScriptMethodName:@"diciationaryMethod"];
    [webView addScriptMethodName:@"nativeInit"];
    [self.view addSubview:webView];
    
    return;
    
    self.userContentController = [[WKUserContentController alloc] init];
    [self.userContentController addScriptMessageHandler:self name:@"readyPay"];
    
    //配置
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
    webViewConfig.userContentController = self.userContentController;
    
    //webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                      configuration:webViewConfig];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
//    NSURL *localURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:localURL]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://yiguanjiaclub.org/commerce/detailWeb.html?sid=03a10a1ccc954bc7bd127e065d3697cf&module=trade_manger&goodsUserId=8f96218dd3b94264a5bedb81c4707d31&isDistribution=0"]]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    NSString *htmlPathStr = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPathStr]]];
    [self.view addSubview:self.webView];
    
    //进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.webView.frame.size.width, self.webView.frame.size.height)];
    self.progressView.progress = 0;
    self.progressView.hidden = YES;
    [self.webView addSubview:self.progressView];
    
    //KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = self.webView.estimatedProgress;
        self.progressView.hidden = self.webView.estimatedProgress == 1 ? YES : NO;
    }
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
    
    [self.webView evaluateJavaScript:@"share()"
                   completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                       NSLog(@"completionHandler");
                   }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    // 页面加载失败时调用
    NSLog(@"didFinishNavigation:%@", navigation);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    // 接收到服务器跳转请求之后调用
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation:%@", navigation);
}

- (void)webView:(WKWebView *)webView
        decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
        decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    // 在收到响应后，决定是否跳转
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

- (void)webView:(WKWebView *)webView
        decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
        decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 在发送请求之前，决定是否跳转
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView
               createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
               forNavigationAction:(WKNavigationAction *)navigationAction
               windowFeatures:(WKWindowFeatures *)windowFeatures
{
    // 创建一个新的WebView
    return [[WKWebView alloc]init];
}

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

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"userContentController:%@,\ndidReceiveScriptMessage:%@", userContentController, message);
}

@end
