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
    // 测试Object-C调用JavaScript方法
    UIButton *OCtransferJS = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, 200, 40)];
    [OCtransferJS addTarget:self action:@selector(transferJSFunction) forControlEvents:UIControlEventTouchUpInside];
    [OCtransferJS setTitle:@"调用JS方法" forState:UIControlStateNormal];
    [OCtransferJS setTintColor:[UIColor whiteColor]];
    OCtransferJS.backgroundColor = [UIColor colorWithRed:0.153 green:0.467 blue:0.792 alpha:1.00];
    [self.view addSubview:OCtransferJS];
    
    // 测试JavaScript调用Object-C方法
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(OCtransferJS.frame)+10, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(OCtransferJS.frame) - 10)];
    _webView.delegate = self;
    NSString *H5bundle = [[NSBundle mainBundle] pathForResource:@"Html5" ofType:@"bundle"];
    NSString *htmlFile = [H5bundle stringByAppendingPathComponent:@"JSFirstPage.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFile]]];
    [self.view addSubview:self.webView];
    NSLog(@"%@",self.navigationController);

}
#pragma mark - 测试Object-C调用JavaScript方法
- (void)transferJSFunction{
    NSDictionary *dict = @{@"dataOne":@"one",@"dataTwo":@"two"};
    NSString *str = [self toJsonWithObject:dict];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"OCTransferJS(%@)",str]];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = [request.URL.absoluteString stringByRemovingPercentEncoding];

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
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification) name:@"UIAlertPost" object:nil];
}
- (void)showNotification{
    
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ensureAction];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}
static BOOL clickState = NO;
static NSInteger btnIndex = -1;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    NSString *otherButtonText = @"确定";
    NSString *cancelButtonText = @"取消";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickActionButton:0];
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:otherButtonText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clickActionButton:1];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:ensureAction];
    UIViewController *rootViewController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    btnIndex = -1;
    while (btnIndex == -1) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (btnIndex == 0){
        // 取消
        clickState = NO;
    }else if (btnIndex == 1) {
        // 确定
        clickState = YES;
    }
    return clickState;
}
- (void)clickActionButton:(NSInteger)buttonIndex{
    btnIndex = buttonIndex;
}


@end
