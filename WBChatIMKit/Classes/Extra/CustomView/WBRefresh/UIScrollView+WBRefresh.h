//
//  UIScrollView+WBRefresh.h
//  WBRefreshDemo
//
//  Created by RedRain on 2018/3/7.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBRefreshHeaderView.h"



@interface UIScrollView (WBRefresh)

// 头部刷新视图
@property (nonatomic, strong) WBRefreshHeaderView *wb_headerView;

// 当前头部视图刷新的状态
@property (nonatomic, assign) WBRefreshState wb_refreshState;

@property (nonatomic, copy) void (^wb_headerRefreshBlock)(void);

- (void)wb_addRefreshHeaderViewWithBlock:(void (^)(void))headerBlock;
- (void)wb_endRefreshing;

@end
