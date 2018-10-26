//
//  ViewController.m
//  MyGameScript
//
//  Created by 陈创 on 2018/10/18.
//  Copyright © 2018年 陈创. All rights reserved.
//

#import "ViewController.h"
#import <GameScript/MBSLoginAlert.h>
#import <GameScript/MBSSuspendControl.h>
#import <GameScript/MBSPrefixDefine.h>
#import <GameScript/CustomProgress.h>
#import "FBKVOController/FBKVOController.h"
#import "EXTScope/EXTScope.h"

@import WebKit;

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)MBSLoginAlert *regAlert;
@property(nonatomic,strong)MBSLoginAlert *logAlert;
@property(nonatomic,strong)MBSSuspendControl *tmpControl;
@property(nonatomic,strong)CustomProgress *loadProgress;


@property (nonatomic,strong)FBKVOController *KVOController;
@property (nonatomic,strong)WKWebView *currentWebView;

@end

@implementation ViewController{
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusH =  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    
    // WKWebView 创建
    self.currentWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, statusH, kScreenWidth, kScreenHeight - kIphoneXHomeHeight - statusH) configuration:[[WKWebViewConfiguration alloc] init]];
    self.currentWebView.navigationDelegate = self;
    self.currentWebView.UIDelegate = self;
    //打开左划回退功能
    [self.view addSubview:self.currentWebView];
    
    
    
    
    // FaceBook KVO框架
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    
    @weakify(self);
    // 注册观察者
    [self.KVOController observe:self.currentWebView keyPath:@"estimatedProgress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        
        @strongify(self);
        if (self.currentWebView.estimatedProgress > 0) {
            
            // 展示进度条值
            [self.loadProgress setProgress:self.currentWebView.estimatedProgress * 100];
            
        }
        
        if (self.currentWebView.estimatedProgress >= 1.0f) {
            
            /*
               .........
               网页加载完毕
             
             */
            
            // 隐藏登录弹框
            [self.logAlert hide];
            // 进度条隐藏
            [self.loadProgress hide];
        }
    }];
    
    
    
    // 开始游戏按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, kScreenHeight - 130, kScreenWidth - 40, 40)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始游戏" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    
    [self.view bringSubviewToFront:btn];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 开始游戏按钮事件
- (void)btnClick:(UIButton *)sender{
    
    @weakify(self);
    // 注册弹框
    self.regAlert = [[MBSLoginAlert alloc] initWithRegisterTitle:@"注册账号" loginBlock:^(id object) {
        @strongify(self);
        // 跳老用户登录
        [self.regAlert hide];
        
        // 登录弹框
        @weakify(self);
        self.logAlert = [[MBSLoginAlert alloc] initWithTitle:@"用户登录" loginBlock:^(id object) {
            /*
             .........
             登录交易成功
             
             */
            @strongify(self);
            // 登录弹框隐藏
            [self.logAlert hide];
            // 显示悬浮窗
            [self showSuspendControl];
            
        } andRegisterBlock:^(id object) {
            
            // 点击注册按钮
            @strongify(self);
             // 登录弹框隐藏 注册弹框显现
            [self.logAlert hide];
            [self.regAlert show];
        }];
        [self.logAlert show];
        
        
    } andRegisterBlock:^(id object) {
        
        /*
         .........
         注册交易成功
         
         */
        @strongify(self);
        // 注册弹框隐藏
        [self.regAlert hide];
        // 显示悬浮窗
        [self showSuspendControl];
        
        
    }];
    [self.regAlert show];
    
    
}


#pragma mark 显示悬浮窗事件
- (void)showSuspendControl{
    
    if (self.tmpControl) {
        [self.tmpControl removeFromSuperview];
    }
    
    @weakify(self);
    self.tmpControl = [[MBSSuspendControl alloc] initWithClickBlock:^(NSUInteger index) {
        
        @strongify(self);
        if (index == 0) {
            
            // 刷新按钮
            self.logAlert = [[MBSLoginAlert alloc] initWithTitle:@"用户登录" loginBlock:^(id object) {
                
                
            } andRegisterBlock:^(id object) {
                
                
            }];
            [self.logAlert show];
            
            // 加载进度条
            self.loadProgress = [[CustomProgress alloc] initWithFrame:CGRectMake(40, kScreenHeight - 60, kScreenWidth - 80, 30)];
            //设置背景色
            self.loadProgress.bgimg.backgroundColor =[UIColor colorWithWhite:0.1 alpha:0.1];
            // 设置进度条颜色
            self.loadProgress.leftimg.backgroundColor =[UIColor yellowColor];
            //设置进度条lab字体颜色
            self.loadProgress.presentlab.textColor = [UIColor grayColor];
            // 进度条显现
            [self.loadProgress show];
            
            //
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/29e0d8ab91f1"]];
            [self.currentWebView loadRequest:request];
            
            
            
        }
        else if(index == 1){
            
            // 账号
            NSLog(@"账号");
        }
        else if (index  == 2){
            
            // 客服
            NSLog(@"客服");
            
        }
        else if(index == 3){
            
            // 公告
            NSLog(@"公告");
            
        }
        else if (index  == 4){
            
            // 礼包
            NSLog(@"礼包");
            
        }
    }];
    [self.tmpControl show];
}




#pragma mark WKWebViewDelegate

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestStr = [[[navigationAction.request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"自定义跳转链接：%@",requestStr);
    
    if ([requestStr hasPrefix:@"nymbsbank://"])
    {
        // 分割字符串 返回数组
        NSArray *myArr = [requestStr componentsSeparatedByString:@"/"];
        if ([myArr count]) {
            // 获取后半段重要字符串
            NSString *valueStr = [myArr lastObject];
            // 分割字符串 返回数组
            myArr = [valueStr componentsSeparatedByString:@"?"];
            if ([myArr count]) {
                // 获取跳转标志字符串
                NSString *flagStr = (NSString *)[myArr firstObject];
                // 获取参数
                // NSString *paramStr = (NSString *)[myArr lastObject];
                if ([flagStr isEqualToString:@"back"]) {
                    
                    // 导航栏返回
                }
                else if ([flagStr isEqualToString:@"main"]) {
                    // 跳转到主页

                    
                }
                else if ([flagStr isEqualToString:@"login"]) {
                    // 跳转到登陆

                    
                    
                }
                
                
            }
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


// 当开始发送请求时调用
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


// 当请求过程中出现错误时调用
- (void)webView:(WKWebView*)webView didFailNavigation:(WKNavigation*)navigation withError:(NSError *)error {
    NSLog(@"%@= %s",error, __FUNCTION__);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// 当开始发送请求时出错调用
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError *)error {
    NSLog(@"%@= %s",error, __FUNCTION__);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}



// 当网页加载完毕时调用：该方法使用最频繁
- (void)webView:(WKWebView*)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 将web视图置首
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
