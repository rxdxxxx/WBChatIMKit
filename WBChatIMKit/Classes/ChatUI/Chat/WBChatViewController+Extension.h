//
//  WBChatViewController+Extension.h
//  AVOSCloud
//
//  Created by RedRain on 2018/3/15.
//

#import <WBChatIMKit/WBChatIMKit.h>

@interface WBChatViewController (Extension)

/**
 tableView是否在最底部
 */
- (BOOL)isTableViewBottomVisible;


/**
 向给定的消息数组中增加 `时间model`

 @param localMessages 给定的messageCellModel
 @return 添加完`时间model`的数组
 */
- (NSMutableArray *)appendTimerStampIntoMessageArray:(NSArray *)localMessages;


/**
 单独插入一条message到tableView中
 */
- (void)appendAMessageToTableView:(WBMessageModel *)aMessage;

/**
 刷新一条消息的状态
 
 @param aMessage 需要被属性的message
 */
- (void)refershAMessageState:(WBMessageModel *)aMessage;

/**
 下拉刷新时, 加载更多消息
 */
- (void)loadMoreMessage;
@end
