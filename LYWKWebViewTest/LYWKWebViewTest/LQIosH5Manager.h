//
//  LQIosH5Manager.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface LQIosH5Manager : NSObject<WKScriptMessageHandler>

/**
 创建的类方法

 @param webView webView
 @return 创建好的manager
 */
+ (instancetype)managerForWebView:(WKWebView *)webView;

//- (void)test:(NSString *)str;

@end
