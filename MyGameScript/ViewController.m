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
#import "EXTScope.h"

@interface ViewController ()

@property(nonatomic,strong)MBSLoginAlert *regAlert;
@property(nonatomic,strong)MBSLoginAlert *logAlert;
@property(nonatomic,strong)MBSSuspendControl *tmpControl;
@property(nonatomic,strong)CustomProgress *loadProgress;
@property(nonatomic,strong)NSTimer *tmpTimer;

@end

@implementation ViewController{
    
    NSUInteger progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    progress = 0;
    
    // 开始游戏按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, kScreenHeight - 130, kScreenWidth - 40, 40)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始游戏" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
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
            @strongify(self);
            [self.logAlert hide];
            // 显示悬浮窗
            [self showSuspendControl];
            
        } andRegisterBlock:^(id object) {
            
            @strongify(self);
            [self.logAlert hide];
            [self.regAlert show];
        }];
        [self.logAlert show];
        
        
    } andRegisterBlock:^(id object) {
        
        /*
         请求交易成功
         */
        @strongify(self);
        
        [self.regAlert hide];
        
        // 显示悬浮窗
        [self showSuspendControl];
        
        
    }];
    
    [self.regAlert show];
    
    
}


- (void)showSuspendControl{
    
    if (self.tmpControl) {
        [self.tmpControl removeFromSuperview];
    }
    
    @weakify(self);
    self.tmpControl = [[MBSSuspendControl alloc] initWithClickBlock:^(NSUInteger index) {
        
        @strongify(self);
        if (index == 0) {
            
            // 刷新
            self.logAlert = [[MBSLoginAlert alloc] initWithTitle:@"用户登录" loginBlock:^(id object) {
                
                
                
            } andRegisterBlock:^(id object) {
                
                
            }];
            [self.logAlert show];
            
            
            // 加载进度条
            self.loadProgress = [[CustomProgress alloc] initWithFrame:CGRectMake(40, kScreenHeight - 60, kScreenWidth - 80, 30)];
            //设置背景色
            self.loadProgress.bgimg.backgroundColor =[UIColor colorWithWhite:0.1 alpha:0.1];
            self.loadProgress.leftimg.backgroundColor =[UIColor yellowColor];
            //可以更改lab字体颜色
            self.loadProgress.presentlab.textColor = [UIColor grayColor];
            [self.loadProgress show];
            
            self.tmpTimer =[NSTimer scheduledTimerWithTimeInterval:0.03
                                                            target:self
                                                          selector:@selector(timer)
                                                          userInfo:nil
                                                           repeats:YES];
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

#pragma mark 定时器事件
-(void)timer
{
    progress++;
    if (progress <= self.loadProgress.maxValue) {
        
        [self.loadProgress setProgress:progress];
        
    }else
    {
        
        [self.tmpTimer invalidate];
        self.tmpTimer = nil;
        progress = 0;
        [self.loadProgress hide];
        [self.logAlert hide];
    }
    
    
}

#pragma mark 重写dealloc方法
-(void)dealloc{
    
    if ([self.tmpTimer isValid]) {
        
        [self.tmpTimer invalidate];
        self.tmpTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
