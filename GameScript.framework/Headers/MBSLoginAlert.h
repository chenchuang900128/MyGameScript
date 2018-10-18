//
//  MBSLoginAlert.h
//  Game
//
//  Created by 陈创 on 2018/10/17.
//  Copyright © 2018年 陈创. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBSInputView;
@class UIViewExt;



//普通的block
typedef void(^CustomBlock)(id object);

@interface MBSLoginAlert : UIView

// 登录
-(instancetype)initWithTitle:(NSString *)title loginBlock:(CustomBlock)loginBlock andRegisterBlock:(CustomBlock)registBlock;

// 注册
-(instancetype)initWithRegisterTitle:(NSString *)title loginBlock:(CustomBlock)loginBlock andRegisterBlock:(CustomBlock)registBlock;

- (void)show;

- (void)hide;

@end
