//
//  WBChatManager.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "WBChatInfoModel.h"

@class WBMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface WBChatManager : NSObject<WBDBCreater>
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatManager)

#pragma mark - 创建一个Conversation

/**
 根据传入姓名和成员,获取到相应的Conversation对象

 @param name 会话的名称
 @param members 成员clientId的数组
 @param reuseConversation 是否复用 `AVIMConversation`
 */
- (void)createConversationWithName:(NSString *)name
                           members:(NSArray *)members
                 reuseConversation:(BOOL)reuseConversation
                          callback:(AVIMConversationResultBlock)callback;

#pragma mark - 往对话中发送消息。
/*!
 往对话中发送消息。
 @param message － 消息对象
 @param callback － 结果回调
 */
- (void)sendTargetConversation:(AVIMConversation *)targetConversation
                       message:(WBMessageModel *)message
                      callback:(AVIMBooleanResultBlock)callback;


#pragma mark - 加载聊天记录
/**
 加载聊天记录

 @param conversation 对应的会话
 @param queryMessage 锚点message, 如果是nil:(该方法能确保在有网络时总是从服务端拉取最新的消息，首次拉取必须使用是nil或者sendTimestamp为0)
 @param limit 拉取的条数
 */
- (void)queryTypedMessagesWithConversation:(AVIMConversation *)conversation
                              queryMessage:(AVIMMessage * _Nullable)queryMessage
                                     limit:(NSInteger)limit
                                     block:(AVIMArrayResultBlock)block;

#pragma mark - 获取会话的信息
- (WBChatInfoModel *)chatInfoWithID:(NSString *)conversationId;

#pragma mark - 草稿
- (BOOL)saveConversation:(NSString *)conversationId draft:(NSString *)draft;
@end
NS_ASSUME_NONNULL_END
