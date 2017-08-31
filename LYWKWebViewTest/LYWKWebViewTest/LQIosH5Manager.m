//
//  LQIosH5Manager.m
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LQIosH5Manager.h"

@interface LQIosH5Manager()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation LQIosH5Manager

#pragma mark - func

/**
 创建的类方法
 
 @param webView webView
 @return 创建好的manager
 */
+ (instancetype)managerForWebView:(WKWebView *)webView
{
    LQIosH5Manager *manager = [[LQIosH5Manager alloc] init];
    manager.webView = webView;
    
    return manager;
}

- (void)test:(id)str
{
    NSLog(@"%@", str);
}

- (void)diciationaryMethod:(id)dic
{
    NSLog(@"diciationaryMethod:%@", dic);
}

- (NSString *)nativeInit:(id)str
{
    return @"nativeInit";
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (message.webView != self.webView)
    {
        return;
    }
    
    if (message.body != nil)
    {
        //有参数
        NSString *selectorStr = [NSString stringWithFormat:@"%@:", message.name];
        SEL selector = NSSelectorFromString(selectorStr);
        if ([self respondsToSelector:selector])
        {
            IMP imp = [self methodForSelector:selector];
//            void (*func)(id, SEL, id) = (void *)imp;
//            func(self, selector, message.body);
//            (NSString *)(*func)(id, SEL, id) = (NSString *)imp;
//            func()
        }
    }else{
        //无参数
        SEL selector = NSSelectorFromString(message.name);
        if ([self respondsToSelector:selector])
        {
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        }
    }
}


@end
