//
//  UIView+NextResponder.m
//  IOSStudy
//
//  Created by gtexpress on 15/3/20.
//  Copyright (c) 2015年 ETHAN_chenliang. All rights reserved.
//

#import "UIView+NextResponder.h"

@implementation UIView (NextResponder)

//获取上一级响应者
- (UIViewController *)lcg_viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

+ (instancetype)lcg_viewFromXib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end
