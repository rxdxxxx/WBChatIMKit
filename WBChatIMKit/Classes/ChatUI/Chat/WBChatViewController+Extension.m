//
//  WBChatViewController+Extension.m
//  AVOSCloud
//
//  Created by RedRain on 2018/3/15.
//

#import "WBChatViewController+Extension.h"

@implementation WBChatViewController (Extension)
/**
 tableView是否在最底部
 */
- (BOOL)isTableViewBottomVisible{
    BOOL isScroolBottom = NO;
    
    if (self.tableView.visibleCells.count == 0) {
        return YES;
    }
    
    if (self.tableView.visibleCells.count &&
        ([self.tableView.visibleCells.lastObject isKindOfClass:[WBChatMessageBaseCell class]])) {
        
        
        WBChatMessageBaseCellModel* lastFrameModel =((WBChatMessageBaseCell*)self.tableView.visibleCells.lastObject).cellModel;
        if ( lastFrameModel == self.dataArray.lastObject) {
            isScroolBottom = YES;
        }
        
    }
    return isScroolBottom;
}

/**
 向给定的消息数组中增加 `时间model`
 
 @param localMessages 给定的messageCellModel
 @return 添加完`时间model`的数组
 */
- (NSMutableArray *)appendTimerStampIntoMessageArray:(NSArray *)localMessages{
    
    NSMutableArray *messagesArray = [[NSMutableArray alloc]initWithCapacity:20];
    
    if (localMessages.count == 0) {
        return messagesArray;
    }
    
    //当前会话中的消息<kNum条
    for (NSInteger i = 0; i < localMessages.count; i++) {
        
        WBChatMessageBaseCellModel *firstModel = localMessages[i];
        
        //第一条消息的时间和第一条数据插入数组
        if (messagesArray.count <= 0) {
            
            WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:firstModel.cellTimeStamp];
            [messagesArray addObject:timeFM];
            
            [messagesArray addObject:firstModel];
            
        }
        
        //比较当前消息和下一条消息的时间
        NSInteger j = i + 1;
        if(j < localMessages.count){
            
            WBChatMessageBaseCellModel *secondModel = localMessages[j];
            
            // 3.1,处理时间
            //判断两条会话时间，是否在3分钟
            BOOL timeOffset = [NSDate wb_miniteInterval:3 firstTime:firstModel.cellTimeStamp secondTime:secondModel.cellTimeStamp];
            if (timeOffset) {
                WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:secondModel.cellTimeStamp];
                [messagesArray addObject:timeFM];
            }
            [messagesArray addObject:secondModel];
        }
    }
    
    return messagesArray;
}

/**
 单独插入一条message到tableView中
 */
- (void)appendAMessageToTableView:(WBMessageModel *)aMessage{
    NSMutableArray *messagesArray = [[NSMutableArray alloc]initWithCapacity:20];
    
    WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:aMessage];
    
    // 如果没有消息, 增加一个时间
    if (self.dataArray.count == 0) {
        WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:cellModel.cellTimeStamp];
        [messagesArray addObject:timeFM];
    }
    
    // 如果有消息, 和上一条消息的时间间隔
    else{
        WBChatMessageBaseCellModel *lastCellModel = self.dataArray.lastObject;
        
        BOOL timeOffset = [NSDate wb_miniteInterval:3 firstTime:cellModel.cellTimeStamp secondTime:lastCellModel.cellTimeStamp];
        if (timeOffset) {
            WBChatMessageTimeCellModel *timeFM = [WBChatMessageTimeCellModel modelWithTimeStamp:cellModel.cellTimeStamp];
            [messagesArray addObject:timeFM];
        }
    }
    [messagesArray addObject:cellModel];
    
    [self.dataArray addObjectsFromArray:messagesArray];
    [self.tableView reloadData];
}

/**
 刷新一条消息的状态

 @param aMessage 需要被属性的message
 */
- (void)refershAMessageState:(WBMessageModel *)aMessage{
    // todo: 待完善刷新单独一条
    for (NSInteger i = self.dataArray.count - 1; i >=0 ; i--) {
        WBChatMessageBaseCellModel *cellModel = self.dataArray[i];
        if (cellModel.messageModel == aMessage) {
            //            NSInteger index = [self.dataArray indexOfObject:cellModel];
            [self.tableView reloadData];
            break;
        }
    }
}



/**
 下拉刷新时, 加载更多消息
 */
- (void)loadMoreMessage{
    
    AVIMMessage *lastMessage = nil;
    for (WBChatMessageBaseCellModel *cellModel in self.dataArray) {
        if (cellModel.messageModel.content != nil) {
            lastMessage = cellModel.messageModel.content;
            break;
        }
    }
    
    [[WBChatKit sharedInstance] queryTypedMessagesWithConversation:self.conversation
                                                      queryMessage:lastMessage
                                                             limit:20
                                                           success:^(NSArray<WBMessageModel *> * messageArray)
     {
         
         NSMutableArray *temp = [NSMutableArray new];
         for (WBMessageModel *message in messageArray) {
             WBChatMessageBaseCellModel *cellModel = [WBChatMessageBaseCellModel modelWithMessageModel:message];
             [temp addObject:cellModel];
         }
         
         NSMutableArray *newLoadMessage = [self appendTimerStampIntoMessageArray:temp];
         
         NSUInteger loadMoreMessageCount = newLoadMessage.count;
         
         if (self.dataArray.count) {
             [newLoadMessage addObjectsFromArray:self.dataArray];
             self.dataArray = newLoadMessage;
             [self.tableView reloadData];
             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:loadMoreMessageCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
             
         }else{
             self.dataArray = newLoadMessage;
             [self.tableView reloadData];
             [self.tableView wb_scrollToBottomAnimated:NO];
         }
         
         [self.tableView wb_endRefreshing];
         
     } error:^(NSError * _Nonnull error) {
         
     }];
}
@end
