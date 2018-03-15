//
//  UIScrollView+WBRefresh.m
//  WBRefreshDemo
//
//  Created by RedRain on 2018/3/7.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "UIScrollView+WBRefresh.h"
#import <objc/runtime.h>

#define WBRefreshKeyPathContentOffset @"contentOffset"

@implementation UIScrollView (WBRefresh)
- (void)wb_addRefreshHeaderViewWithBlock:(void (^)(void))headerBlock{
    self.wb_headerRefreshBlock = headerBlock;
    
    if (self.wb_headerView == nil) {
        self.wb_headerView = [[WBRefreshHeaderView alloc] initWithFrame:
                              CGRectMake(0,
                                         -WBRefreshHeaderHeight,
                                         [UIScreen mainScreen].bounds.size.width,
                                         WBRefreshHeaderHeight)];
        [self addSubview:self.wb_headerView];
    }
    
    [self addObserver:self forKeyPath:WBRefreshKeyPathContentOffset options:NSKeyValueObservingOptionNew context:nil];
}
- (void)removeFromSuperview{
    
}

- (void)wb_endRefreshing{
    self.wb_refreshState = WBRefreshStateIdle;
    self.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);

//    [UIView animateWithDuration:0.4 animations:^{
//    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (![keyPath isEqualToString:WBRefreshKeyPathContentOffset]) {
        return;
    }
    if (!self.dragging) {
        return;
    }
    if (self.contentOffset.y >= 0) {
        return;
    }
    if (self.wb_refreshState == WBRefreshStateRefreshing) {
        return;
    }
    
    if (self.contentOffset.y <= -WBRefreshHeaderHeight) {
        self.wb_refreshState = WBRefreshStateRefreshing;
    }else{
        self.wb_refreshState = WBRefreshStateIdle;
    }
}

#pragma mark - Setter or Getter
- (void)setWb_headerView:(WBRefreshHeaderView *)wb_headerView{
    objc_setAssociatedObject(self, @selector(wb_headerView), wb_headerView, OBJC_ASSOCIATION_RETAIN);
}
- (WBRefreshHeaderView *)wb_headerView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWb_refreshState:(WBRefreshState)wb_refreshState{
    objc_setAssociatedObject(self, @selector(wb_refreshState), @(wb_refreshState), OBJC_ASSOCIATION_COPY);
    
    self.wb_headerView.state = wb_refreshState;

    if (wb_refreshState == WBRefreshStateRefreshing) {
        self.contentInset = UIEdgeInsetsMake(WBRefreshHeaderHeight, 0, 10, 0);

        if (self.wb_headerRefreshBlock) {
            self.wb_headerRefreshBlock();
        }
    }
    

}
- (WBRefreshState)wb_refreshState{
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).integerValue;
}

- (void)setWb_headerRefreshBlock:(void (^)(void))wb_headerRefreshBlock{
    objc_setAssociatedObject(self, @selector(wb_headerRefreshBlock), wb_headerRefreshBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(void))wb_headerRefreshBlock{
    return objc_getAssociatedObject(self, _cmd);
}

@end
