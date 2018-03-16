//
//  WBMessageManager.m
//  WBChat
//
//  Created by RedRain on 2018/1/27.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBMessageManager.h"
#import "WBManagerHeaders.h"

@implementation WBMessageManager
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBMessageManager)

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    if (conversation == nil ||
        message == nil) {
        return;
    }
    
    
    // 如果本地没有信息
    if (!conversation.createAt &&
        ![[WBChatListManager sharedInstance]
          isExistWithConversationId:conversation.conversationId]) {
            
            // 拉取服务器最新数据。
            [conversation fetchWithCallback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    [self receiveMessage:message conversation:conversation];
                    
                    return;
                }
                
            }];
        }
    
    // 本地有该会话的信息
    else{
        [self receiveMessage:message conversation:conversation];
    }
}

#pragma mark - Private
- (void)receiveMessage:(AVIMTypedMessage *)message
          conversation:(AVIMConversation *)conversation {
    
    NSMutableDictionary *mDic = [NSMutableDictionary new];
    if (conversation) {
        mDic[WBMessageConversationKey] = conversation;
    }
    if (message) {
        mDic[WBMessageMessageKey] = message;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:WBMessageNewReceiveNotification object:nil
     userInfo:mDic];
}

@end

