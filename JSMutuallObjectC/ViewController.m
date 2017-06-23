//
//  ViewController.m
//  JSMutuallObjectC
//
//  Created by 王盛魁 on 2017/6/23.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSMutuallyObjectC.h"

@interface ViewController ()<UIWebViewDelegate,JSMutuallyObjectCDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *OCtransferJS = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, 200, 40)];
    [OCtransferJS addTarget:self action:@selector(transferJSFunction) forControlEvents:UIControlEventTouchUpInside];
    [OCtransferJS setTitle:@"调用JS方法" forState:UIControlStateNormal];
    [OCtransferJS setTintColor:[UIColor whiteColor]];
    OCtransferJS.backgroundColor = [UIColor colorWithRed:0.153 green:0.467 blue:0.792 alpha:1.00];
    [self.view addSubview:OCtransferJS];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(OCtransferJS.frame)+10, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(OCtransferJS.frame) - 10)];
    _webView.backgroundColor = [UIColor redColor];
    _webView.delegate = self;
    NSString *H5bundle = [[NSBundle mainBundle] pathForResource:@"Html5" ofType:@"bundle"];
    NSString *htmlFile = [H5bundle stringByAppendingPathComponent:@"JSFirstPage.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    [self.view addSubview:self.webView];

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)transferJSFunction{
    NSDictionary *dict = @{@"dataOne":@"one",@"dataTwo":@"two"};
    NSString *str = [self toJsonWithObject:dict];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"OCTransferJS(%@)",str]];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlStr === %@",urlStr);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView   valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSMutuallyObjectC *jsandOC = [JSMutuallyObjectC new];
    jsandOC.delegate = self;
    context[@"iOS"] = jsandOC;
    
}
#pragma mark - JSMutuallyObjectCDelegate
- (void)DelegateTestNOParameter{
    NSLog(@"this is ios TestNOParameter");
}
- (void)DelegateTestOneParameter:(NSString *)message{
    NSLog(@"this is ios TestOneParameter == %@",message);
}
- (void)DelegateTestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2{
    NSLog(@"this is ios TestTowParameter == %@  Second == %@",message1,message2);
}
- (void)DelegateGetDataWithDic:(NSDictionary *)dict{
    NSLog(@"this is dict == %@",dict);
}
- (NSString *)DelegateGetSomeData{
    NSDictionary *returnDict = @{@"first1":@"##1-",@"second2":@"2"};
    NSString * returnString = [self toJsonWithObject:returnDict];
    return returnString;
}

- (NSString *)toJsonWithObject:(id)obj{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [customAlert show];
}
static BOOL diagStat = NO;
static NSInteger bIdx = -1;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    NSString *cancelButtonText = @"取消";
    NSString *otherButtonText = @"确定";
    
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:cancelButtonText
                                                otherButtonTitles:otherButtonText, nil];
    
    [confirmDiag show];
    bIdx = -1;
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){//取消;
        diagStat = NO;
    }
    else if (bIdx == 1) {//确定;
        diagStat = YES;
    }
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    bIdx = buttonIndex;
}

@end
