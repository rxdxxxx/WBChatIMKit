//
//  WBRefreshHeaderView.h
//  WBRefreshDemo
//
//  Created by RedRain on 2018/3/7.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WBRefreshState) {
    WBRefreshStateIdle = 1,           // 闲置
    WBRefreshStateRefreshing,         // 刷新中
};
#define WBRefreshHeaderHeight (30)



@interface WBRefreshHeaderView : UIView

@property (nonatomic, assign) WBRefreshState state;

@end
