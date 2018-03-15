//
//  WBChatListManager.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBServiceSDKHeaders.h"

#define WBChatListUpdateNotification @"WBChatListUpdateNotification"

NS_ASSUME_NONNULL_BEGIN
@interface WBChatListManager : NSObject<WBDBCreater>

WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatListManager)

#pragma mark - 拉取服务器端的所有对话  
/**
 拉取服务器端的所有对话
 */
- (void)fetchAllConversationsFromServer:(void(^_Nullable)(NSArray<WBChatListModel *> * _Nullable conversations,
                                                          NSError * _Nullable error))block;
#pragma mark - 拉取本地的所有对话

/**
 拉取服务器端的所有对话
 */
- (void)fetchAllConversationsFromLocal:(void(^_Nullable)(NSArray<WBChatListModel *> * _Nullable conversations,
                                                         NSError * _Nullable error))block;
#pragma mark - 根据 conversationId 获取对话
/**
 *  根据 conversationId 获取对话
 *  @param conversationId   对话的 id
 */
- (void)fetchConversationWithConversationId:(NSString *)conversationId
                                   callback:(void (^_Nullable)(AVIMConversation * _Nullable conversation,
                                                               NSError * _Nullable error))callback;
#pragma mark - 根据 conversationId集合 获取对话
/**
 *  根据 conversationId数组 获取多个指定的会话信息
 */
- (void)fetchConversationsWithConversationIds:(NSSet *)conversationIds
                                     callback:(void (^_Nullable)(NSArray<AVIMConversation *> * _Nullable conversations,
                                                                 NSError * _Nullable error))callback;


#pragma mark - 更新最近一条消息记录到List
/**
 更新最近一条消息记录到List

 @param conversation 最近的会话信息
 */
- (void)insertConversationToList:(AVIMConversation *)conversation;


/**
 根据conversationId, 判断本地有没有对应的会话信息

 @param conversationId conversationId
 @return 是否已经存在
 */
- (BOOL)isExistWithConversationId:(NSString *)conversationId;

#pragma mark - 删除一个会话
/**
 删除一个会话

 @param conversationId 会话id
 */
- (void)deleteConversation:(NSString *)conversationId;

#pragma mark - 改变某个会话的会话状态
/**
 阅读了某个会话

 @param conversation 被阅读的会话
 */
- (void)readConversation:(AVIMConversation *)conversation;


@end
NS_ASSUME_NONNULL_END
