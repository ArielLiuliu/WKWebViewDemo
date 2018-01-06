//
//  ViewController.h
//  WKWebViewDemo
//
//  Created by lx on 2018/1/6.
//  Copyright © 2018年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) NSString *content;//保存网页内容
@property (nonatomic, strong) NSString *webForeGroundColor;//网页前景色
@property (nonatomic, strong) NSString *webBackGroundColor;//网页背景色

@end

