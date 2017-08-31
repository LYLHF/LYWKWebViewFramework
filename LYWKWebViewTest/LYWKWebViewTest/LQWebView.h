//
//  LQWebView.h
//  LYWKWebViewTest
//
//  Created by 李勇 on 17/6/9.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQWebView : UIView

/**
 加载URL
 
 @param urlString URL地址
 */
- (void)loadURLString:(nonnull NSString *)urlString;

/**
 加载本地文件
 
 @param source 文件名
 @param extension 文件扩展
 */
- (void)loadLocalSource:(nullable NSString *)source extension:(nullable NSString *)extension;

/**
 注册供H5调用的方法

 @param name 方法名
 */
- (void)addScriptMethodName:(nonnull NSString *)name;

@end
