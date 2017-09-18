//
//  WKWebViewController.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 2017/9/15.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface LYTestManager : NSObject<WKScriptMessageHandler>

@end

@implementation LYTestManager

- (void)dealloc
{
    NSLog(@"LYTestManager dealloc");
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"message:%@", message);
}

@end

@interface WKWebViewController ()

@property (nonatomic, strong) WKUserContentController *userContentController;
//webView
@property (nonatomic, strong, nonnull, readwrite) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)dealloc
{
    [self.userContentController removeScriptMessageHandlerForName:@"login"];
    
    NSLog(@"WKWebViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //OC和JS交互控制器
    self.userContentController = [[WKUserContentController alloc] init];
    
    //webView配置
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
    webViewConfig.userContentController = self.userContentController;
    
    //webView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:webViewConfig];
//    self.webView.navigationDelegate = self;
//    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *localURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    NSURLRequest *localURLRequest = [NSURLRequest requestWithURL:localURL];
    [self.webView loadRequest:localURLRequest];
    
    [self.userContentController addScriptMessageHandler:[[LYTestManager alloc] init] name:@"login"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
