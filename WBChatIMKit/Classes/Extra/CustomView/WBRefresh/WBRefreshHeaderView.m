//
//  WBRefreshHeaderView.m
//  WBRefreshDemo
//
//  Created by RedRain on 2018/3/7.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBRefreshHeaderView.h"

@interface WBRefreshHeaderView ()

@property (nonatomic, strong) UIActivityIndicatorView *refreshView;

@end

@implementation WBRefreshHeaderView
- (void)dealloc{
    [self.superview removeObserver:self.superview forKeyPath:@"contentOffset"];

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _refreshView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshView.hidden = YES;
        [_refreshView startAnimating];
        [self addSubview:_refreshView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.refreshView.center = CGPointMake(([UIScreen mainScreen].bounds.size.width)/ 2 - 10,
                                          self.bounds.size.height - 20);
}

- (void)setState:(WBRefreshState)state{
    _state = state;

    self.refreshView.hidden = (state != WBRefreshStateRefreshing);    
    
}

@end
