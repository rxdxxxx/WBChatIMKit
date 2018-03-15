//
//  WBChatManager.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatManager.h"
#import "WBCoreConfiguration.h"
#import "WBChatKit.h"
#import "WBChatInfoDao.h"
#import "WBMessageModel.h"

@implementation WBChatManager
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBChatManager)

- (BOOL)createDBTable{
    return [[WBChatInfoDao sharedInstance] createDBTable];
}
#pragma mark - 创建一个Conversation
/**
 根据传入姓名和成员,获取到相应的Conversation对象
 */
- (void)createConversationWithName:(NSString *)name
                           members:(NSArray *)members
                 reuseConversation:(BOOL)reuseConversation
                          callback:(AVIMConversationResultBlock)callback {
    if (!self.connect) {
        if (callback) {
            callback(nil,[NSError wb_description:@"请检测当前网络状态"]);
        }
        return;
    }
    
    
    if (name == nil) {
        if (callback) {
            callback(nil,[NSError wb_description:@"请输入会话的名称"]);
        }
        return;
    }
    
    if (members.count == 0 ||
        (members.count == 1 && [members containsObject:self.client.clientId])) {
        if (callback) {
            callback(nil,[NSError wb_description:@"请选择参与会话的人员"]);
        }
        return;
    }
    
    if ([members containsObject:self.client.clientId] == NO) {
        // 如果成员, 不包含自己, 那么自动填充一个自己的ClientId
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:members];
        [tempArray addObject:self.client.clientId];
        members = tempArray;
    }
    
    
    // 1. YES: 如果相同 members 的对话已经存在，将返回原来的对话  NO:创建一个新对话
    AVIMConversationOption options = reuseConversation ? AVIMConversationOptionUnique : AVIMConversationOptionNone ;
    
    // 2. 区分会话的类型
    WBConversationType type = WBConversationTypeSingle;
    if (members.count > 2) {
        // 除去自己,还有第三个人
        type = WBConversationTypeDiscussion;
    }
    
    [self.client createConversationWithName:name clientIds:members attributes:@{ WBIM_CONVERSATION_TYPE : @(type) } options:options callback:callback];
}

#pragma mark - 往对话中发送消息。
/*!
 往对话中发送消息。
 @param message － 消息对象
 @param callback － 结果回调
 */
- (void)sendTargetConversation:(AVIMConversation *)targetConversation
                       message:(WBMessageModel *)message
                      callback:(AVIMBooleanResultBlock)callback{
    
    if (!targetConversation) {
        !callback ? : callback(NO,[NSError wb_description:@"目标会话信息有误."]);
        return;
    }
    
    if (!message) {
        !callback ? : callback(NO,[NSError wb_description:@"聊天信息有误."]);
        return;
    }
    
    [targetConversation sendMessage:message.content
                      progressBlock:^(NSInteger progress)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WBIMNotificationMessageUploadProgress
                                                            object:nil
                                                          userInfo:@{@"message":message,
                                                                     @"progress":@(progress)
                                                                     }];
    }
                           callback:callback];
}
#pragma mark - 加载聊天记录

- (void)queryTypedMessagesWithConversation:(AVIMConversation *)conversation
                              queryMessage:(AVIMMessage *)queryMessage
                                     limit:(NSInteger)limit
                                     block:(AVIMArrayResultBlock)block {
    
    AVIMArrayResultBlock callback = ^(NSArray *messages, NSError *error) {
        
        //以下过滤为了避免非法的消息，引起崩溃，确保展示的只有 AVIMTypedMessage 类型
        NSMutableArray *typedMessages = [NSMutableArray array];
        for (AVIMTypedMessage *message in messages) {
            [typedMessages addObject:[message wb_getValidTypedMessage]];
        }
        !block ?: block(typedMessages, error);
        
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        if(queryMessage.sendTimestamp == 0) {
            // 该方法能确保在有网络时总是从服务端拉取最新的消息，首次拉取必须使用该方法
            // sdk 会设置好 timestamp
            [conversation queryMessagesWithLimit:limit callback:callback];
        } else {
            //会先根据本地缓存判断是否有必要从服务端拉取，这个方法不能用于首次拉取
            [conversation queryMessagesBeforeId:queryMessage.messageId
                                      timestamp:queryMessage.sendTimestamp
                                          limit:limit
                                       callback:callback];
        }
    });
}
#pragma mark - 获取会话的信息
- (WBChatInfoModel *)chatInfoWithID:(NSString *)conversationId{
    return [[WBChatInfoDao sharedInstance] chatInfoWithID:conversationId];
}
#pragma mark - 草稿
- (BOOL)saveConversation:(NSString *)conversationId draft:(NSString *)draft{
    return [[WBChatInfoDao sharedInstance] saveConversation:conversationId draft:draft];
}

#pragma mark - Private Methods
- (AVIMClient *)client{
    return [WBChatKit sharedInstance].usingClient;
}
- (BOOL)connect{
    return [WBChatKit sharedInstance].connect;
}
@end
