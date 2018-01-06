//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by lx on 2018/1/6.
//  Copyright © 2018年 lx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //显示网页
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    //配置网页前景色&背景色
    self.webForeGroundColor = @"#0D1931";
    self.webBackGroundColor = @"#E9E9E0";
    
    self.fontSize = 100;//设置网页字体
    
    //请求网求html脚本
    [self sessionToGetRequest];
}

/**
 @功能说明：使用NSURLSession进行简单的异步get请求
 @参数说明：无
 @返回值：空
 */
- (void)sessionToGetRequest {
    NSString *strURL = @"http://yidahulianapp.oss-cn-shenzhen.aliyuncs.com/app1/api/GetHtmlCode.action/id=651172360";
    NSURLSession *session = [NSURLSession sharedSession];// 快捷方式获得session对象
    NSURL *url = [NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *contentDic = dic[@"root"][@"content"];
            self.content = contentDic[@"content"];
            
            dispatch_async(dispatch_get_main_queue(), ^{ //主线程显示，刷新界面只能在主线程中!!
                [self reloadWeb];
            });
        } else {
            NSLog(@"get请求失败=%@", error);
        }
    }];
    
    // 启动任务
    [task resume];
}

- (void)reloadWeb {
    [self.webView loadHTMLString:self.content baseURL:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
#if 1
    //修改网页里所有图片的大小
    NSString *meta = [NSString stringWithFormat:@"var script = document.createElement('script');"
                      "script.type = 'text/javascript';"
                      "script.text = \"function ResizeImages() { "
                      "var myimg;"
                      "var maxwidth=%f;"//缩放系数
                      "for(i=0;i <document.images.length;i++){"
                      "myimg = document.images[i];"
                      "if(myimg.width >= maxwidth){"
                      "myimg.width = maxwidth;"
                      "myimg.height = myimg.height;"
                      "}"
                      "}"
                      "}\";"
                      "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();", webView.bounds.size.width-20];
    [webView evaluateJavaScript:meta completionHandler:^(id wid, NSError * _Nullable error) {}];
#endif
    
#if 1
    //修改网页字体颜色
    NSString *script2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor='%@'", self.webForeGroundColor];
    [webView evaluateJavaScript:script2 completionHandler:^(id wid, NSError * _Nullable error) {}];//#2C4269表示十六进制颜色，可以与RGB互转
    
    //修改网页背景色
    script2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='%@'", self.webBackGroundColor];
    [webView evaluateJavaScript:script2 completionHandler:^(id wid, NSError * _Nullable error) {}];//#0D1931表示十六进制颜色，可以与RGB互转
#endif
    
#if 1
    //修改网页里字体的大小
    NSString *script = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", self.fontSize];
    [webView evaluateJavaScript:script completionHandler:^(id wid, NSError * _Nullable error) {}];
#endif
    
#if 1
    //禁止网页自带的复制，选中功能
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id wid, NSError * _Nullable error) { }];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id wid, NSError * _Nullable error) { }];
#endif
    
#if 1
    //动态获取webview的内容总高度
    [webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id wid, NSError * _Nullable error) {
        NSLog(@"webview的内容总高度=%f",((NSNumber*)wid).floatValue);
    }];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
