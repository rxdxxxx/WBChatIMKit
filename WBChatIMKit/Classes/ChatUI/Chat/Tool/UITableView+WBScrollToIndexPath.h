//
//  UITableView+WBScrollToIndexPath.h


#import <UIKit/UIKit.h>

@interface UITableView (WBScrollToIndexPath)
/**
 *  TableView滚动到底部
 *
 *  @param animated 是否有动画
 */
-(void)wb_scrollToBottomAnimated:(BOOL)animated;

/**
 *  TableView滚动到指定的indexPath
 *
 *  @param indexPath 滚动到的目标行
 *  @param animated  是否有动画
 */
- (void)wb_scrollToIndexPath:(NSIndexPath*)indexPath Animated:(BOOL)animated;

/**
 *  TableView滚动到指定的indexPath
 *
 *  @param indexPath 滚动到的目标行
 *  @param postion   tablev滚动显示的位置
 *  @param animated  是否有动画
 */
- (void)wb_scrollToIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)postion Animated:(BOOL)animated;

@end
