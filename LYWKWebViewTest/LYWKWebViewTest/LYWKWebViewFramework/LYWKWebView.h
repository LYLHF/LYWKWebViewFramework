//
//  LYWKWebView.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface LYWKWebView : UIView

//webView
@property (nonatomic, strong) WKWebView *webView;

/**
 加载URL
 
 @param urlString URL地址
 @param shouldShow 是否应该显示html文件的下载进度
 */
- (void)loadURLString:(nonnull NSString *)urlString shouldShowProgress:(BOOL)shouldShow;

/**
 加载本地文件
 
 @param source 文件名
 @param extension 文件扩展
 */
- (void)loadLocalSource:(nullable NSString *)source extension:(nullable NSString *)extension;

/**
 添加一个script方法
 
 @param scriptMessageHandler native-web桥接对象
 @param name 方法名
 */
- (void)customAddScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name;

@end
