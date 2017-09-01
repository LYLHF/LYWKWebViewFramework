//
//  ViewController.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/8.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
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
}

#pragma mark - func

/**
 搭建界面
 */
- (void)buildView
{
    LYWKWebView *webView = [[LYWKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadLocalSource:@"index"
                   extension:@"html"
          shouldShowProgress:YES];
//    [webView loadURLString:@"http://yiguanjiaclub.org/commerce/listBanel.html?sid=863DE9933E5E9EF05876FF0917653A52" shouldShowProgress:YES];
    LYIOSWebManager *iOSWebManager = [LYIOSWebManager managerFor:webView];
    [iOSWebManager registerFuncName:@"login" funcBlock:^(id param){
        NSLog(@"login");
    }];
    [self.view addSubview:webView];
    
    return;
}

@end
