//
//  UIView+NextResponder.h
//  IOSStudy
//
//  Created by gtexpress on 15/3/20.
//  Copyright (c) 2015年 ETHAN_chenliang. All rights reserved.
//

#import <UIKit/UIKit.h>

//获取UIView当前所在控制器
@interface UIView (NextResponder)

- (UIViewController *)lcg_viewController;


/**
 使用Xib创建View, 需要xib文件和类名一致.

 @return view实例
 */
+ (instancetype)lcg_viewFromXib;

@end
