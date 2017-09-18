//
//  ViewController.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/8.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
#import "LYWKWebViewController.h"
#import "WKWebViewController.h"
#import "LYWKWebView.h"
#import "LYIOSWebManager.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - overwrite

- (void)dealloc
{

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
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - func

/**
 搭建界面
 */
- (void)buildView
{
    LYWKWebView *webView = [[LYWKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 150)];
    webView.webViewMode = WKWebViewReleaseMode;
    [webView loadLocalSource:@"index"
                   extension:@"html"
          shouldShowProgress:YES];
//    [webView loadURLString:@"http://yiguanjiaclub.org/commerce/listBanel.html?sid=863DE9933E5E9EF05876FF0917653A52" shouldShowProgress:YES];
    LYIOSWebManager *iOSWebManager = [LYIOSWebManager managerForWebView:webView];
    [iOSWebManager registerFuncName:@"login" funcBlock:^(id param){
        NSLog(@"login");
    }];
    [self.view addSubview:webView];
    
    return;
}

/**
 使用系统WKWebView

 @param sender nil
 */
- (IBAction)nativePushClick:(id)sender
{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 使用对于WKWebView的封装类LYWKWebViewController

 @param sender nil
 */
- (IBAction)pushClick:(id)sender
{
    LYWKWebViewController *webViewController = [[LYWKWebViewController alloc] init];
    webViewController.webViewControllerMode = WKWebViewReleaseMode;
    [webViewController loadURLString:@"http://yiguanjiaclub.org/commerce/listBanel.html?sid=863DE9933E5E9EF05876FF0917653A52"
                  shouldShowProgress:YES];
//    [webViewController loadLocalSource:@"index"
//                             extension:@"html"
//                    shouldShowProgress:YES];
    LYIOSWebManager *iOSWebManager = [LYIOSWebManager managerForWebViewController:webViewController];
    NSLog(@"CFGetRetainCount((__bridge CFTypeRef)(iOSWebManager)):%ld", CFGetRetainCount((__bridge CFTypeRef)(iOSWebManager)));
    [iOSWebManager registerFuncName:@"login" funcBlock:^(id param){
        NSLog(@"login");
    }];
    NSLog(@"CFGetRetainCount((__bridge CFTypeRef)(iOSWebManager)):%ld", CFGetRetainCount((__bridge CFTypeRef)(iOSWebManager)));
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
