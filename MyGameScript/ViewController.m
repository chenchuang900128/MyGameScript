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

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@property(nonatomic,strong)MBSLoginAlert *regAlert;
@property(nonatomic,strong)MBSLoginAlert *logAlert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 200, kScreenWidth - 40, 40)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始游戏" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)btnClick:(UIButton *)sender{
    
    
    sender.hidden = YES;
#if 1
    // 注册弹框
    self.regAlert = [[MBSLoginAlert alloc] initWithRegisterTitle:@"注册账号" loginBlock:^(id object) {
        
        // 跳老用户登录
        [self.regAlert hide];
        // 登录弹框
        self.logAlert = [[MBSLoginAlert alloc] initWithTitle:@"用户登录" loginBlock:^(id object) {
            
            [self.logAlert hide];
            // 显示悬浮窗
            MBSSuspendControl *tmpControl = [[MBSSuspendControl alloc] initWithClickBlock:^(NSUInteger index) {
                
                NSLog(@"点击第几个%lu",index);
                switch (index) {
                    case 0:
                    {
                        
                    }
                        break;
                    case 1:
                    {
                        
                    }
                        break;
                    case 2:
                    {
                        
                    }
                        break;
                    case 3:
                    {
                        
                    }
                        break;
                    case 4:
                    {
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
            [tmpControl show];
            
        } andRegisterBlock:^(id object) {
            
            [self.logAlert hide];
            [self.regAlert show];
        }];
        [self.logAlert show];
        
        
    } andRegisterBlock:^(id object) {
        
        /*
         请求交易成功
         */
        
        [self.regAlert hide];
        
        
        // 显示悬浮窗
        MBSSuspendControl *tmpControl = [[MBSSuspendControl alloc] initWithClickBlock:^(NSUInteger index) {
            
            NSLog(@"点击第几个%lu",index);

            switch (index) {
                case 0:
                    {
                        
                    }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                case 3:
                {
                    
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }];
        [tmpControl show];
        
    }];
    
    [self.regAlert show];
    
#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
